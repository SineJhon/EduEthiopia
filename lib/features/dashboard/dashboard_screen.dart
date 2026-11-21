import 'package:flutter/material.dart';

import '../../core/design/app_colors.dart';
import '../../core/design/app_dimensions.dart';
import '../../core/design/app_typography.dart';
import '../../core/design/category_config.dart';
import '../../core/design/reusable_widgets.dart';
import '../../core/localization/app_strings.dart';
import '../../core/widgets/animated/animated_widgets.dart';
import '../../core/widgets/language_toggle.dart';
import '../../core/widgets/theme_toggle.dart';
import '../ai/ai_assistant_screen.dart';
import '../modules/learning_module_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    this.isAmharic = false,
    this.onLanguageChanged,
    super.key,
  });

  final bool isAmharic;
  final ValueChanged<bool>? onLanguageChanged;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late bool _isAmharic = widget.isAmharic;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(_isAmharic);

    return Scaffold(
      drawer: _DashboardDrawer(
        strings: strings,
        onSignOut: () =>
            Navigator.of(context).popUntil((route) => route.isFirst),
      ),
      floatingActionButton: PulseWidget(
        duration: 2500,
        scale: 1.2,
        child: FloatingActionButton(
          tooltip: strings.aiAssistant,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          onPressed: _openAiAssistant,
          child: const Icon(Icons.auto_awesome_rounded),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: AppDimensions.bottomNavHeight,
        selectedIndex: 0,
        onDestinationSelected: (index) {
          if (index == 0) return;
          final destinations = [
            LearningModule.modules,
            LearningModule.notes,
            LearningModule.exams,
            LearningModule.videos,
          ];
          _openModule(destinations[index - 1]);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: strings.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.apps_outlined),
            selectedIcon: const Icon(Icons.apps_rounded),
            label: strings.modules,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book_rounded),
            label: strings.notes,
          ),
          NavigationDestination(
            icon: const Icon(Icons.fact_check_outlined),
            selectedIcon: const Icon(Icons.fact_check_rounded),
            label: strings.exams,
          ),
          NavigationDestination(
            icon: const Icon(Icons.play_circle_outline_rounded),
            selectedIcon: const Icon(Icons.play_circle_fill_rounded),
            label: strings.videos,
          ),
        ],
      ),

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        centerTitle: false,
        leading: Builder(
          builder: (context) => IconButton(
            tooltip: strings.menu,
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu_rounded),
          ),
        ),
        titleSpacing: AppDimensions.sm,
        title: const DashboardHeader(),
        actions: [
          const ThemeToggle(),
          LanguageToggle(
            compact: true,
            isAmharic: _isAmharic,
            onChanged: (value) {
              setState(() => _isAmharic = value);
              widget.onLanguageChanged?.call(value);
            },
          ),
          const SizedBox(width: AppDimensions.xs),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.md,
            AppDimensions.sm,
            AppDimensions.md,
            AppDimensions.xl,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppDimensions.maxContentWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Study Hub introduction
                  Reveal(
                    duration: 700,
                    delay: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.welcomeEyebrow,
                          style: AppTypography.eyebrow.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.xs),
                        Text(
                          strings.dashboardTitle,
                          style: AppTypography.headlineLarge.copyWith(
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.sm),
                        Text(
                          strings.dashboardSubtitle,
                          style: AppTypography.bodyMedium.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppDimensions.lg),

                  // Study Space Banner
                  StudySpaceBanner(subtitle: strings.dashboardSubtitle),

                  const SizedBox(height: AppDimensions.lg),

                  // Main Learning Categories
                  SectionHeader(
                    title: strings.modules,
                    subtitle: 'Choose your starting point',
                  ),

                  const SizedBox(height: AppDimensions.md),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CategoryCard(
                              category: LearningCategories.modules,
                              onTap: () => _openModule(LearningModule.modules),
                              delay: 100,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.sm),
                          Expanded(
                            child: CategoryCard(
                              category: LearningCategories.notes,
                              onTap: () => _openModule(LearningModule.notes),
                              delay: 200,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      Row(
                        children: [
                          Expanded(
                            child: CategoryCard(
                              category: LearningCategories.videos,
                              onTap: () => _openModule(LearningModule.videos),
                              delay: 300,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.sm),
                          Expanded(
                            child: CategoryCard(
                              category: LearningCategories.exams,
                              onTap: () => _openModule(LearningModule.exams),
                              delay: 400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimensions.lg),

                  // Continue Learning Card
                  Reveal(
                    duration: 700,
                    delay: 500,
                    child: _ContinueLearningCard(
                      onTap: () => _openModule(LearningModule.modules),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.xl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openModule(LearningModule module) {
    slideFadePush<void>(
      context,
      (_) => LearningModuleScreen(
        module: module,
        isAmharic: _isAmharic,
        onLanguageChanged: (value) {
          setState(() => _isAmharic = value);
          widget.onLanguageChanged?.call(value);
        },
      ),
    );
  }

  void _openAiAssistant() {
    slideFadePush<void>(
      context,
      (_) => AiAssistantScreen(
        isAmharic: _isAmharic,
        onLanguageChanged: (value) {
          setState(() => _isAmharic = value);
          widget.onLanguageChanged?.call(value);
        },
      ),
    );
  }
}

class _ContinueLearningCard extends StatelessWidget {
  const _ContinueLearningCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: AppDimensions.elevationSm,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Icon(
                Icons.auto_stories_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explore study modules',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Courses and subjects',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardDrawer extends StatelessWidget {
  const _DashboardDrawer({required this.strings, required this.onSignOut});

  final AppStrings strings;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
              color: AppColors.primary,
              child: Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/edu_ethiopia_logo.jpg',
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    strings.brand,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.dashboard_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(strings.dashboardTitle),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline_rounded),
              title: Text(strings.profile),
              onTap: () => Navigator.of(context).pop(),
            ),
            const Spacer(),
            const Divider(height: 1),
            ListTile(
              leading: Icon(
                Icons.logout_rounded,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              title: Text(strings.signOut),
              onTap: onSignOut,
            ),
          ],
        ),
      ),
    );
  }
}
