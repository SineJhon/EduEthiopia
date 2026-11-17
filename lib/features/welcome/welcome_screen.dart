import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/localization/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/animated/animated_widgets.dart';
import '../../core/widgets/language_toggle.dart';
import '../../core/widgets/theme_toggle.dart';
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
  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(widget.isAmharic);
    final isCompact = MediaQuery.of(context).size.height < 650;
    final logoSize = isCompact ? 80.0 : 100.0;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -40,
              right: -40,
              child:
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.green.withValues(alpha: 0.12),
                    ),
                  ).animate().scale(
                    delay: 400.ms,
                    duration: 1600.ms,
                    curve: Curves.easeInOut,
                    begin: const Offset(0.85, 0.85),
                    end: Offset.zero,
                  ),
            ),
            Positioned(
              bottom: -30,
              left: -30,
              child:
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.gold.withValues(alpha: 0.10),
                    ),
                  ).animate().scale(
                    delay: 600.ms,
                    duration: 1600.ms,
                    curve: Curves.easeInOut,
                    begin: const Offset(0.85, 0.85),
                    end: Offset.zero,
                  ),
            ),
            Positioned(
              top: 8,
              right: 16,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ThemeToggle(),
                  const SizedBox(width: 10),
                  LanguageToggle(
                    isAmharic: widget.isAmharic,
                    onChanged: widget.onLanguageChanged,
                  ),
                ],
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: isCompact ? 10 : 20,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Reveal(
                              duration: 700,
                              delay: 100,
                              child: BrandLogo(
                                size: logoSize,
                                borderColor: AppColors.gold,
                                animateOnLoad: true,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Reveal(
                              duration: 700,
                              delay: 300,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    strings.welcomeEyebrow,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 10,
                                          letterSpacing: 1.4,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    strings.welcomeTitle,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          fontWeight: FontWeight.w900,
                                          height: 1.1,
                                        ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    strings.welcomeSubtitle,
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                          height: 1.4,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 22),
                            Reveal(
                              duration: 700,
                              delay: 550,
                              child: GridView.count(
                                crossAxisCount: 3,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                mainAxisExtent: isCompact ? 62 : 66,
                                children: [
                                  AnimatedChip(
                                    icon: Icons.menu_book_rounded,
                                    label: strings.notes,
                                    color: AppColors.green,
                                    duration: 500,
                                    delay: 100,
                                  ),
                                  AnimatedChip(
                                    icon: Icons.assignment_rounded,
                                    label: strings.midExams,
                                    color: AppColors.burgundy,
                                    duration: 500,
                                    delay: 180,
                                  ),
                                  AnimatedChip(
                                    icon: Icons.fact_check_rounded,
                                    label: strings.finalExams,
                                    color: AppColors.darkGreen,
                                    duration: 500,
                                    delay: 260,
                                  ),
                                  AnimatedChip(
                                    icon: Icons.assignment_turned_in_rounded,
                                    label: strings.cocExams,
                                    color: AppColors.burgundy,
                                    duration: 500,
                                    delay: 340,
                                  ),
                                  AnimatedChip(
                                    icon: Icons.auto_stories_rounded,
                                    label: strings.realMaterials,
                                    color: AppColors.gold,
                                    duration: 500,
                                    delay: 420,
                                  ),
                                  AnimatedChip(
                                    icon: Icons.school_rounded,
                                    label: strings.freshmanPrep,
                                    color: AppColors.green,
                                    duration: 500,
                                    delay: 500,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 22),
                            Reveal(
                              duration: 700,
                              delay: 750,
                              child: SizedBox(
                                width: double.infinity,
                                child: MagneticButton(
                                  onPressed: () {
                                    slideFadePush<void>(
                                      context,
                                      (_) => AuthScreen(
                                        isAmharic: widget.isAmharic,
                                        onLanguageChanged:
                                            widget.onLanguageChanged,
                                      ),
                                    );
                                  },
                                  backgroundColor: AppColors.green,
                                  foregroundColor: Colors.white,
                                  label: strings.continueLabel,
                                  height: isCompact ? 52 : 58,
                                  icon: const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 20,
                                  ),
                                  duration: 500,
                                  delay: 100,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
