import 'package:flutter/material.dart';

abstract final class AppColors {
  // Logo palette: forest green, warm gold, and Ethiopian red.
  static const green = Color(0xFF087A4B);
  static const darkGreen = Color(0xFF075638);
  static const gold = Color(0xFFE7B52E);
  static const burgundy = Color(0xFF8F263B);

  static const surface = Color(0xFFF5F7F2);
  static const darkSurface = Color(0xFF101914);
  static const darkCard = Color(0xFF19251E);
  static const darkRaised = Color(0xFF223329);
  static const darkField = Color(0xFF15221A);
  static const darkOutline = Color(0xFF3B5143);
  static const darkText = Color(0xFFF0F5F0);
  static const darkMutedText = Color(0xFFB4C2B8);

  static const lightText = Color(0xFF18231D);
  static const lightMutedText = Color(0xFF53635A);
  static const lightOutline = Color(0xFFD7E0D8);
  static const lightTint = Color(0xFFEAF2EC);
  static const darkPrimary = Color(0xFF72D7A0);
  static const darkGold = Color(0xFFF2C94C);
  static const darkBurgundy = Color(0xFFE58A9C);
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
          primaryContainer: AppColors.lightTint,
          onPrimaryContainer: AppColors.darkGreen,
          secondary: AppColors.gold,
          onSecondary: AppColors.darkGreen,
          secondaryContainer: const Color(0xFFFFF3C9),
          onSecondaryContainer: const Color(0xFF4A3900),
          tertiary: AppColors.burgundy,
          onTertiary: Colors.white,
          surface: Colors.white,
          surfaceContainerLowest: Colors.white,
          surfaceContainerLow: AppColors.surface,
          surfaceContainer: const Color(0xFFEDF2EC),
          onSurface: AppColors.lightText,
          onSurfaceVariant: AppColors.lightMutedText,
          outline: AppColors.lightOutline,
          outlineVariant: const Color(0xFFE7ECE7),
          error: const Color(0xFFB3261E),
        );

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.surface,
      useMaterial3: true,
      visualDensity: VisualDensity.standard,
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: AppColors.lightText,
        displayColor: AppColors.lightText,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.lightOutline),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.lightText,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.lightTint,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? AppColors.darkGreen
                : AppColors.lightMutedText,
            fontSize: 11,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.lightOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.lightOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.green, width: 1.7),
        ),
        labelStyle: const TextStyle(color: AppColors.lightMutedText),
        prefixIconColor: AppColors.green,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(48, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.green,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.lightOutline),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkGreen,
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  static ThemeData get dark {
    final colorScheme = const ColorScheme.dark().copyWith(
      primary: AppColors.darkPrimary,
      onPrimary: const Color(0xFF062015),
      primaryContainer: const Color(0xFF173D29),
      onPrimaryContainer: const Color(0xFFB7F2CC),
      secondary: AppColors.darkGold,
      onSecondary: const Color(0xFF302600),
      secondaryContainer: const Color(0xFF483A0D),
      onSecondaryContainer: const Color(0xFFFFE7A0),
      tertiary: AppColors.darkBurgundy,
      onTertiary: const Color(0xFF35111A),
      surface: AppColors.darkCard,
      surfaceContainerLowest: AppColors.darkSurface,
      surfaceContainerLow: AppColors.darkCard,
      surfaceContainer: AppColors.darkRaised,
      onSurface: AppColors.darkText,
      onSurfaceVariant: AppColors.darkMutedText,
      outline: AppColors.darkOutline,
      outlineVariant: const Color(0xFF2D4034),
      error: const Color(0xFFFFB4AB),
    );

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkSurface,
      useMaterial3: true,
      visualDensity: VisualDensity.standard,
      textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: AppColors.darkText,
        displayColor: AppColors.darkText,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkText,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.darkOutline),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkCard,
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
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.darkOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.darkOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.darkPrimary,
            width: 1.7,
          ),
        ),
        labelStyle: const TextStyle(color: AppColors.darkMutedText),
        prefixIconColor: AppColors.darkPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: const Color(0xFF062015),
          elevation: 0,
          minimumSize: const Size(48, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
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
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.darkOutline),
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.darkCard,
        surfaceTintColor: Colors.transparent,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkRaised,
        contentTextStyle: const TextStyle(color: AppColors.darkText),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.darkBurgundy,
        foregroundColor: Color(0xFF35111A),
      ),
    );
  }
}
