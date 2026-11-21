import 'package:flutter/material.dart';

import '../../core/design/app_colors.dart';
import '../../core/localization/app_strings.dart';
import '../../core/widgets/language_toggle.dart';
import '../../core/widgets/theme_toggle.dart';
import '../../core/widgets/animated/page_transition.dart';
import '../ai/ai_assistant_screen.dart';
import '../modules/learning_module_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    this.isAmharic = false,
    this.onLanguageChanged,
    this.userName,
    this.university,
    super.key,
  });

  final bool isAmharic;
  final ValueChanged<bool>? onLanguageChanged;
  final String? userName;
  final String? university;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late bool _isAmharic = widget.isAmharic;
  String _selectedCategory = 'Freshman';

  static const _categories = ['Freshman', 'Pre-Engineering', 'Others'];

  String get _categoryLabel {
    if (!_isAmharic) return _selectedCategory;
    switch (_selectedCategory) {
      case 'Pre-Engineering':
        return 'ፕሪ-ኢንጂነሪንግ';
      case 'Others':
        return 'ሌሎች';
      default:
        return 'ፍሬሽማን';
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(_isAmharic);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: _DashboardDrawer(
        strings: strings,
        onSignOut: () =>
            Navigator.of(context).popUntil((route) => route.isFirst),
      ),
      floatingActionButton: FloatingActionButton.extended(
        tooltip: _isAmharic ? 'AI እገዛ' : 'AI Assistant',
        onPressed: _openAiAssistant,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        icon: const Icon(Icons.auto_awesome_rounded),
        label: Text(
          _isAmharic ? 'AI እገዛ' : 'AI Assistant',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _ProfileBadge(
                          categoryLabel: _categoryLabel,
                          categories: _categories,
                          isAmharic: _isAmharic,
                          onMenuTap: () => Scaffold.of(context).openDrawer(),
                          onCategoryChanged: (category) {
                            setState(() => _selectedCategory = category);
                          },
                          onLanguageChanged: (value) {
                            setState(() => _isAmharic = value);
                            widget.onLanguageChanged?.call(value);
                          },
                        ),
                        const SizedBox(height: 18),
                        _StudyPassCard(
                          isAmharic: _isAmharic,
                          category: _selectedCategory,
                          categoryLabel: _categoryLabel,
                        ),
                        const SizedBox(height: 18),
                        _CategoryGrid(
                          isAmharic: _isAmharic,
                          category: _selectedCategory,
                          onModuleTap: _openModule,
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
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

String _localizedCategory(String category, bool isAmharic) {
  if (!isAmharic) return category;
  switch (category) {
    case 'Pre-Engineering':
      return 'ፕሪ-ኢንጂነሪንግ';
    case 'Others':
      return 'ሌሎች';
    default:
      return 'ፍሬሽማን';
  }
}

class _ProfileBadge extends StatelessWidget {
  const _ProfileBadge({
    required this.categoryLabel,
    required this.categories,
    required this.isAmharic,
    required this.onMenuTap,
    required this.onCategoryChanged,
    required this.onLanguageChanged,
  });

  final String categoryLabel;
  final List<String> categories;
  final bool isAmharic;
  final VoidCallback onMenuTap;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<bool> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        IconButton(
          tooltip: isAmharic ? 'ምናሌ' : 'Menu',
          onPressed: onMenuTap,
          icon: const Icon(Icons.menu_rounded),
        ),
        CircleAvatar(
          radius: 22,
          backgroundColor: colorScheme.primaryContainer,
          child: ClipOval(
            child: Image.asset(
              'assets/images/edu_ethiopia_logo.jpg',
              width: 44,
              height: 44,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Edu Ethiopia',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        const ThemeToggle(),
        LanguageToggle(
          compact: true,
          isAmharic: isAmharic,
          onChanged: onLanguageChanged,
        ),
        const SizedBox(width: 4),
        PopupMenuButton<String>(
          tooltip: categoryLabel,
          position: PopupMenuPosition.under,
          constraints: const BoxConstraints(minWidth: 220, maxWidth: 220),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 10,
          color: colorScheme.surface,
          onOpened: () {},
          onSelected: onCategoryChanged,
          itemBuilder: (context) => categories.map((category) {
            final selected =
                categoryLabel == _localizedCategory(category, isAmharic) ||
                (category == 'Freshman' && categoryLabel == 'Freshman');
            final label = _localizedCategory(category, isAmharic);
            final description = isAmharic
                ? (category == 'Freshman'
                      ? 'የመጀመሪያ ዓመት ኮርሶች'
                      : category == 'Pre-Engineering'
                      ? 'የኢንጂነሪንግ ዝግጅት'
                      : 'ተጨማሪ የጥናት አማራጮች')
                : (category == 'Freshman'
                      ? 'First-year courses'
                      : category == 'Pre-Engineering'
                      ? 'Engineering preparation'
                      : 'Additional study areas');

            return PopupMenuItem<String>(
              value: category,
              height: 62,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: selected
                          ? colorScheme.primaryContainer
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      category == 'Freshman'
                          ? Icons.school_rounded
                          : category == 'Pre-Engineering'
                          ? Icons.construction_rounded
                          : Icons.account_balance_rounded,
                      size: 19,
                      color: selected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (selected)
                    Icon(
                      Icons.check_circle_rounded,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                ],
              ),
            );
          }).toList(),
          child: Container(
            constraints: const BoxConstraints(
              minWidth: 112,
              maxWidth: 112,
              minHeight: 44,
              maxHeight: 44,
            ),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.28),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 9),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    categoryLabel == 'Pre-Engineering' ||
                            categoryLabel == 'ፕሪ-ኢንጂነሪንግ'
                        ? Icons.construction_rounded
                        : categoryLabel == 'Others' || categoryLabel == 'ሌሎች'
                        ? Icons.account_balance_rounded
                        : Icons.school_rounded,
                    size: 16,
                    color: colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    categoryLabel == 'Freshman'
                        ? (isAmharic ? 'ፍሬሽማን' : 'Freshman')
                        : categoryLabel == 'Pre-Engineering'
                        ? (isAmharic ? 'ፕሪ-ኢንጂነሪንግ' : 'Pre-Eng.')
                        : (isAmharic ? 'ሌሎች' : 'Others'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 17,
                  color: colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StudyPassCard extends StatelessWidget {
  const _StudyPassCard({
    required this.isAmharic,
    required this.category,
    required this.categoryLabel,
  });

  final bool isAmharic;
  final String category;
  final String categoryLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 178,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF173B2C) : const Color(0xFF176246),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? colorScheme.outlineVariant
              : Colors.white.withValues(alpha: 0.22),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: isDark ? 0.12 : 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -42,
            top: -58,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.10),
                  width: 18,
                ),
              ),
            ),
          ),
          Positioned(
            right: 28,
            bottom: -70,
            child: Container(
              width: 145,
              height: 145,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFE3AF16).withValues(alpha: 0.16),
                  width: 22,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.80),
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/edu_ethiopia_logo.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAmharic
                                ? 'የEdu Ethiopia ትምህርት ዕቅድ'
                                : 'Edu Ethiopia Study Pass',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isAmharic
                                ? '$categoryLabel መካከለኛ እና ፍጻሜ ዝግጅት'
                                : '$category Learning Program',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.72),
                              fontSize: 10,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.13),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.16),
                        ),
                      ),
                      child: Text(
                        isAmharic ? 'ቀን' : 'Active',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.11),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.13),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isAmharic ? 'የጥናት እድገት' : 'Study progress',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.68),
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              isAmharic
                                  ? 'አዲስ ጥናት ይጀምሩ'
                                  : 'Continue where you left off',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE3AF16),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Color(0xFF123F30),
                          size: 21,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({
    required this.isAmharic,
    required this.category,
    required this.onModuleTap,
  });

  final bool isAmharic;
  final String category;
  final void Function(LearningModule module) onModuleTap;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _StudyCardData(
        title: isAmharic ? 'ሞጁሎች' : 'Modules',
        subtitle: isAmharic ? '$category ኮርሶች' : '$category courses',
        icon: Icons.apps_rounded,
        color: const Color(0xFF176246),
        onTap: () => onModuleTap(LearningModule.modules),
      ),
      _StudyCardData(
        title: isAmharic ? 'ማስታወሻዎች' : 'Notes',
        subtitle: isAmharic ? 'ኮርስ ማስታወሻዎች' : 'Course notes',
        icon: Icons.menu_book_rounded,
        color: const Color(0xFF8E2437),
        onTap: () => onModuleTap(LearningModule.notes),
      ),
      _StudyCardData(
        title: isAmharic ? 'ቪዲዮዎች' : 'Videos',
        subtitle: isAmharic ? 'የትምህርት ቪዲዮዎች' : 'Study videos',
        icon: Icons.play_circle_rounded,
        color: const Color(0xFF176246),
        onTap: () => onModuleTap(LearningModule.videos),
      ),
      _StudyCardData(
        title: isAmharic ? 'ሚድ ፈተናዎች' : 'Mid Exams',
        subtitle: isAmharic ? 'ጊዜያዊ ፈተናዎች' : 'Midterm exams',
        icon: Icons.assignment_rounded,
        color: const Color(0xFF8E2437),
        onTap: () => onModuleTap(LearningModule.exams),
      ),
      _StudyCardData(
        title: isAmharic ? 'ፍጻሜ ፈተናዎች' : 'Final Exams',
        subtitle: isAmharic ? 'የመጨረሻ ፈተናዎች' : 'Final exams',
        icon: Icons.fact_check_rounded,
        color: const Color(0xFF176246),
        onTap: () => onModuleTap(LearningModule.exams),
      ),
      _StudyCardData(
        title: isAmharic ? 'የCOC ፈተናዎች' : 'COC Exams',
        subtitle: isAmharic ? 'ሙያ ብቃት ፈተና' : 'Competency exams',
        icon: Icons.assignment_turned_in_rounded,
        color: const Color(0xFFE3AF16),
        onTap: () => onModuleTap(LearningModule.exams),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 24) / 3;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: cards
              .map(
                (card) => SizedBox(
                  width: cardWidth,
                  height: 156,
                  child: _StudyCard(data: card),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _StudyCardData {
  const _StudyCardData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}

class _StudyCard extends StatelessWidget {
  const _StudyCard({required this.data});

  final _StudyCardData data;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: data.onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: data.color.withValues(alpha: 0.22)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: data.color.withValues(alpha: 0.11),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(data.icon, color: data.color, size: 26),
                ),
                const SizedBox(height: 10),
                Text(
                  data.title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.subtitle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
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
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage(
                      'assets/images/edu_ethiopia_logo.jpg',
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
              leading: const Icon(Icons.dashboard_rounded),
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
