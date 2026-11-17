import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/welcome/welcome_screen.dart';

class EduEthiopiaApp extends StatefulWidget {
  const EduEthiopiaApp({super.key});

  @override
  State<EduEthiopiaApp> createState() => _EduEthiopiaAppState();
}

class _EduEthiopiaAppState extends State<EduEthiopiaApp> {
  bool _isAmharic = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppThemeController.isDark,
      builder: (context, isDark, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Edu Ethiopia',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: WelcomeScreen(
            isAmharic: _isAmharic,
            onLanguageChanged: (value) => setState(() => _isAmharic = value),
          ),
        );
      },
    );
  }
}