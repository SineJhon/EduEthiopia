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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = width < 360 ? 16.0 : 20.0;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          8,
                          horizontalPadding,
                          8,
                        ),
                        child: _WelcomeHeader(
                          isAmharic: widget.isAmharic,
                          onLanguageChanged: widget.onLanguageChanged,
                          onMenuTap: _openLearning,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: _HeroSection(
                          strings: strings,
                          onStart: _openLearning,
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: Text(
                          widget.isAmharic
                              ? 'ማዕከላዊ ተግባራት'
                              : 'Everything you need',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            height: 1.3,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final cardWidth = (constraints.maxWidth - 12) / 2;
                            final features = [
                              _FeatureData(
                                title: strings.modules,
                                description: strings.modulesDescription,
                                icon: Icons.apps_rounded,
                                accent: const Color(0xFF087B50),
                                tint: const Color(0xFFE6F2EC),
                              ),
                              _FeatureData(
                                title: strings.notes,
                                description: strings.notesDescription,
                                icon: Icons.menu_book_rounded,
                                accent: const Color(0xFF356B9A),
                                tint: const Color(0xFFE8F0FA),
                              ),
                              _FeatureData(
                                title: strings.videos,
                                description: strings.videosDescription,
                                icon: Icons.play_circle_fill_rounded,
                                accent: const Color(0xFFA46B26),
                                tint: const Color(0xFFF8EFE2),
                              ),
                              _FeatureData(
                                title: strings.exams,
                                description: strings.examsDescription,
                                icon: Icons.fact_check_rounded,
                                accent: const Color(0xFF79508E),
                                tint: const Color(0xFFF2EAF5),
                              ),
                              _FeatureData(
                                title: widget.isAmharic
                                    ? 'AI ጥናት እርዳታ'
                                    : 'AI Study Assistant',
                                description: strings.aiDescription,
                                icon: Icons.auto_awesome_rounded,
                                accent: const Color(0xFF167D75),
                                tint: const Color(0xFFE3F3F0),
                                prominent: true,
                              ),
                            ];

                            return Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: features
                                  .map(
                                    (feature) => SizedBox(
                                      width: cardWidth,
                                      child: _FeatureCard(
                                        data: feature,
                                        onTap: _openLearning,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          0,
                          horizontalPadding,
                          24,
                        ),
                        child: Text(
                          widget.isAmharic
                              ? 'ኤዱ ኢትዮጵያ — የእርስዎ የጥናት ጓደኛ'
                              : 'Edu Ethiopia — learn with purpose',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
    this.prominent = false,
  });

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
