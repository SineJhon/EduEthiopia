import 'package:flutter/material.dart';

import '../localization/app_strings.dart';
import '../theme/app_theme.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({
    required this.isAmharic,
    required this.onChanged,
    super.key,
  });

  final bool isAmharic;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(isAmharic);

    return Semantics(
      button: true,
      label: strings.languageTooltip,
      child: OutlinedButton.icon(
        onPressed: () => onChanged(!isAmharic),
        icon: const Icon(Icons.language_rounded, size: 18),
        label: Text(strings.languageLabel),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkGreen,
          side: BorderSide(color: AppColors.green.withValues(alpha: 0.25)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}