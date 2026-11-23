import 'package:flutter/material.dart';

import '../../../core/design/app_dimensions.dart';
import '../../../core/widgets/theme_toggle.dart';
import 'quiz_data.dart';
import 'quiz_models.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({required this.result, super.key});

  final QuizAttemptResult result;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final passed = result.percentage >= 60;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [ThemeToggle(), const SizedBox(width: 8)],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppDimensions.md, AppDimensions.sm, AppDimensions.md, AppDimensions.md),
              child: Column(
                children: [
                  Text(result.unitTitle,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, color: colorScheme.onSurface),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 6),
                  Text('${result.correct} / ${result.totalQuestions} correct',
                      style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: AppDimensions.md),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: passed ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: passed ? Colors.green : Colors.red),
                    ),
                    child: Column(
                      children: [
                        Text('${result.percentage.toStringAsFixed(0)}%',
                            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: passed ? Colors.green.shade800 : Colors.red.shade800)),
                        const SizedBox(height: 6),
                        Text(passed ? 'Passed' : 'Not passed',
                            style: TextStyle(fontWeight: FontWeight.w800, color: passed ? Colors.green.shade800 : Colors.red.shade800, fontSize: 14)),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.md),
                  _StatRow(label: 'Correct', value: '${result.correct}', color: Colors.green),
                  _StatRow(label: 'Incorrect', value: '${result.incorrect}', color: Colors.red),
                  _StatRow(label: 'Total', value: '${result.totalQuestions}', color: colorScheme.onSurfaceVariant),
                  const SizedBox(height: AppDimensions.lg),
                  if (result.incorrectReviews.isNotEmpty) ...[
                    Row(children: [Expanded(child: Text('Review Incorrect Answers', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: colorScheme.onSurface)))]),
                    const SizedBox(height: 8),
                    Expanded(child: ListView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: result.incorrectReviews.length, itemBuilder: (context, i) => _ReviewItem(item: result.incorrectReviews[i]))),
                    const SizedBox(height: AppDimensions.md),
                  ],
                  Row(children: [
                    Expanded(child: OutlinedButton(onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst), child: const Text('Back to Units'))),
                    const SizedBox(width: 12),
                    Expanded(child: FilledButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Retry Unit'))),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13))),
          Text(value, style: TextStyle(fontWeight: FontWeight.w800, color: color, fontSize: 14)),
        ],
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  const _ReviewItem({required this.item});
  final QuizReviewItem item;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.question.question, style: TextStyle(fontWeight: FontWeight.w700, color: colorScheme.onSurface)),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.cancel_rounded, color: Colors.red, size: 16),
                const SizedBox(width: 6),
                Expanded(child: Text('You: ${item.selectedOptionId.isNotEmpty ? item.selectedOptionId : '—'}', style: TextStyle(color: Colors.red.shade700, fontSize: 12, fontWeight: FontWeight.w700))),
                const SizedBox(width: 12),
                Icon(Icons.check_circle_rounded, color: Colors.green, size: 16),
                const SizedBox(width: 6),
                Expanded(child: Text('Correct: ${item.correctOptionId}', style: TextStyle(color: Colors.green.shade700, fontSize: 12, fontWeight: FontWeight.w700))),
              ],
            ),
            const SizedBox(height: 6),
            Text(item.question.explanation, style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

