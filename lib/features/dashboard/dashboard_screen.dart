import 'package:flutter/material.dart';

import '../../core/localization/app_strings.dart';
import '../../core/theme/app_theme.dart';
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
          backgroundColor: AppColors.burgundy,
          foregroundColor: Colors.white,
          onPressed: _openAiAssistant,
          child: const Icon(Icons.auto_awesome_rounded),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: 68,
        selectedIndex: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) {
          if (index > 0) {
            _openModule(
              [
                LearningModule.modules,
                LearningModule.notes,
                LearningModule.exams,
                LearningModule.videos,
              ][index - 1],
            );
          }
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: strings.dashboardTitle,
          ),
          NavigationDestination(
            icon: Icon(Icons.apps_outlined),
            selectedIcon: Icon(Icons.apps_rounded),
            label: strings.modules,
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: strings.notes,
          ),
          NavigationDestination(
            icon: Icon(Icons.fact_check_outlined),
            selectedIcon: Icon(Icons.fact_check_rounded),
            label: strings.exams,
          ),
          NavigationDestination(
            icon: Icon(Icons.play_circle_outline_rounded),
            selectedIcon: Icon(Icons.play_circle_fill_rounded),
            label: strings.videos,
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: Builder(
          builder: (context) => IconButton(
            tooltip: strings.menu,
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu_rounded),
          ),
        ),
        title: const Text(
          'Edu Ethiopia',
          style: TextStyle(fontWeight: FontWeight.w900),
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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Reveal(
                    duration: 700,
                    delay: 100,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                strings.welcomeEyebrow,
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: .6,
                                    ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                strings.dashboardTitle,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        ClipOval(
                          child: Image.asset(
                            'assets/images/edu_ethiopia_logo.jpg',
                            height: 46,
                            width: 46,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _StudyOverviewCard(subtitle: strings.dashboardSubtitle),
                  const SizedBox(height: 26),
                  Reveal(
                    duration: 700,
                    delay: 250,
                    child: Text(
                      strings.modules,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Reveal(
                    duration: 700,
                    delay: 350,
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.15,
                      children: [
                        _DashboardTile(
                          icon: Icons.apps_rounded,
                          label: strings.modules,
                          description: strings.modulesDescription,
                          color: AppColors.green,
                          onTap: () => _openModule(LearningModule.modules),
                          delay: 50,
                        ),
                        _DashboardTile(
                          icon: Icons.menu_book_rounded,
                          label: strings.notes,
                          description: strings.notesDescription,
                          color: AppColors.green,
                          onTap: () => _openModule(LearningModule.notes),
                          delay: 150,
                        ),
                        _DashboardTile(
                          icon: Icons.fact_check_rounded,
                          label: strings.exams,
                          description: strings.examsDescription,
                          color: AppColors.darkGreen,
                          onTap: () => _openModule(LearningModule.exams),
                          delay: 250,
                        ),
                        _DashboardTile(
                          icon: Icons.play_circle_fill_rounded,
                          label: strings.videos,
                          description: strings.videosDescription,
                          color: const Color(0xFF2C7A7B),
                          onTap: () => _openModule(LearningModule.videos),
                          delay: 350,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  _ContinueLearningCard(
                    onTap: () => _openModule(LearningModule.modules),
                  ),
                  const SizedBox(height: 30),
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

class _StudyOverviewCard extends StatelessWidget {
  const _StudyOverviewCard({required this.subtitle});
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.green.withValues(alpha: .16),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'YOUR STUDY SPACE',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      color: Colors.white70,
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Learn at your own pace',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .14),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 27,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContinueLearningCard extends StatelessWidget {
  const _ContinueLearningCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(16),
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.green.withValues(alpha: .09),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(
                Icons.auto_stories_rounded,
                color: AppColors.green,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explore study modules',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Courses and subjects',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 15),
          ],
        ),
      ),
    ),
  );
}

class _DashboardTile extends StatefulWidget {
  const _DashboardTile({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
    required this.onTap,
    this.delay = 0,
  });

  final IconData icon;
  final String label;
  final String description;
  final Color color;
  final VoidCallback onTap;
  final int delay;

  @override
  State<_DashboardTile> createState() => _DashboardTileState();
}

class _DashboardTileState extends State<_DashboardTile> {
  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: 16,
      onTap: widget.onTap,
      delay: widget.delay,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: widget.color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(widget.icon, color: widget.color, size: 32),
          ),
          const SizedBox(height: 14),
          Text(
            widget.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.description,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.7),
              fontSize: 11,
              height: 1.3,
            ),
          ),
        ],
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
              color: AppColors.darkGreen,
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
              leading: const Icon(
                Icons.dashboard_rounded,
                color: AppColors.green,
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
              leading: const Icon(
                Icons.logout_rounded,
                color: AppColors.burgundy,
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
