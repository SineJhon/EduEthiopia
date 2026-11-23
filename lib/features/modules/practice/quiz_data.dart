/// Aggregates all quiz units for the Practice & Quiz section.
///
/// Each unit contains exactly 30 questions, of which 5 are linked to a
/// reading passage. Content is based on the Communicative English FLEn 1011
/// module notes (assets/content/communicative_english_1/notes.json).

import 'quiz_models.dart';
export 'quiz_models.dart';
import 'quiz_unit_1_study_skills.dart';
export 'quiz_unit_1_study_skills.dart';
import 'quiz_unit_2_health_fitness.dart';
export 'quiz_unit_2_health_fitness.dart';
import 'quiz_unit_3_cultural_values.dart';
export 'quiz_unit_3_cultural_values.dart';
import 'quiz_unit_4_wildlife.dart';
export 'quiz_unit_4_wildlife.dart';
import 'quiz_unit_5_population.dart';
export 'quiz_unit_5_population.dart';

/// All available units, keyed by subject then unit id.
///
/// The Practice & Quiz subject list uses the existing subject names; this map
/// associates the Communicative English subject with its 5 units.
final Map<String, List<QuizUnit>> quizUnitsBySubject = {
  'Communicative English Language Skills': [
    unit1StudySkills,
    unit2HealthAndFitness,
    unit3CulturalValues,
    unit4Wildlife,
    unit5Population,
  ],
};

/// Lookup a unit by subject and unitId.
QuizUnit? findUnit(String subject, String unitId) {
  final units = quizUnitsBySubject[subject];
  if (units == null) return null;
  return units.firstWhere(
    (u) => u.unitId == unitId,
    orElse: () => throw StateError('Unit $unitId not found in $subject'),
  );
}
