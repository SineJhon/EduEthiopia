import 'package:flutter/material.dart';

import '../../core/design/app_dimensions.dart';
import '../../core/design/app_typography.dart';
import '../../core/design/category_config.dart';
import '../../core/design/reusable_widgets.dart';
import '../../core/localization/app_strings.dart';
import '../../core/widgets/animated/page_transition.dart';
import '../../core/widgets/language_toggle.dart';
import '../../core/widgets/theme_toggle.dart';
import 'pdf_reader_screen.dart';

enum LearningModule {
  modules,
  notes,
  videos,
  practice,
  midExams,
  finalExams,
  coc,
}

class LearningModuleScreen extends StatefulWidget {
  const LearningModuleScreen({
    required this.module,
    this.isAmharic = false,
    this.category = 'Freshman',
    this.onLanguageChanged,
    super.key,
  });

  final LearningModule module;
  final bool isAmharic;
  final String category;
  final ValueChanged<bool>? onLanguageChanged;

  @override
  State<LearningModuleScreen> createState() => _LearningModuleScreenState();
}

class _LearningModuleScreenState extends State<LearningModuleScreen> {
  late bool _isAmharic = widget.isAmharic;
  late String _categoryName = widget.category;

  static const _categories = ['Freshman', 'Pre-Engineering', 'Others'];

  LearningCategory get _category {
    switch (widget.module) {
      case LearningModule.modules:
        return LearningCategories.modules;
      case LearningModule.notes:
        return LearningCategories.notes;
      case LearningModule.videos:
        return LearningCategories.videos;
      case LearningModule.practice:
      case LearningModule.midExams:
      case LearningModule.finalExams:
      case LearningModule.coc:
        return LearningCategories.exams;
    }
  }

  String _title(AppStrings strings) {
    switch (widget.module) {
      case LearningModule.modules:
        return strings.modules;
      case LearningModule.notes:
        return strings.notes;
      case LearningModule.videos:
        return strings.videos;
      case LearningModule.practice:
        return _isAmharic ? 'ልምምድ ጥያቄዎች' : 'Practice Questions';
      case LearningModule.midExams:
        return _isAmharic ? 'ሚድ ፈተናዎች' : 'Mid Exams';
      case LearningModule.finalExams:
        return _isAmharic ? 'ፍጻሜ ፈተናዎች' : 'Final Exams';
      case LearningModule.coc:
        return strings.cocExams;
    }
  }

  List<String> _items(AppStrings strings) {
    if (widget.module == LearningModule.coc) return [];

    switch (_categoryName) {
      case 'Pre-Engineering':
        return [
          'Anthropology',
          'Applied Mathematics I',
          'C++ Programming',
          'Communicative English II',
          'Entrepreneurship',
          'History of Ethiopia',
          'Introduction to Emerging Technologies',
          'Moral and Civics',
        ];
      case 'Others':
        return [
          'Anthropology',
          'Communicative English II',
          'Entrepreneurship',
          'General Biology',
          'General Chemistry',
          'History of Ethiopia',
          'Introduction to Emerging Technologies',
          'Moral and Civics',
        ];
      default:
        return [
          'Communicative English Language Skills',
          'General Psychology',
          'Geography',
          'Logic and Critical Thinking',
          'Mathematics for Natural Science',
          'Physics',
          'Physical Fitness',
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(_isAmharic);
    final items = _items(strings);
    final category = _category;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Row(
          children: [
            Text(
              _title(strings),
              style: AppTypography.headlineMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
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
          const SizedBox(width: 4),
          if (widget.module != LearningModule.coc)
            PopupMenuButton<String>(
              tooltip: _categoryName,
              position: PopupMenuPosition.under,
              constraints: const BoxConstraints(minWidth: 210, maxWidth: 210),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onSelected: (category) =>
                  setState(() => _categoryName = category),
              itemBuilder: (context) => _categories.map((category) {
                final label = _isAmharic
                    ? (category == 'Freshman'
                          ? 'ፍሬሽማን'
                          : category == 'Pre-Engineering'
                          ? 'ፕሪ-ኢንጂነሪንግ'
                          : 'ሌሎች')
                    : category;
                final selected = _categoryName == category;
                return PopupMenuItem<String>(
                  value: category,
                  height: 54,
                  child: Row(
                    children: [
                      Icon(
                        category == 'Freshman'
                            ? Icons.school_rounded
                            : category == 'Pre-Engineering'
                            ? Icons.construction_rounded
                            : Icons.account_balance_rounded,
                        size: 19,
                        color: selected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontWeight: selected
                                ? FontWeight.w900
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                      if (selected)
                        Icon(
                          Icons.check_circle_rounded,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    ],
                  ),
                );
              }).toList(),
              child: Container(
                height: 40,
                constraints: const BoxConstraints(minWidth: 104, maxWidth: 104),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      _categoryName == 'Pre-Engineering'
                          ? Icons.construction_rounded
                          : _categoryName == 'Others'
                          ? Icons.account_balance_rounded
                          : Icons.school_rounded,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _categoryName == 'Freshman'
                            ? (_isAmharic ? 'ፍሬሽማን' : 'Freshman')
                            : _categoryName == 'Pre-Engineering'
                            ? (_isAmharic ? 'ፕሪ-ኢንጂነሪንግ' : 'Pre-Eng.')
                            : (_isAmharic ? 'ሌሎች' : 'Others'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(width: AppDimensions.sm),
        ],
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Content list
            Expanded(
              child: items.isEmpty
                  ? EmptyState(
                      icon: category.icon,
                      title: 'No content available',
                      message:
                          'Content for this section will be available soon.',
                    )
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        AppDimensions.md,
                        AppDimensions.sm,
                        AppDimensions.md,
                        AppDimensions.lg,
                      ),
                      itemCount: items.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppDimensions.sm),
                      itemBuilder: (context, index) {
                        final item = items[index];

                        return CourseCard(
                          title: item,
                          icon: category.icon,
                          accentColor: category.accentFor(context),
                          showIcon: true,
                          onTap: () {
                            final pdfAsset = _modulePdfAsset(item);
                            if (widget.module == LearningModule.modules &&
                                pdfAsset != null) {
                              slideFadePush<void>(
                                context,
                                (_) => PdfReaderScreen(
                                  title: item,
                                  assetPath: pdfAsset,
                                ),
                              );
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '$item is ready for content integration.',
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String? _modulePdfAsset(String course) {
    if (_categoryName == 'Others') {
      const othersAssets = {
        'Anthropology': 'assets/modules/others/Anthropology.pdf',
        'Communicative English II':
            'assets/modules/others/Communicative English II.pdf',
        'Entrepreneurship': 'assets/modules/others/Entrepreneurship.pdf',
        'General Biology': 'assets/modules/others/General Biology.pdf',
        'General Chemistry': 'assets/modules/others/General Chemistry.pdf',
        'History of Ethiopia': 'assets/modules/others/History of Ethiopia.pdf',
        'Introduction to Emerging Technologies':
            'assets/modules/others/Introduction to Emerging Technologies.pdf',
        'Moral and Civics': 'assets/modules/others/Moral and Civics.pdf',
      };
      return othersAssets[course];
    }

    const assets = {
      'Communicative English Language Skills':
          'assets/modules/freshman/Communicative English Language Skills.pdf',
      'General Psychology': 'assets/modules/freshman/General Psychology.pdf',
      'Geography': 'assets/modules/freshman/Geography.pdf',
      'Logic and Critical Thinking':
          'assets/modules/freshman/Logic and Critical Thinking.pdf',
      'Mathematics for Natural Science':
          'assets/modules/freshman/Mathematics for Natural Science.pdf',
      'Physics': 'assets/modules/freshman/Physics.pdf',
      'Physical Fitness': 'assets/modules/freshman/Physical Fitness.pdf',
      'Anthropology': 'assets/modules/preengineering/Anthropology.pdf',
      'Applied Mathematics I':
          'assets/modules/preengineering/Applied Mathematics I.pdf',
      'C++ Programming': 'assets/modules/preengineering/C++ Programming.pdf',
      'Communicative English II':
          'assets/modules/preengineering/Communicative English II.pdf',
      'Entrepreneurship': 'assets/modules/preengineering/Entrepreneurship.pdf',
      'History of Ethiopia':
          'assets/modules/preengineering/History of Ethiopia.pdf',
      'Introduction to Emerging Technologies': 'assets/modules/preengineering/Introduction to Emerging Technologies.pdf',
      'Moral and Civics': 'assets/modules/preengineering/Moral and Civics.pdf',
    };
    return assets[course];
  }
}
