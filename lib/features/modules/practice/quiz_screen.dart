import 'package:flutter/material.dart';

import '../../../core/design/app_dimensions.dart';
import '../../../core/widgets/animated/page_transition.dart';
import '../../../core/widgets/theme_toggle.dart';
import 'quiz_data.dart';
import 'quiz_models.dart';
import 'quiz_progress_service.dart';
import 'quiz_result_screen.dart';

/// The interactive quiz experience: one question at a time with immediate
/// feedback, answer highlighting, explanations, and a results summary.
class QuizScreen extends StatefulWidget {
  const QuizScreen({
    required this.subject,
    required this.unit,
    super.key,
  });

  final String subject;
  final QuizUnit unit;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _questionIndex = 0;
  bool _submitted = false;
  String? _selectedOptionId;
  final Map<String, String> _answers = {}; // questionId -> selected option id
  final List<QuizReviewItem> _incorrectReviews = [];

  bool get _isLastQuestion => _questionIndex == widget.unit.questions.length - 1;
  QuizQuestion get _currentQuestion => widget.unit.questions[_questionIndex];

  /// Whether any remaining question uses the reading passage (keeps it visible).
  bool get _passageStillRelevant {
    return widget.unit.questions.any((q) => q.passageId != null);
  }

  String? _selectedAnswerText() {
    if (_selectedOptionId == null) return null;
    final option = _currentQuestion.options.firstWhere(
      (o) => o.id == _selectedOptionId,
      orElse: () => _currentQuestion.options.first,
    );
    return option.text;
  }

  void _selectOption(String optionId) {
    if (_submitted) return;
    setState(() => _selectedOptionId = optionId);
  }

  void _submitAnswer() {
    if (_selectedOptionId == null) return;
    final correct = _currentQuestion.isCorrect(_selectedOptionId!);
    _answers[_currentQuestion.id] = _selectedOptionId!;
    if (!correct) {
      _incorrectReviews.add(QuizReviewItem(
        question: _currentQuestion,
        selectedOptionId: _selectedOptionId!,
        correctOptionId: _currentQuestion.correctOptionId,
        isCorrect: false,
      ));
    }
    setState(() => _submitted = true);
  }

  void _nextQuestion() {
    if (_isLastQuestion) {
      _finishQuiz();
      return;
    }
    setState(() {
      _questionIndex++;
      _submitted = false;
      _selectedOptionId = null;
    });
  }

  Future<void> _finishQuiz() async {
    final total = widget.unit.questions.length;
    final correct = total - _incorrectReviews.length;
    final percentage = total == 0 ? 0.0 : (correct / total) * 100;
    final result = QuizAttemptResult(
      unitId: widget.unit.unitId,
      unitTitle: widget.unit.title,
      totalQuestions: total,
      correct: correct,
      incorrect: _incorrectReviews.length,
      percentage: percentage,
      incorrectReviews: _incorrectReviews,
      completedAt: DateTime.now(),
    );
    await QuizProgressService.instance.saveAttempt(result);
    if (!mounted) return;
    slideFadePush<void>(
      context,
      (_) => QuizResultScreen(result: result),
    );
  }
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final questionNumber = _questionIndex + 1;
    final total = widget.unit.questions.length;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.unit.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [ThemeToggle(), const SizedBox(width: 8)],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.md, AppDimensions.sm, AppDimensions.md, 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$questionNumber of $total',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: questionNumber / total,
                    backgroundColor: colorScheme.surfaceContainerLow,
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            if (_passageStillRelevant && widget.unit.readingPassage != null)
              _PassageCard(passage: widget.unit.readingPassage!),
            Expanded(child: _submitted ? _feedbackView() : _questionView()),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.md, AppDimensions.sm, AppDimensions.md,
                AppDimensions.lg,
              ),
              child: _submitted
                  ? (_isLastQuestion
                      ? const SizedBox.shrink()
                      : FilledButton(onPressed: _nextQuestion, child: const Text('Next Question')))
                  : FilledButton(
                      onPressed: _selectedOptionId == null ? null : _submitAnswer,
                      child: const Text('Submit Answer'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _questionView() {
    final colorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.md, 0, AppDimensions.md, AppDimensions.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _currentQuestion.question,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          ..._currentQuestion.options.map((option) => _OptionTile(
            option: option,
            selected: _selectedOptionId == option.id,
            submitted: _submitted,
            isCorrect: option.id == _currentQuestion.correctOptionId,
            onTap: () => _selectOption(option.id),
          )),
          const SizedBox(height: AppDimensions.lg),
          if (_currentQuestion.type == 'true_false')
            Text(
              'Select True or False.',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }

  Widget _feedbackView() {
    final colorScheme = Theme.of(context).colorScheme;
    final correct = _currentQuestion.isCorrect(_selectedOptionId ?? "");
    final selectedText = _selectedAnswerText();
    final correctOption = _currentQuestion.correctOption;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.md, 0, AppDimensions.md, AppDimensions.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: correct ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: correct ? Colors.green : Colors.red),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(correct ? Icons.check_circle_rounded : Icons.cancel_rounded,
                    color: correct ? Colors.green : Colors.red, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(correct ? 'Correct!' : 'Incorrect.',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16,
                          color: correct ? Colors.green.shade800 : Colors.red.shade800)),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          if (selectedText != null && !correct) ...[
            Text('Your answer: $selectedText',
                style: TextStyle(color: Colors.red.shade800, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
          ],
          Text('Correct answer: ${correctOption.text}',
              style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.w800)),
          const SizedBox(height: AppDimensions.md),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Explanation',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: colorScheme.primary)),
                const SizedBox(height: 6),
                Text(_currentQuestion.explanation, style: const TextStyle(height: 1.45)),
                if (_currentQuestion.sourcePage != null) ...[
                  const SizedBox(height: 6),
                  Text('Source: p.${_currentQuestion.sourcePage}',
                      style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant, fontStyle: FontStyle.italic)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

}

class _PassageCard extends StatelessWidget {
  const _PassageCard({required this.passage});
  final QuizReadingPassage passage;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.fromLTRB(AppDimensions.md, 0, AppDimensions.md, AppDimensions.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.description_rounded, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Reading Passage${passage.isPracticePassage ? ' (practice)' : ''}',
                      style: TextStyle(fontWeight: FontWeight.w900, color: colorScheme.primary, fontSize: 13)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(passage.title,
                style: TextStyle(fontWeight: FontWeight.w800, color: colorScheme.onSurface, fontSize: 15)),
            const SizedBox(height: 8),
            Text(passage.text, style: const TextStyle(height: 1.5)),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.option, required this.selected, required this.submitted, required this.isCorrect, required this.onTap});
  final QuizOption option;
  final bool selected;
  final bool submitted;
  final bool isCorrect;
  final VoidCallback onTap;
  Color _borderColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (!submitted) return scheme.outlineVariant;
    if (isCorrect) return Colors.green;
    if (selected) return Colors.red;
    return scheme.outlineVariant;
  }
  Color _fillColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (!submitted) return selected ? scheme.primary.withValues(alpha: 0.08) : Colors.transparent;
    if (isCorrect) return Colors.green.withValues(alpha: 0.1);
    if (selected) return Colors.red.withValues(alpha: 0.1);
    return Colors.transparent;
  }
  IconData _icon(BuildContext context) {
    if (!submitted) return Icons.radio_button_unchecked_rounded;
    if (isCorrect) return Icons.check_circle_rounded;
    if (selected) return Icons.cancel_rounded;
    return Icons.radio_button_unchecked_rounded;
  }
  Color _iconColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (!submitted) return scheme.onSurfaceVariant;
    if (isCorrect) return Colors.green;
    if (selected) return Colors.red;
    return scheme.onSurfaceVariant;
  }
  Color _selectedFill(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (!submitted) return selected ? scheme.primary : Colors.transparent;
    if (isCorrect) return Colors.green;
    if (selected) return Colors.red;
    return Colors.transparent;
  }
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: submitted ? null : onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _fillColor(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderColor(context), width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(color: _selectedFill(context), shape: BoxShape.circle, border: Border.all(color: _iconColor(context), width: 2)),
              child: Center(child: Icon(_icon(context), size: 18, color: _iconColor(context))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(option.text,
                  style: TextStyle(fontWeight: FontWeight.w600,
                      color: submitted ? scheme.onSurface : scheme.onSurfaceVariant)),
            ),
            if (submitted && isCorrect) Icon(Icons.check_circle_rounded, color: Colors.green, size: 20),
          ],
        ),
      ),
    );
  }
}

