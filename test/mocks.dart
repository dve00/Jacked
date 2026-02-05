import 'package:jacked/src/db/repositories/exercise_entry_repository.dart';
import 'package:jacked/src/db/repositories/exercise_repository.dart';
import 'package:jacked/src/db/repositories/exercise_set_repository.dart';
import 'package:jacked/src/db/repositories/workout_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockExerciseRepo extends Mock implements ExerciseRepository {}

class MockWorkoutRepo extends Mock implements WorkoutRepository {}

class MockExerciseEntryRepo extends Mock implements ExerciseEntryRepository {}

class MockExerciseSetRepo extends Mock implements ExerciseSetRepository {}
