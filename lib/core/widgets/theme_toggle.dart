import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppThemeController.isDark,
      builder: (context, isDark, child) {
        return IconButton(
          tooltip: isDark ? 'Switch to light theme' : 'Switch to dark theme',
          onPressed: AppThemeController.toggle,
          icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
        );
      },
    );
  }
}