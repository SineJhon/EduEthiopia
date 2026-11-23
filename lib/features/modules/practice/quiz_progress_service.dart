/// Persists quiz attempt results and unit progress locally for offline access.
///
/// Uses path_provider to write a JSON file in the app's documents directory.

import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'quiz_models.dart';

const String _progressFileName = 'eduethiopia_quiz_progress.json';

class QuizProgressService {
  QuizProgressService._();
  static final QuizProgressService instance = QuizProgressService._();

  Directory? _docDir;

  Future<Directory> get _documents async {
    if (_docDir != null) return _docDir!;
    _docDir = await getApplicationDocumentsDirectory();
    return _docDir!;
  }

  Future<File> get _file async => File('${(await _documents).path}/$_progressFileName');

  /// Load all unit progress from disk. Returns empty map if none saved yet.
  Future<Map<String, UnitProgress>> loadProgress() async {
    try {
      final file = await _file;
      if (!await file.exists()) return {};
      final jsonString = await file.readAsString();
      final Map<String, dynamic> decoded = jsonDecode(jsonString);
      final result = <String, UnitProgress>{};
      decoded.forEach((key, value) {
        result[key] = UnitProgress(
          unitId: key,
          bestScore: (value['bestScore'] as num?)?.toInt() ?? 0,
          totalQuestions: (value['totalQuestions'] as num?)?.toInt() ?? 0,
          bestPercentage: (value['bestPercentage'] as num?)?.toDouble() ?? 0.0,
          attempts: (value['attempts'] as num?)?.toInt() ?? 0,
          lastCompletedAt: value['lastCompletedAt'] == null
              ? null
              : DateTime.parse(value['lastCompletedAt'] as String),
        );
      });
      return result;
    } catch (_) {
      return {};
    }
  }

  /// Save a completed attempt and update unit progress.
  Future<void> saveAttempt(QuizAttemptResult result) async {
    try {
      final progress = await loadProgress();
      final existing = progress[result.unitId];
      final attempts = (existing?.attempts ?? 0) + 1;
      final bestScore = result.correct > (existing?.bestScore ?? 0)
          ? result.correct
          : (existing?.bestScore ?? 0);
      final bestPercentage = result.percentage > (existing?.bestPercentage ?? 0)
          ? result.percentage
          : (existing?.bestPercentage ?? 0.0);
      progress[result.unitId] = UnitProgress(
        unitId: result.unitId,
        bestScore: bestScore,
        totalQuestions: result.totalQuestions,
        bestPercentage: bestPercentage,
        attempts: attempts,
        lastCompletedAt: result.completedAt,
      );
      final file = await _file;
      await file.writeAsString(jsonEncode(progress.map((k, v) => MapEntry(k, {
        'unitId': v.unitId,
        'bestScore': v.bestScore,
        'totalQuestions': v.totalQuestions,
        'bestPercentage': v.bestPercentage,
        'attempts': v.attempts,
        'lastCompletedAt': v.lastCompletedAt?.toIso8601String(),
      }))));
    } catch (_) {
      // Silently ignore persistence failures so offline use still works.
    }
  }

  /// Load progress for a single unit.
  Future<UnitProgress> getUnitProgress(String unitId) async {
    final progress = await loadProgress();
    return progress[unitId] ??
        UnitProgress(
          unitId: unitId,
          totalQuestions: 30,
        );
  }

  /// Clear all progress (for testing/reset).
  Future<void> clearProgress() async {
    try {
      final file = await _file;
      if (await file.exists()) await file.delete();
    } catch (_) {}
  }
}
