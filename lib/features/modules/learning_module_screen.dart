import 'package:flutter/material.dart';

import '../../core/design/app_dimensions.dart';
import '../../core/design/app_typography.dart';
import '../../core/design/category_config.dart';
import '../../core/design/reusable_widgets.dart';
import '../../core/localization/app_strings.dart';
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

  LearningCategory get _category {
    switch (widget.module) {
      case LearningModule.modules:
        return LearningCategories.modules;
      case LearningModule.notes:
        return LearningCategories.notes;
      case LearningModule.videos:
        return LearningCategories.videos;
      case LearningModule.exams:
        return LearningCategories.exams;
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(_isAmharic);
    final items = _items(strings);
    final category = _category;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: category.backgroundFor(context),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Icon(
                category.icon,
                color: category.accentFor(context),
                size: 20,
              ),
            ),
            const SizedBox(width: AppDimensions.sm),
            Text(
              _title(strings),
              style: AppTypography.headlineMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        actions: [
          const ThemeToggle(),
          LanguageToggle(
            compact: true,
            isAmharic: _isAmharic,
            onChanged: (value) {
              setState(() => _isAmharic = value);
              widget.onLanguageChanged?.call(value);
            },
          ),
          const SizedBox(width: AppDimensions.sm),
        ],
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.md,
                AppDimensions.sm,
                AppDimensions.md,
                AppDimensions.xs,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _subtitle(strings),
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w700,
                      color: category.accentFor(context),
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  Text(
                    _title(strings),
                    style: AppTypography.headlineMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Content list
            Expanded(
              child: items.isEmpty
                  ? EmptyState(
                      icon: category.icon,
                      title: 'No content available',
                      message:
                          'Content for this section will be available soon.',
                    )
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        AppDimensions.md,
                        AppDimensions.xs,
                        AppDimensions.md,
                        AppDimensions.lg,
                      ),
                      itemCount: items.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppDimensions.xs),
                      itemBuilder: (context, index) {
                        final item = items[index];

                        if (widget.module == LearningModule.videos) {
                          return VideoCard(
                            title: item,
                            course: _courseForVideo(item),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '$item is ready for content integration.',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          );
                        }

                        return CourseCard(
                          title: item,
                          icon: category.icon,
                          accentColor: category.accentFor(context),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '$item is ready for content integration.',
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _courseForVideo(String video) {
    switch (video) {
      case 'Calculus foundations':
        return 'Mathematics';
      case 'Physics problem solving':
        return 'Physics';
      case 'Study skills for freshmen':
        return 'Study Skills';
      case 'Department preparation guide':
        return 'Preparation';
      default:
        return 'General';
    }
  }
}
