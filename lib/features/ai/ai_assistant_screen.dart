import 'package:flutter/material.dart';

import '../../core/localization/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/language_toggle.dart';
import '../../core/widgets/theme_toggle.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({
    this.isAmharic = false,
    this.onLanguageChanged,
    super.key,
  });

  final bool isAmharic;
  final ValueChanged<bool>? onLanguageChanged;

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  late bool _isAmharic = widget.isAmharic;
  final _questionController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(_isAmharic);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          strings.aiTitle,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          const ThemeToggle(),
          LanguageToggle(
            isAmharic: _isAmharic,
            onChanged: (value) {
              setState(() => _isAmharic = value);
              widget.onLanguageChanged?.call(value);
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 34,
                        backgroundColor: AppColors.burgundy.withValues(alpha: 0.12),
                        foregroundColor: AppColors.burgundy,
                        child: const Icon(Icons.auto_awesome_rounded, size: 32),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        strings.aiNotice,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _questionController,
                      minLines: 1,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: strings.askQuestion,
                        prefixIcon: const Icon(Icons.help_outline_rounded),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    tooltip: 'Send',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(strings.aiNotice)),
                      );
                    },
                    icon: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}