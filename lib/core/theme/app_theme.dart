import 'package:flutter/material.dart';

export '../design/app_colors.dart';

import '../design/app_colors.dart';
import '../design/app_dimensions.dart';

abstract final class AppThemeController {
  static final isDark = ValueNotifier<bool>(false);

  static void toggle() => isDark.value = !isDark.value;
}

abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          primaryContainer: AppColors.primaryLight,
          onPrimaryContainer: AppColors.darkGreen,
          secondary: AppColors.gold,
          onSecondary: AppColors.darkGreen,
          secondaryContainer: const Color(0xFFFFF3C9),
          onSecondaryContainer: const Color(0xFF4A3900),
          tertiary: AppColors.burgundy,
          onTertiary: Colors.white,
          surface: AppColors.surface,
          surfaceContainerLowest: AppColors.surface,
          surfaceContainerLow: AppColors.background,
          surfaceContainer: const Color(0xFFEDF2EC),
          onSurface: AppColors.primaryText,
          onSurfaceVariant: AppColors.secondaryText,
          outline: AppColors.outline,
          outlineVariant: const Color(0xFFE7ECE7),
          error: const Color(0xFFB3261E),
        );

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      useMaterial3: true,
      visualDensity: VisualDensity.standard,
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: AppColors.primaryText,
        displayColor: AppColors.primaryText,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          side: const BorderSide(color: AppColors.outline),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.primaryText,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primaryLight,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.secondaryText,
            fontSize: 11,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.7),
        ),
        labelStyle: const TextStyle(color: AppColors.secondaryText),
        prefixIconColor: AppColors.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(48, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.outline),
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.primary,
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  static ThemeData get dark {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ).copyWith(
          primary: AppColors.darkPrimary,
          onPrimary: const Color(0xFF062015),
          primaryContainer: AppColors.darkGreen,
          onPrimaryContainer: const Color(0xFFB7F2CC),
          secondary: AppColors.gold,
          onSecondary: AppColors.darkGreen,
          secondaryContainer: const Color(0xFF2A2000),
          onSecondaryContainer: const Color(0xFFFFF3C9),
          tertiary: AppColors.darkBurgundy,
          onTertiary: const Color(0xFF35111A),
          surface: AppColors.darkSurface,
          surfaceContainerLowest: AppColors.darkBackground,
          surfaceContainerLow: AppColors.darkSurface,
          surfaceContainer: AppColors.darkRaised,
          onSurface: AppColors.darkText,
          onSurfaceVariant: AppColors.darkMutedText,
          outline: AppColors.darkOutline,
          outlineVariant: AppColors.darkOutline,
          error: const Color(0xFFFFB4AB),
        );

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      useMaterial3: true,
      visualDensity: VisualDensity.standard,
      textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: AppColors.darkText,
        displayColor: AppColors.darkText,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          side: const BorderSide(color: AppColors.darkOutline),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkText,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        indicatorColor: const Color(0xFF294535),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? AppColors.darkPrimary
                : AppColors.darkMutedText,
            fontSize: 11,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkField,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          borderSide: const BorderSide(color: AppColors.darkOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          borderSide: const BorderSide(color: AppColors.darkOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          borderSide: const BorderSide(
            color: AppColors.darkPrimary,
            width: 1.7,
          ),
        ),
        labelStyle: const TextStyle(color: AppColors.darkMutedText),
        prefixIconColor: AppColors.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: const Color(0xFF062015),
          elevation: 0,
          minimumSize: const Size(48, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: const Color(0xFF062015),
          minimumSize: const Size(48, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.darkOutline),
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.darkSurface,
        surfaceTintColor: Colors.transparent,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkRaised,
        contentTextStyle: const TextStyle(color: AppColors.darkText),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: Color(0xFF062015),
      ),
    );
  }
}
