import 'package:jacked/src/db/repositories/exercise_entry_repository.dart';
import 'package:jacked/src/db/repositories/exercise_repository.dart';
import 'package:jacked/src/db/repositories/exercise_set_repository.dart';
import 'package:jacked/src/db/repositories/workout_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockExerciseService extends Mock implements ExerciseRepository {}

class MockWorkoutService extends Mock implements WorkoutRepository {}

class MockExerciseEntryService extends Mock implements ExerciseEntryRepository {}

class MockExerciseSetService extends Mock implements ExerciseSetRepository {}
