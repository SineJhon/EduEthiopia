import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Configuration for a single learning category.
class LearningCategory {
  final String key;
  final String title;
  final String description;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;

  const LearningCategory({
    required this.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
  });

  Color backgroundFor(BuildContext context) => key.categoryBgFor(context);

  Color accentFor(BuildContext context) => key.categoryIconFor(context);
}

/// All four learning categories with their visual identities.
abstract class LearningCategories {
  static const modules = LearningCategory(
    key: 'modules',
    title: 'Modules',
    description: 'Courses and subjects',
    icon: Icons.apps_rounded,
    bgColor: AppColors.moduleBg,
    iconColor: AppColors.moduleIcon,
  );

  static const notes = LearningCategory(
    key: 'notes',
    title: 'Notes',
    description: 'Course notes and chapters',
    icon: Icons.menu_book_rounded,
    bgColor: AppColors.noteBg,
    iconColor: AppColors.noteIcon,
  );

  static const videos = LearningCategory(
    key: 'videos',
    title: 'Videos',
    description: 'Lessons and study videos',
    icon: Icons.play_circle_fill_rounded,
    bgColor: AppColors.videoBg,
    iconColor: AppColors.videoIcon,
  );

  static const exams = LearningCategory(
    key: 'exams',
    title: 'Exams',
    description: 'Mid, Final, and COC',
    icon: Icons.fact_check_rounded,
    bgColor: AppColors.examBg,
    iconColor: AppColors.examIcon,
  );

  /// All categories in dashboard grid order.
  static const List<LearningCategory> all = [modules, notes, videos, exams];

  /// Lookup a category by its key.
  static LearningCategory? byKey(String key) {
    try {
      return all.firstWhere((c) => c.key == key);
    } catch (_) {
      return null;
    }
  }
}
