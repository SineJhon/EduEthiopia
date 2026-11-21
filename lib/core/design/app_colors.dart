import 'package:flutter/material.dart';

/// Centralized color palette for Edu Ethiopia.
///
/// Primary identity: deep educational green.
/// Background: very light green-tinted white.
/// Surface: white.
/// Text: dark charcoal / muted gray-green.
abstract class AppColors {
  // ── Core palette ──────────────────────────────────────────────────────
  static const primary = Color(0xFF087B50); // Deep educational green
  static const primaryLight = Color(0xFFE6F2EC); // Light green tint
  static const background = Color(0xFFF4F7F3); // Light green-tinted white
  static const surface = Color(0xFFFFFFFF); // White
  static const primaryText = Color(0xFF202B25); // Dark charcoal
  static const secondaryText = Color(0xFF89958E); // Muted gray-green

  static const darkBackground = Color(0xFF0A140F);
  static const darkSurface = Color(0xFF17251C);
  static const darkRaised = Color(0xFF1F3026);
  static const darkField = Color(0xFF15221A);
  static const darkText = Color(0xFFF0F5F0);
  static const darkMutedText = Color(0xFFB4C2B8);
  static const darkOutline = Color(0xFF3B5143);
  static const darkPrimary = Color(0xFF72D7A0);
  static const darkGold = Color(0xFFF2C94C);
  static const darkBurgundy = Color(0xFFE58A9C);

  // ── Category accent colors ────────────────────────────────────────────
  // Modules — green
  static const moduleBg = Color(0xFFE6F2EC);
  static const moduleIcon = Color(0xFF087B50);

  // Notes — blue
  static const noteBg = Color(0xFFE8F0FA);
  static const noteIcon = Color(0xFF356B9A);

  // Videos — warm beige
  static const videoBg = Color(0xFFF8EFE2);
  static const videoIcon = Color(0xFFA46B26);

  // Exams — lavender
  static const examBg = Color(0xFFF2EAF5);
  static const examIcon = Color(0xFF79508E);

  // ── Legacy palette (kept for auth/settings/drawer compatibility) ──────
  static const green = Color(0xFF087A4B);
  static const darkGreen = Color(0xFF075638);
  static const gold = Color(0xFFE7B52E);
  static const burgundy = Color(0xFF8F263B);

  static const surfaceTint = Color(0xFFF5F7F2);
  static const outline = Color(0xFFD7E0D8);
  static const lightTint = Color(0xFFEAF2EC);
}

extension CategoryColor on String {
  /// Returns the background color for a learning category.
  Color get categoryBg {
    switch (toLowerCase()) {
      case 'modules':
        return AppColors.moduleBg;
      case 'notes':
        return AppColors.noteBg;
      case 'videos':
        return AppColors.videoBg;
      case 'exams':
        return AppColors.examBg;
      default:
        return AppColors.primaryLight;
    }
  }

  Color categoryBgFor(BuildContext context) {
    if (Theme.of(context).brightness != Brightness.dark) return categoryBg;
    switch (toLowerCase()) {
      case 'modules':
        return const Color(0xFF1B3428);
      case 'notes':
        return const Color(0xFF1B2B3B);
      case 'videos':
        return const Color(0xFF372B1A);
      case 'exams':
        return const Color(0xFF312439);
      default:
        return const Color(0xFF1B3428);
    }
  }

  /// Returns the icon color for a learning category.
  Color get categoryIcon {
    switch (toLowerCase()) {
      case 'modules':
        return AppColors.moduleIcon;
      case 'notes':
        return AppColors.noteIcon;
      case 'videos':
        return AppColors.videoIcon;
      case 'exams':
        return AppColors.examIcon;
      default:
        return AppColors.primary;
    }
  }

  Color categoryIconFor(BuildContext context) {
    if (Theme.of(context).brightness != Brightness.dark) return categoryIcon;
    switch (toLowerCase()) {
      case 'modules':
        return AppColors.darkPrimary;
      case 'notes':
        return const Color(0xFF9FC7F2);
      case 'videos':
        return const Color(0xFFFFC46B);
      case 'exams':
        return const Color(0xFFD6A9E4);
      default:
        return AppColors.darkPrimary;
    }
  }

  IconData get categoryIconData {
    switch (toLowerCase()) {
      case 'modules':
        return Icons.apps_rounded;
      case 'notes':
        return Icons.menu_book_rounded;
      case 'videos':
        return Icons.play_circle_fill_rounded;
      case 'exams':
        return Icons.fact_check_rounded;
      default:
        return Icons.school_rounded;
    }
  }
}
