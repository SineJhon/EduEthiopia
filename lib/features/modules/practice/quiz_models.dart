/// Data models for the Practice & Quiz question bank.
///
/// Educational content is kept here, separate from UI code.
/// All content works offline (compiled into the app).
library;

class QuizUnit {
  final String unitId;
  final String title;
  final QuizReadingPassage? readingPassage;
  final List<QuizQuestion> questions;

  const QuizUnit({
    required this.unitId,
    required this.title,
    this.readingPassage,
    required this.questions,
  });

  int get totalQuestions => questions.length;
}

class QuizReadingPassage {
  final String id;
  final String title;
  final String text;

  /// True when the passage is an original practice item inspired by the unit,
  /// not a verbatim textbook passage.
  final bool isPracticePassage;

  const QuizReadingPassage({
    required this.id,
    required this.title,
    required this.text,
    this.isPracticePassage = false,
  });
}

class QuizQuestion {
  final String id;
  final String unitId;
  final String topicId;

  /// 'multiple_choice' or 'true_false'
  final String type;

  /// 'easy', 'medium', or 'hard'
  final String difficulty;
  final String question;

  /// When non-null, the question is tied to a reading passage.
  final String? passageId;
  final List<QuizOption> options;
  final String correctOptionId;
  final String explanation;

  /// Printed source-page reference where available.
  final int? sourcePage;

  const QuizQuestion({
    required this.id,
    required this.unitId,
    required this.topicId,
    required this.type,
    required this.difficulty,
    required this.question,
    this.passageId,
    required this.options,
    required this.correctOptionId,
    required this.explanation,
    this.sourcePage,
  });

  /// Returns the option matching [correctOptionId].
  QuizOption get correctOption =>
      options.firstWhere((o) => o.id == correctOptionId);

  bool isCorrect(String optionId) => optionId == correctOptionId;
}

class QuizOption {
  final String id;
  final String text;

  const QuizOption({required this.id, required this.text});
}

/// Result of a completed quiz attempt.
class QuizAttemptResult {
  final String unitId;
  final String unitTitle;
  final int totalQuestions;
  final int correct;
  final int incorrect;
  final double percentage;
  final List<QuizReviewItem> incorrectReviews;
  final DateTime completedAt;

  const QuizAttemptResult({
    required this.unitId,
    required this.unitTitle,
    required this.totalQuestions,
    required this.correct,
    required this.incorrect,
    required this.percentage,
    required this.incorrectReviews,
    required this.completedAt,
  });
}

/// A single incorrect question shown on the review screen.
class QuizReviewItem {
  final QuizQuestion question;
  final String selectedOptionId;
  final String correctOptionId;
  final bool isCorrect;

  const QuizReviewItem({
    required this.question,
    required this.selectedOptionId,
    required this.correctOptionId,
    required this.isCorrect,
  });
}

/// Persisted progress for a unit (saved locally for offline access).
class UnitProgress {
  final String unitId;
  final int bestScore;
  final int totalQuestions;
  final double bestPercentage;
  final int attempts;
  final DateTime? lastCompletedAt;

  const UnitProgress({
    required this.unitId,
    this.bestScore = 0,
    required this.totalQuestions,
    this.bestPercentage = 0.0,
    this.attempts = 0,
    this.lastCompletedAt,
  });

  UnitProgress copyWith({
    String? unitId,
    int? bestScore,
    int? totalQuestions,
    double? bestPercentage,
    int? attempts,
    DateTime? lastCompletedAt,
  }) {
    return UnitProgress(
      unitId: unitId ?? this.unitId,
      bestScore: bestScore ?? this.bestScore,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      bestPercentage: bestPercentage ?? this.bestPercentage,
      attempts: attempts ?? this.attempts,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
    );
  }
}
