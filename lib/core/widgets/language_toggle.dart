import 'package:flutter/material.dart';

import '../localization/app_strings.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({
    required this.isAmharic,
    required this.onChanged,
    this.compact = false,
    super.key,
  });

  final bool isAmharic;
  final ValueChanged<bool> onChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(isAmharic);

    return Semantics(
      button: true,
      label: strings.languageTooltip,
      child: compact
          ? IconButton(
              tooltip: strings.languageTooltip,
              onPressed: () => onChanged(!isAmharic),
              icon: const Icon(Icons.language_rounded),
            )
          : OutlinedButton.icon(
              onPressed: () => onChanged(!isAmharic),
              icon: const Icon(Icons.language_rounded, size: 18),
              label: Text(strings.languageLabel),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                side: BorderSide(color: Theme.of(context).colorScheme.outline),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
    );
  }
}
