/// Aggregates all quiz units for the Practice & Quiz section.
///
/// Each unit contains exactly 30 questions, of which 5 are linked to a
/// reading passage. Content is based on the Communicative English FLEn 1011
/// module notes (assets/content/communicative_english_1/notes.json).
library;

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
import 'quiz_unit_psych_ch1.dart';
export 'quiz_unit_psych_ch1.dart';
import 'quiz_unit_psych_ch2.dart';
export 'quiz_unit_psych_ch2.dart';
import 'quiz_unit_psych_ch3.dart';
export 'quiz_unit_psych_ch3.dart';
import 'quiz_unit_psych_ch4.dart';
export 'quiz_unit_psych_ch4.dart';
import 'quiz_unit_psych_ch5.dart';
export 'quiz_unit_psych_ch5.dart';
import 'quiz_unit_psych_ch6.dart';
export 'quiz_unit_psych_ch6.dart';
import 'quiz_unit_psych_ch7.dart';
export 'quiz_unit_psych_ch7.dart';
import 'quiz_unit_psych_ch8.dart';
export 'quiz_unit_psych_ch8.dart';
import 'quiz_unit_psych_ch9.dart';
export 'quiz_unit_psych_ch9.dart';
import 'quiz_unit_psych_ch10.dart';
export 'quiz_unit_psych_ch10.dart';
import 'quiz_unit_psych_ch11.dart';
export 'quiz_unit_psych_ch11.dart';

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
  'General Psychology': [
    psychCh1EssenceOfPsychology,
    psychCh2HumanDevelopment,
    psychCh3LearningAndTheories,
    psychCh4MemoryAndForgetting,
    psychCh5MotivationAndEmotions,
    psychCh6Personality,
    psychCh7DisordersAndTreatment,
    psychCh8IntroductionToLifeSkills,
    psychCh9IntrapersonalAndPersonalSkills,
    psychCh10AcademicSkills,
    psychCh11SocialSkills,
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
