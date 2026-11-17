import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/localization/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/animated/animated_widgets.dart';
import '../../core/widgets/language_toggle.dart';
import '../../core/widgets/theme_toggle.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    this.isAmharic = false,
    this.onLanguageChanged,
    super.key,
  });

  final bool isAmharic;
  final ValueChanged<bool>? onLanguageChanged;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _isAmharic = widget.isAmharic;
  bool _notifications = true;

  @override
  void initState() {
    super.initState();
    _isAmharic = widget.isAmharic;
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(_isAmharic);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          strings.settingsTitle,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          const ThemeToggle(),
          const SizedBox(width: 10),
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
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Reveal(
              duration: 700,
              delay: 100,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.darkGreen,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: AppColors.darkGreen,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            strings.brand,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            strings.settingsNotice,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 26),
            ...[
              _SettingsTile(
                icon: Icons.language_rounded,
                iconColor: AppColors.green,
                title: strings.languageLabel,
                subtitle: strings.languageTooltip,
                trailing: LanguageToggle(
                  isAmharic: _isAmharic,
                  onChanged: (value) {
                    setState(() => _isAmharic = value);
                    widget.onLanguageChanged?.call(value);
                  },
                ),
                delay: 100,
              ),
              const SizedBox(height: 16),
              _SettingsTile(
                icon: Icons.dark_mode_rounded,
                iconColor: AppColors.burgundy,
                title: AppThemeController.isDark.value
                    ? 'Dark mode'
                    : 'Light mode',
                subtitle: 'Switch between themes',
                trailing: Switch.adaptive(
                  value: AppThemeController.isDark.value,
                  onChanged: (_) => AppThemeController.toggle(),
                  activeThumbColor: AppColors.green,
                ),
                delay: 200,
              ),
              const SizedBox(height: 16),
              _SettingsTile(
                icon: Icons.notifications_none_rounded,
                iconColor: AppColors.green,
                title: _isAmharic ? 'ማሳወቂያዎች' : 'Notifications',
                subtitle: 'Get study reminders',
                trailing: Switch.adaptive(
                  value: _notifications,
                  onChanged: (value) => setState(() => _notifications = value),
                  activeThumbColor: AppColors.green,
                ),
                delay: 300,
              ),
              const SizedBox(height: 30),
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                iconColor: AppColors.burgundy,
                title: 'Preview mode',
                subtitle: 'Early platform preview',
                onTap: () => _showMessage(strings.previewNotice),
                delay: 400,
              ),
              const SizedBox(height: 16),
              _SettingsTile(
                icon: Icons.logout_rounded,
                iconColor: AppColors.burgundy,
                title: strings.signOut,
                subtitle: 'Sign out of your account',
                onTap: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                delay: 500,
              ),
              const SizedBox(height: 40),
            ].animate().fade(duration: 600.ms),
          ],
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.green.withValues(alpha: 0.9),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
    this.delay = 0,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: 16,
      delay: delay,
      onTap: onTap,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant
                .withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
        trailing: trailing,
      ),
    );
  }
}
