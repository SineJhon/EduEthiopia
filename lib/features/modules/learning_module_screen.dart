import 'package:flutter/material.dart';

import '../../core/design/app_dimensions.dart';
import '../../core/design/app_typography.dart';
import '../../core/design/category_config.dart';
import '../../core/design/reusable_widgets.dart';
import '../../core/localization/app_strings.dart';
import '../../core/widgets/animated/page_transition.dart';
import '../../core/widgets/language_toggle.dart';
import '../../core/widgets/theme_toggle.dart';
import 'communicative_english_notes_screen.dart';
import 'pdf_reader_screen.dart';
import 'practice/unit_selection_screen.dart';

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
  String? _selectedNoteSubject;

  static const _categories = ['Freshman', 'Pre-Engineering', 'Others'];

  static const _additionalNoteFiles = <String, List<String>>{
    'Anthropology': [
      'Social Anthropology',
      'Unit 2',
      'Unit 3',
      'Unit 4',
      'Unit 5',
      'Unit 6',
      'Unit 7',
    ],
    'Entrepreneurship': [
      'Chapter 1 - The Nature of Entrepreneurship Study Notes',
      'Chapter 1 ( Part 2 ) - Entrepreneurship Study Notes',
      'Chapter 2 - Business Planning Study Notes',
      'Chapter 2 ( Part 2 ) - Business Planning Study Notes',
      'Chapter 3 - Business Formation Study Notes',
      'Chapter 3 ( Part 2 ) - Business Formation Study Notes',
      'Chapter 4 - Product_Service Development Study Notes',
      'Chapter 5 - Marketing Study Notes',
      'Chapter 5 ( Part 2 ) - Marketing Study Notes (1)',
      'Chapter 6 - Business Financing Study Notes',
      'Chapter 7 - Managing Growth and Transition',
    ],
    'History of Ethiopia': [
      'Unit 1',
      'Unit 2',
      'Unit 3',
      'Unit 4',
      'Unit 5 ( Part One )',
      'Unit 5 ( Part Two )',
      'Unit 6 ( Part One )',
      'Unit 6 ( Part Two )',
      'Unit 7 ( Part One )',
      'Unit 7 ( Part Two )',
    ],
  };

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

  List<String> _noteFiles() {
    if ((_categoryName == 'Pre-Engineering' || _categoryName == 'Others') &&
        _selectedNoteSubject != null &&
        _additionalNoteFiles.containsKey(_selectedNoteSubject)) {
      return [
        'Integrated Study Notes',
        ..._additionalNoteFiles[_selectedNoteSubject]!,
      ];
    }
    if (_categoryName == 'Others' && _selectedNoteSubject == 'Anthropology') {
      return ['Integrated Study Notes'];
    }
    if (_categoryName == 'Others' &&
        (_selectedNoteSubject == 'Entrepreneurship' ||
            _selectedNoteSubject == 'General Biology' ||
            _selectedNoteSubject == 'General Chemistry')) {
      return ['Integrated Study Notes'];
    }
    if ((_categoryName == 'Pre-Engineering' || _categoryName == 'Others') &&
        (_selectedNoteSubject == 'Anthropology' &&
                _categoryName == 'Pre-Engineering' ||
            (_categoryName == 'Others' &&
                _selectedNoteSubject == 'Anthropology') ||
            _selectedNoteSubject == 'Applied Mathematics I' ||
            _selectedNoteSubject == 'C++ Programming' ||
            _selectedNoteSubject == 'Communicative English II' ||
            _selectedNoteSubject == 'Entrepreneurship' ||
            _selectedNoteSubject == 'History of Ethiopia' ||
            _selectedNoteSubject == 'Introduction to Emerging Technologies' ||
            _selectedNoteSubject == 'Moral and Civics')) {
      return ['Integrated Study Notes'];
    }
    if (_categoryName != 'Freshman') return [];
    switch (_selectedNoteSubject) {
      case 'Communicative English Language Skills':
        return [
          'Integrated Study Notes',
          'Active and Passive Voice',
          'Brief Notes for First Year Students',
          'English Tenses In Context',
          'Fundamentals of English Grammar',
          'Passive Voice Excercise and Grammar Drills',
        ];
      case 'General Psychology':
        return [
          'Integrated Study Notes',
          'Chapter 1',
          'Chapter 2',
          'Chapter 3',
          'Chapter 4',
          'Chapter 5',
          'Chapter 6',
          'Chapter 7',
          'Chapter 8',
          'Chapter 9',
          'Chapter 10',
          'Chapter 11',
        ];
      case 'Geography':
        return [
          'Integrated Study Notes',
          'Chapter 1',
          'Chapter 2',
          'Chapter 3',
          'Chapter 4',
          'Chapter 5',
          'Chapter 6',
        ];
      case 'Logic and Critical Thinking':
        return [
          'Integrated Study Notes',
          'Chapter 1 - Part 1',
          'Chapter 1 - Part 2',
          'Chapter 2 - Part 1',
          'Chapter 2 - Part 2',
          'Chapter 2 - Part 3',
          'Chapter 3',
          'Chapter 4',
          'Chapter 5 - Part 1',
          'Chapter 5 - Part 2',
          'Chapter 5 - Part 3',
        ];
      case 'Mathematics for Natural Science':
        return [
          'Integrated Study Notes',
          'Mathematical Induction',
          'Propositional Logic and Set Theory',
          'Quantifiers and Quantified Arguments',
          'Set Theory',
        ];
      case 'Physics':
        return [
          'Integrated Study Notes',
          'Chapter 1',
          'Fluid Mechanics Freshman Study Material',
          'Freshman Physics Study Material',
          'Heat and Thermodynamics Study Guide',
          'Kinematics and Dynamics Study Guide',
          'Physics Freshman Module Study Guide',
        ];
      case 'Physical Fitness':
        return ['Integrated Study Notes'];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(_isAmharic);
    final title =
        widget.module == LearningModule.notes && _selectedNoteSubject != null
        ? _selectedNoteSubject!
        : _title(strings);
    final items = widget.module == LearningModule.notes
        ? (_selectedNoteSubject == null ? _items(strings) : _noteFiles())
        : _items(strings);
    final category = _category;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading:
            widget.module == LearningModule.notes &&
                _selectedNoteSubject != null
            ? IconButton(
                tooltip: 'Back',
                onPressed: () => setState(() => _selectedNoteSubject = null),
                icon: const Icon(Icons.arrow_back_rounded),
              )
            : null,
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.headlineSmall.copyWith(
                  fontSize: _selectedNoteSubject == null ? 18 : 15,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
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
              onSelected: (category) => setState(() {
                _categoryName = category;
                _selectedNoteSubject = null;
              }),
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
          SizedBox(
            width:
                widget.module == LearningModule.notes &&
                    _selectedNoteSubject != null
                ? 4
                : AppDimensions.sm,
          ),
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
                            if (widget.module == LearningModule.notes &&
                                _selectedNoteSubject == null) {
                              setState(() => _selectedNoteSubject = item);
                              return;
                            }
                            if (widget.module == LearningModule.notes &&
                                _selectedNoteSubject != null) {
                              if (item == 'Integrated Study Notes' &&
                                  (_selectedNoteSubject ==
                                          'Communicative English Language Skills' ||
                                      _selectedNoteSubject ==
                                          'General Psychology' ||
                                      _selectedNoteSubject == 'Geography' ||
                                      _selectedNoteSubject ==
                                          'Logic and Critical Thinking' ||
                                      _selectedNoteSubject ==
                                          'Mathematics for Natural Science' ||
                                      _selectedNoteSubject == 'Physics' ||
                                      _selectedNoteSubject ==
                                          'Physical Fitness' ||
                                      (_categoryName == 'Pre-Engineering' &&
                                          (_selectedNoteSubject ==
                                                  'Anthropology' ||
                                              _selectedNoteSubject ==
                                                  'Applied Mathematics I' ||
                                              _selectedNoteSubject ==
                                                  'C++ Programming' ||
                                              _selectedNoteSubject ==
                                                  'Communicative English II' ||
                                              _selectedNoteSubject ==
                                                  'Entrepreneurship' ||
                                              _selectedNoteSubject ==
                                                  'History of Ethiopia' ||
                                              _selectedNoteSubject ==
                                                  'Introduction to Emerging Technologies' ||
                                              _selectedNoteSubject ==
                                                  'Moral and Civics')) ||
                                      (_categoryName == 'Others' &&
                                          (_selectedNoteSubject ==
                                                  'Anthropology' ||
                                              _selectedNoteSubject ==
                                                  'Communicative English II' ||
                                              _selectedNoteSubject ==
                                                  'Entrepreneurship' ||
                                              _selectedNoteSubject ==
                                                  'General Biology' ||
                                              _selectedNoteSubject ==
                                                  'General Chemistry' ||
                                              _selectedNoteSubject ==
                                                  'History of Ethiopia' ||
                                              _selectedNoteSubject ==
                                                  'Introduction to Emerging Technologies' ||
                                              _selectedNoteSubject ==
                                                  'Moral and Civics')))) {
                                slideFadePush<void>(
                                  context,
                                  (_) => CommunicativeEnglishNotesScreen(
                                    assetPath:
                                        _selectedNoteSubject ==
                                            'General Psychology'
                                        ? 'assets/content/general_psychology/notes.json'
                                        : _selectedNoteSubject == 'Geography'
                                        ? 'assets/content/geography/notes.json'
                                        : _selectedNoteSubject ==
                                              'Logic and Critical Thinking'
                                        ? 'assets/content/logic_critical_thinking/notes.json'
                                        : _selectedNoteSubject ==
                                              'Mathematics for Natural Science'
                                        ? 'assets/content/mathematics_natural_science/notes.json'
                                        : _selectedNoteSubject == 'Physics'
                                        ? 'assets/content/physics/notes.json'
                                        : _selectedNoteSubject ==
                                              'Physical Fitness'
                                        ? 'assets/content/physical_fitness/notes.json'
                                        : _categoryName == 'Pre-Engineering' &&
                                              _selectedNoteSubject ==
                                                  'Anthropology'
                                        ? 'assets/content/anthropology_preengineering/notes.json'
                                        : _categoryName == 'Others' &&
                                              _selectedNoteSubject ==
                                                  'Anthropology'
                                        ? 'assets/content/anthropology_preengineering/notes.json'
                                        : _categoryName == 'Pre-Engineering' &&
                                              _selectedNoteSubject ==
                                                  'Applied Mathematics I'
                                        ? 'assets/content/applied_mathematics_i/notes.json'
                                        : _categoryName == 'Pre-Engineering' &&
                                              _selectedNoteSubject ==
                                                  'C++ Programming'
                                        ? 'assets/content/cpp_programming/notes.json'
                                        : _categoryName == 'Pre-Engineering' &&
                                              _selectedNoteSubject ==
                                                  'Communicative English II'
                                        ? 'assets/content/communicative_english_ii/notes.json'
                                        : _categoryName == 'Others' &&
                                              _selectedNoteSubject ==
                                                  'Communicative English II'
                                        ? 'assets/content/communicative_english_ii/notes.json'
                                        : _categoryName == 'Others' &&
                                              _selectedNoteSubject ==
                                                  'Entrepreneurship'
                                        ? 'assets/content/entrepreneurship_preengineering/notes.json'
                                        : _categoryName == 'Others' &&
                                              _selectedNoteSubject ==
                                                  'General Biology'
                                        ? 'assets/content/general_biology_others/notes.json'
                                        : _categoryName == 'Others' &&
                                              _selectedNoteSubject ==
                                                  'General Chemistry'
                                        ? 'assets/content/general_chemistry_others/notes.json'
                                        : _categoryName == 'Others' &&
                                              _selectedNoteSubject ==
                                                  'History of Ethiopia'
                                        ? 'assets/content/history_ethiopia_preengineering/notes.json'
                                        : _categoryName == 'Others' &&
                                              _selectedNoteSubject == 'Introduction to Emerging Technologies'
                                        ? 'assets/content/emerging_technologies/notes.json'
                                        : _categoryName == 'Others' &&
                                              _selectedNoteSubject ==
                                                  'Moral and Civics'
                                        ? 'assets/content/moral_civics_preengineering/notes.json'
                                        : _categoryName == 'Pre-Engineering' &&
                                              _selectedNoteSubject ==
                                                  'Entrepreneurship'
                                        ? 'assets/content/entrepreneurship_preengineering/notes.json'
                                        : _categoryName == 'Pre-Engineering' &&
                                              _selectedNoteSubject ==
                                                  'History of Ethiopia'
                                        ? 'assets/content/history_ethiopia_preengineering/notes.json'
                                        : _categoryName == 'Pre-Engineering' &&
                                              _selectedNoteSubject == 'Introduction to Emerging Technologies'
                                        ? 'assets/content/emerging_technologies/notes.json'
                                        : _categoryName == 'Pre-Engineering' &&
                                              _selectedNoteSubject ==
                                                  'Moral and Civics'
                                        ? 'assets/content/moral_civics_preengineering/notes.json'
                                        : 'assets/content/communicative_english_1/notes.json',
                                    appBarTitle: _selectedNoteSubject!,
                                    courseCode:
                                        _selectedNoteSubject ==
                                            'General Psychology'
                                        ? 'PsyL 1011'
                                        : _selectedNoteSubject == 'Geography'
                                        ? 'GeES 1011'
                                        : _selectedNoteSubject ==
                                              'Logic and Critical Thinking'
                                        ? 'PHIL 1011'
                                        : _selectedNoteSubject ==
                                              'Mathematics for Natural Science'
                                        ? 'Mathematics'
                                        : _selectedNoteSubject == 'Physics'
                                        ? 'Physics'
                                        : _selectedNoteSubject ==
                                              'Physical Fitness'
                                        ? 'SpSc 1011'
                                        : _categoryName == 'Pre-Engineering' &&
                                              _selectedNoteSubject ==
                                                  'Anthropology'
                                        ? 'Anth 1012'
                                        : _categoryName == 'Pre-Engineering' &&
                                              _selectedNoteSubject ==
                                                  'Applied Mathematics I'
                                        ? 'Math-1051'
                                        : _categoryName == 'Pre-Engineering' &&
                                              _selectedNoteSubject ==
                                                  'C++ Programming'
                                        ? 'Introduction to Programming'
                                        : _categoryName == 'Pre-Engineering' &&
                                              _selectedNoteSubject ==
                                                  'Communicative English II'
                                        ? 'Communicative English II'
                                        : _categoryName == 'Pre-Engineering' &&
                                              _selectedNoteSubject ==
                                                  'Entrepreneurship'
                                        ? 'Entrepreneurship'
                                        : _categoryName == 'Others' &&
                                              _selectedNoteSubject ==
                                                  'General Biology'
                                        ? 'Biol. 1012'
                                        : _categoryName == 'Others' &&
                                              _selectedNoteSubject ==
                                                  'General Chemistry'
                                        ? 'CHEM.1012'
                                        : _categoryName == 'Others' &&
                                              _selectedNoteSubject ==
                                                  'History of Ethiopia'
                                        ? 'History of Ethiopia and the Horn'
                                        : _categoryName == 'Others' &&
                                              _selectedNoteSubject == 'Introduction to Emerging Technologies'
                                        ? 'EMTE1011/1012'
                                        : _categoryName == 'Others' &&
                                              _selectedNoteSubject ==
                                                  'Moral and Civics'
                                        ? 'MCED 1011'
                                        : _categoryName == 'Pre-Engineering' &&
                                              _selectedNoteSubject ==
                                                  'History of Ethiopia'
                                        ? 'History of Ethiopia and the Horn'
                                        : _categoryName == 'Pre-Engineering' &&
                                              _selectedNoteSubject == 'Introduction to Emerging Technologies'
                                        ? 'EMTE1011/1012'
                                        : _categoryName == 'Pre-Engineering' &&
                                              _selectedNoteSubject ==
                                                  'Moral and Civics'
                                        ? 'MCED 1011'
                                        : 'FLEn 1011',
                                  ),
                                );
                                return;
                              }
                              final noteAsset = _noteAsset(item);
                              if (noteAsset != null) {
                                slideFadePush<void>(
                                  context,
                                  (_) => PdfReaderScreen(
                                    title: item,
                                    assetPath: noteAsset,
                                    showDownload: false,
                                  ),
                                );
                              }
                              return;
                            }
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
                            if (widget.module == LearningModule.practice) {
                              slideFadePush<void>(
                                context,
                                (_) => UnitSelectionScreen(
                                  subject: item,
                                  isAmharic: _isAmharic,
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

  String? _noteAsset(String note) {
    if (_categoryName == 'Pre-Engineering' || _categoryName == 'Others') {
      final files = _additionalNoteFiles[_selectedNoteSubject];
      if (files == null || !files.contains(note)) return null;
      final folder = _categoryName == 'Pre-Engineering'
          ? 'PreEngineering'
          : 'Others';
      return 'assets/notes/$folder/$_selectedNoteSubject/$note.pdf';
    }
    if (_categoryName != 'Freshman') return null;
    const assetsBySubject = {
      'Communicative English Language Skills': {
        'Active and Passive Voice': 'assets/notes/Freshman/Communicative English Language Skills/Active and Passive Voice.pdf',
        'Brief Notes for First Year Students': 'assets/notes/Freshman/Communicative English Language Skills/Brief Notes for First Year Students.pdf',
        'English Tenses In Context': 'assets/notes/Freshman/Communicative English Language Skills/English Tenses In Context.pdf',
        'Fundamentals of English Grammar': 'assets/notes/Freshman/Communicative English Language Skills/Fundamentals-of-English-Grammar.pdf',
        'Passive Voice Excercise and Grammar Drills': 'assets/notes/Freshman/Communicative English Language Skills/Passive Voice Excercise and Grammar Drills.pdf',
      },
      'General Psychology': {
        'Chapter 1': 'assets/notes/Freshman/General Psychology/Chapter_1.pdf',
        'Chapter 2': 'assets/notes/Freshman/General Psychology/Chapter_2.pdf',
        'Chapter 3': 'assets/notes/Freshman/General Psychology/Chapter_3.pdf',
        'Chapter 4': 'assets/notes/Freshman/General Psychology/Chapter_4.pdf',
        'Chapter 5': 'assets/notes/Freshman/General Psychology/Chapter_5.pdf',
        'Chapter 6': 'assets/notes/Freshman/General Psychology/Chapter_6.pdf',
        'Chapter 7': 'assets/notes/Freshman/General Psychology/Chapter_7.pdf',
        'Chapter 8': 'assets/notes/Freshman/General Psychology/Chapter_8.pdf',
        'Chapter 9': 'assets/notes/Freshman/General Psychology/Chapter_9.pdf',
        'Chapter 10': 'assets/notes/Freshman/General Psychology/Chapter_10.pdf',
        'Chapter 11': 'assets/notes/Freshman/General Psychology/chapter_11.pdf',
      },
      'Geography': {
        'Chapter 1': 'assets/notes/Freshman/Geography/Chapter 1.pdf',
        'Chapter 2': 'assets/notes/Freshman/Geography/Chapter 2.pdf',
        'Chapter 3': 'assets/notes/Freshman/Geography/Chapter 3.pdf',
        'Chapter 4': 'assets/notes/Freshman/Geography/Chapter 4.pdf',
        'Chapter 5': 'assets/notes/Freshman/Geography/Chapter 5.pdf',
        'Chapter 6': 'assets/notes/Freshman/Geography/Chapter 6.pdf',
      },
      'Logic and Critical Thinking': {
        'Chapter 1 - Part 1': 'assets/notes/Freshman/Logic and Critical Thinking/Chapter 1 - Part 1.pdf',
        'Chapter 1 - Part 2': 'assets/notes/Freshman/Logic and Critical Thinking/Chapter 1 - Part 2.pdf',
        'Chapter 2 - Part 1': 'assets/notes/Freshman/Logic and Critical Thinking/Chapter 2 - Part 1.pdf',
        'Chapter 2 - Part 2': 'assets/notes/Freshman/Logic and Critical Thinking/Chapter 2 - Part 2.pdf',
        'Chapter 2 - Part 3': 'assets/notes/Freshman/Logic and Critical Thinking/Chapter 2 - Part 3.pdf',
        'Chapter 3':
            'assets/notes/Freshman/Logic and Critical Thinking/Chapter 3.pdf',
        'Chapter 4':
            'assets/notes/Freshman/Logic and Critical Thinking/Chapter 4 .pdf',
        'Chapter 5 - Part 1': 'assets/notes/Freshman/Logic and Critical Thinking/Chapter 5 - Part 1.pdf',
        'Chapter 5 - Part 2': 'assets/notes/Freshman/Logic and Critical Thinking/Chapter 5 - Part 2.pdf',
        'Chapter 5 - Part 3': 'assets/notes/Freshman/Logic and Critical Thinking/Chapter 5 - Part 3.pdf',
      },
      'Mathematics for Natural Science': {
        'Mathematical Induction': 'assets/notes/Freshman/Mathematics for Natural Science/Mathematical Induction.pdf',
        'Propositional Logic and Set Theory': 'assets/notes/Freshman/Mathematics for Natural Science/Propositional Logic and Set Theory.pdf',
        'Quantifiers and Quantified Arguments': 'assets/notes/Freshman/Mathematics for Natural Science/Quantifiers and Quantified Arguments.pdf',
        'Set Theory': 'assets/notes/Freshman/Mathematics for Natural Science/Set Theory.pdf',
      },
      'Physics': {
        'Chapter 1': 'assets/notes/Freshman/Physics/Chapter_1.pdf',
        'Fluid Mechanics Freshman Study Material': 'assets/notes/Freshman/Physics/Fluid_Mechanics_Freshman_Study_Material.pdf',
        'Freshman Physics Study Material':
            'assets/notes/Freshman/Physics/Freshman_Physics_Study_Material.pdf',
        'Heat and Thermodynamics Study Guide': 'assets/notes/Freshman/Physics/Heat_and_Thermodynamics_Study_Guide.pdf',
        'Kinematics and Dynamics Study Guide': 'assets/notes/Freshman/Physics/Kinematics_and_Dynamics_Study_Guide.pdf',
        'Physics Freshman Module Study Guide': 'assets/notes/Freshman/Physics/Physics_Freshman_Module_Study_Guide.pdf',
      },
    };
    return assetsBySubject[_selectedNoteSubject]?[note];
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
