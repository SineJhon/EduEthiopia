import 'package:flutter/material.dart';

import '../../../core/design/app_dimensions.dart';
import '../../../core/widgets/theme_toggle.dart';
import '../../../core/widgets/animated/page_transition.dart';
import 'quiz_data.dart';
import 'quiz_progress_service.dart';
import 'quiz_screen.dart';

/// Screen shown after selecting a subject in Practice & Quiz.
class UnitSelectionScreen extends StatefulWidget {
  const UnitSelectionScreen({
    required this.subject,
    this.isAmharic = false,
    super.key,
  });

  final String subject;
  final bool isAmharic;

  @override
  State<UnitSelectionScreen> createState() => _UnitSelectionScreenState();
}

class _UnitSelectionScreenState extends State<UnitSelectionScreen> {
  late final bool _isAmharic = widget.isAmharic;
  List<QuizUnit> _units = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final units = quizUnitsForSubject(widget.subject);
    if (!mounted) return;
    setState(() {
      _units = units;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.subject,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: const [ThemeToggle(), SizedBox(width: 8)],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _units.isEmpty
            ? Center(
                child: Text(
                  'No practice units available.',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              )
            : ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.md,
                  AppDimensions.sm,
                  AppDimensions.md,
                  AppDimensions.lg,
                ),
                itemCount: _units.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final unit = _units[index];
                  return _UnitCard(
                    unit: unit,
                    subject: widget.subject,
                    position: index + 1,
                    isAmharic: _isAmharic,
                    showProgress: widget.subject !=
                        'Communicative English Language Skills',
                  );
                },
              ),
      ),
    );
  }
}

class _UnitCard extends StatelessWidget {
  const _UnitCard({
    required this.unit,
    required this.subject,
    required this.position,
    required this.isAmharic,
    required this.showProgress,
  });

  final QuizUnit unit;
  final String subject;
  final int position;
  final bool isAmharic;
  final bool showProgress;

  String _unitTitle(String title) {
    if (!isAmharic) return title;
    switch (title) {
      case 'Study Skills':
        return 'ማስታወሻዎች';
      case 'Health and Fitness':
        return 'ጤና እና ፍጥነት';
      case 'Cultural Values':
        return 'ባህላዊ ወደፊቶች';
      case 'Wildlife':
        return 'የኵር እና የተራራችን እውነት';
      case 'Population':
        return 'የህግደባችን ቁጥር';
      default:
        return title;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return FutureBuilder<UnitProgress?>(
      future: showProgress
          ? QuizProgressService.instance.getUnitProgress(unit.unitId)
          : Future<UnitProgress?>.value(null),
      builder: (context, snapshot) {
        final progress = snapshot.data;
        final hasAttempted = (progress?.attempts ?? 0) > 0;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
          child: InkWell(
            onTap: () {
              slideFadePush<void>(
                context,
                (_) => QuizScreen(subject: subject, unit: unit),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '$position',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _unitTitle(unit.title),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: colorScheme.onSurface,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${unit.totalQuestions} questions • ${unit.readingPassage != null ? 'includes reading passage' : ''}',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                        if (showProgress && hasAttempted && progress != null) ...[
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: progress.bestPercentage / 100,
                            backgroundColor: colorScheme.surfaceContainerLow,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Best: ${progress.bestScore}/${unit.totalQuestions} (${progress.bestPercentage.toStringAsFixed(0)}%) • ${progress.attempts} attempt${progress.attempts == 1 ? '' : 's'}',
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
