import 'package:flutter/material.dart';

abstract final class AppColors {
  static const green = Color(0xFF087A4B);
  static const darkGreen = Color(0xFF075638);
  static const gold = Color(0xFFE7B52E);
  static const burgundy = Color(0xFF7A263A);
  static const surface = Color(0xFFF4F7F5);
  static const darkSurface = Color(0xFF0B1210);
  static const darkCard = Color(0xFF15231D);
  static const darkRaised = Color(0xFF1C3027);
  static const darkField = Color(0xFF12201A);
  static const darkOutline = Color(0xFF355043);
  static const darkText = Color(0xFFEAF4EE);
  static const darkMutedText = Color(0xFFA8BDB0);
}

abstract final class AppThemeController {
  static final isDark = ValueNotifier<bool>(false);

  static void toggle() => isDark.value = !isDark.value;
}

abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.green,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.green,
          onPrimary: Colors.white,
          secondary: AppColors.gold,
          onSecondary: AppColors.darkGreen,
          tertiary: AppColors.burgundy,
          surface: AppColors.surface,
        );

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.surface,
      useMaterial3: true,
      cardTheme: const CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.green.withValues(alpha: 0.12),
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? AppColors.green
                : const Color(0xFF6D7771),
            fontSize: 11,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.darkGreen,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  static ThemeData get dark {
    final colorScheme = const ColorScheme.dark().copyWith(
      primary: Color(0xFF72D7A0),
      onPrimary: Color(0xFF062015),
      secondary: Color(0xFFF0C84B),
      onSecondary: Color(0xFF241D00),
      tertiary: Color(0xFFD9788C),
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkText,
      onSurfaceVariant: AppColors.darkMutedText,
      outline: AppColors.darkOutline,
      error: Color(0xFFFFB4AB),
    );

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkSurface,
      useMaterial3: true,
      textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: AppColors.darkText,
        displayColor: AppColors.darkText,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkText,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.darkCard,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkField,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF72D7A0), width: 2),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.darkOutline),
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.darkCard,
        surfaceTintColor: Colors.transparent,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.darkRaised,
        contentTextStyle: TextStyle(color: AppColors.darkText),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFD9788C),
        foregroundColor: Color(0xFF281018),
      ),
    );
  }
}
