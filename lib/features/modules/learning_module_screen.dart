import 'package:flutter/material.dart';

import '../../core/localization/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/animated/animated_widgets.dart';
import '../../core/widgets/language_toggle.dart';
import '../../core/widgets/theme_toggle.dart';

enum LearningModule { modules, notes, videos, exams }

class LearningModuleScreen extends StatefulWidget {
  const LearningModuleScreen({
    required this.module,
    this.isAmharic = false,
    this.onLanguageChanged,
    super.key,
  });

  final LearningModule module;
  final bool isAmharic;
  final ValueChanged<bool>? onLanguageChanged;

  @override
  State<LearningModuleScreen> createState() => _LearningModuleScreenState();
}

class _LearningModuleScreenState extends State<LearningModuleScreen> {
  late bool _isAmharic = widget.isAmharic;

  String _title(AppStrings strings) {
    switch (widget.module) {
      case LearningModule.modules:
        return strings.modules;
      case LearningModule.notes:
        return strings.notes;
      case LearningModule.videos:
        return strings.videos;
      case LearningModule.exams:
        return strings.exams;
    }
  }

  IconData get _icon {
    switch (widget.module) {
      case LearningModule.modules:
        return Icons.apps_rounded;
      case LearningModule.notes:
        return Icons.menu_book_rounded;
      case LearningModule.videos:
        return Icons.play_circle_fill_rounded;
      case LearningModule.exams:
        return Icons.fact_check_rounded;
    }
  }

  Color get _color {
    switch (widget.module) {
      case LearningModule.modules:
        return AppColors.green;
      case LearningModule.notes:
        return AppColors.green;
      case LearningModule.videos:
        return const Color(0xFF2C7A7B);
      case LearningModule.exams:
        return AppColors.burgundy;
    }
  }

  List<String> _items(AppStrings strings) {
    switch (widget.module) {
      case LearningModule.modules:
        return [
          'Freshman Mathematics',
          'General Physics',
          'Communicative English',
          'Introduction to Computing',
        ];
      case LearningModule.notes:
        return [
          'Freshman Mathematics',
          'General Physics',
          'Communicative English',
          'Introduction to Computing',
        ];
      case LearningModule.videos:
        return [
          'Calculus foundations',
          'Physics problem solving',
          'Study skills for freshmen',
          'Department preparation guide',
        ];
      case LearningModule.exams:
        return [
          'COC exam preparation',
          strings.midExams,
          strings.finalExams,
          strings.quizzes,
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(_isAmharic);
    final items = _items(strings);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title(strings),
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          const ThemeToggle(),
          const SizedBox(width: 10),
          LanguageToggle(
            isAmharic: _isAmharic,
            onChanged: (value) {
              setState(() => _isAmharic = value);
              widget.onLanguageChanged?.call(value);
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Reveal(
              duration: 700,
              delay: 100,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: _color,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_icon, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            strings.modulePreview,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _subtitle(strings),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.lock_outline_rounded,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _title(strings),
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                  Text(
                    '${items.length} items',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Reveal(
                duration: 700,
                delay: 300,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 2, 16, 24),
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Material(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '$item is ready for content integration.',
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: _color.withValues(alpha: 0.9),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 13,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: _color.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(_icon, color: _color, size: 24),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                size: 20,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _subtitle(AppStrings strings) {
    switch (widget.module) {
      case LearningModule.modules:
        return strings.modulesDescription;
      case LearningModule.notes:
        return strings.notesDescription;
      case LearningModule.videos:
        return strings.videosDescription;
      case LearningModule.exams:
        return strings.examsDescription;
    }
  }
}
