import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/localization/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/language_toggle.dart';
import '../../core/widgets/theme_toggle.dart';
import '../../core/widgets/animated/page_transition.dart';
import '../auth/auth_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    required this.isAmharic,
    required this.onLanguageChanged,
    super.key,
  });

  final bool isAmharic;
  final ValueChanged<bool> onLanguageChanged;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  void _openLearning() {
    slideFadePush<void>(
      context,
      (_) => AuthScreen(
        isAmharic: widget.isAmharic,
        onLanguageChanged: widget.onLanguageChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(widget.isAmharic);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = width < 360 ? 18.0 : 24.0;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, viewport) => SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              12,
              horizontalPadding,
              28,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewport.maxHeight - 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const ThemeToggle(),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () =>
                                  widget.onLanguageChanged(!widget.isAmharic),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: colorScheme.onSurface,
                                side: BorderSide(
                                  color: colorScheme.outlineVariant,
                                ),
                                backgroundColor: colorScheme.surface,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                minimumSize: const Size(104, 44),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.language_rounded,
                                    size: 18,
                                    color: colorScheme.primary,
                                  ),
                                  const SizedBox(width: 7),
                                  Text(
                                    strings.languageLabel,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      Container(
                            padding: const EdgeInsets.fromLTRB(20, 26, 20, 22),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: colorScheme.outlineVariant.withValues(
                                  alpha: 0.65,
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                      width: 116,
                                      height: 116,
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: ClipOval(
                                        child: Image.asset(
                                          'assets/images/edu_ethiopia_logo.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                    .animate()
                                    .fadeIn(duration: 500.ms)
                                    .scale(
                                      begin: const Offset(0.88, 0.88),
                                      curve: Curves.easeOutBack,
                                    ),
                                const SizedBox(height: 22),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.tertiaryContainer,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    strings.welcomeEyebrow,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.05,
                                      height: 1.25,
                                      color: colorScheme.onTertiaryContainer,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  strings.welcomeTitle,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: width < 360 ? 27 : 30,
                                    fontWeight: FontWeight.w800,
                                    height: 1.14,
                                    letterSpacing: -0.6,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  strings.welcomeSubtitle,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    height: 1.55,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    const spacing = 10.0;
                                    final tileWidth =
                                        (constraints.maxWidth - spacing * 2) /
                                        3;
                                    final tiles = <(String, IconData, Color)>[
                                      (
                                        strings.modules,
                                        Icons.apps_rounded,
                                        const Color(0xFF176246),
                                      ),
                                      (
                                        strings.notes,
                                        Icons.menu_book_rounded,
                                        const Color(0xFF8E2437),
                                      ),
                                      (
                                        strings.videos,
                                        Icons.play_circle_rounded,
                                        const Color(0xFF176246),
                                      ),
                                      (
                                        widget.isAmharic
                                            ? '?? ?? ???'
                                            : 'Mid and Finals',
                                        Icons.fact_check_rounded,
                                        const Color(0xFF8E2437),
                                      ),
                                      (
                                        widget.isAmharic ? '?COC ?????' : 'COC',
                                        Icons.assignment_turned_in_rounded,
                                        const Color(0xFF176246),
                                      ),
                                      (
                                        widget.isAmharic
                                            ? 'AI ???'
                                            : 'AI Assistant',
                                        Icons.auto_awesome_rounded,
                                        const Color(0xFFE3AF16),
                                      ),
                                    ];
                                    return Wrap(
                                      spacing: spacing,
                                      runSpacing: spacing,
                                      children: tiles.asMap().entries.map((
                                        entry,
                                      ) {
                                        final tile = entry.value;
                                        return SizedBox(
                                          width: tileWidth,
                                          height: 96,
                                          child:
                                              OutlinedButton(
                                                    onPressed: _openLearning,
                                                    style: OutlinedButton.styleFrom(
                                                      foregroundColor:
                                                          colorScheme.onSurface,
                                                      backgroundColor:
                                                          colorScheme.surface,
                                                      side: BorderSide(
                                                        color: tile.$3
                                                            .withValues(
                                                              alpha: 0.30,
                                                            ),
                                                      ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              18,
                                                            ),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 6,
                                                            vertical: 10,
                                                          ),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          tile.$2,
                                                          size: 24,
                                                          color: tile.$3,
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        Text(
                                                          tile.$1,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              GoogleFonts.inter(
                                                                fontSize: 11,
                                                                height: 1.2,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                  .animate()
                                                  .fadeIn(
                                                    duration: 420.ms,
                                                    delay: (entry.key * 70).ms,
                                                  )
                                                  .slideY(
                                                    begin: 0.08,
                                                    end: 0,
                                                    curve: Curves.easeOutCubic,
                                                  ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                                const SizedBox(height: 22),
                                SizedBox(
                                  width: double.infinity,
                                  height: 58,
                                  child:
                                      FilledButton.icon(
                                            onPressed: _openLearning,
                                            icon: const Icon(
                                              Icons.arrow_forward_rounded,
                                              size: 20,
                                            ),
                                            label: Text(
                                              strings.continueLabel,
                                              style: GoogleFonts.inter(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            style: FilledButton.styleFrom(
                                              backgroundColor:
                                                  colorScheme.primary,
                                              foregroundColor:
                                                  colorScheme.onPrimary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                            ),
                                          )
                                          .animate()
                                          .fadeIn(
                                            duration: 500.ms,
                                            delay: 360.ms,
                                          )
                                          .slideY(begin: 0.08, end: 0),
                                ),
                              ],
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 100.ms)
                          .slideY(
                            begin: 0.04,
                            end: 0,
                            curve: Curves.easeOutCubic,
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader({
    required this.isAmharic,
    required this.onLanguageChanged,
    required this.onMenuTap,
  });

  final bool isAmharic;
  final ValueChanged<bool> onLanguageChanged;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: AppStrings(isAmharic).menu,
          onPressed: onMenuTap,
          style: IconButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          icon: const Icon(Icons.menu_rounded),
        ),
        const SizedBox(width: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            'assets/images/edu_ethiopia_logo.jpg',
            width: 34,
            height: 34,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            'Edu Ethiopia',
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        const ThemeToggle(),
        const SizedBox(width: 4),
        LanguageToggle(
          compact: true,
          isAmharic: isAmharic,
          onChanged: onLanguageChanged,
        ),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.strings,
    required this.onStart,
    required this.isDark,
  });

  final AppStrings strings;
  final VoidCallback onStart;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final accentBackground = isDark
        ? const Color(0xFF173626)
        : const Color(0xFFEAF4EE);
    return Container(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
          decoration: BoxDecoration(
            color: accentBackground,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: isDark ? const Color(0xFF355444) : const Color(0xFFDCE9DF),
            ),
          ),
          child: Column(
            children: [
              Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.22),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(
                    begin: const Offset(0.9, 0.9),
                    end: Offset.zero,
                    curve: Curves.easeOutBack,
                  ),
              const SizedBox(height: 18),
              Text(
                'Your Learning Journey\nStarts Here',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 29,
                  fontWeight: FontWeight.w800,
                  height: 1.12,
                  letterSpacing: -0.8,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Explore courses, notes, video lessons, and exams with intelligent study support in one place.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.55,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: onStart,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        strings.continueLabel,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 700.ms, delay: 120.ms)
        .slideY(
          begin: 0.04,
          end: 0,
          duration: 650.ms,
          curve: Curves.easeOutCubic,
        );
  }
}

class _FeatureData {
  const _FeatureData({
    required this.title,
    required this.description,
    required this.icon,
    required this.accent,
    required this.tint,
  }) : prominent = false;

  final String title;
  final String description;
  final IconData icon;
  final Color accent;
  final Color tint;
  final bool prominent;
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.data, required this.onTap});

  final _FeatureData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = Theme.of(context).colorScheme.surface;
    final tint = isDark
        ? Color.alphaBlend(data.accent.withValues(alpha: 0.12), surface)
        : data.tint;

    return Material(
      color: surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: data.accent.withValues(alpha: 0.12),
        child: Ink(
          height: data.prominent ? 174 : 158,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: data.accent.withValues(alpha: isDark ? 0.32 : 0.18),
            ),
            boxShadow: [
              BoxShadow(
                color: data.accent.withValues(alpha: 0.07),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: tint,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(data.icon, color: data.accent, size: 26),
              ),
              const Spacer(),
              Text(
                data.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: data.prominent ? 15 : 14,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                data.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  height: 1.35,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(
      duration: 500.ms,
      delay: data.prominent ? 420.ms : 260.ms,
    );
  }
}
