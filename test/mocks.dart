import 'package:jacked/src/db/services/exercise_entry_service.dart';
import 'package:jacked/src/db/services/exercise_service.dart';
import 'package:jacked/src/db/services/workout_service.dart';
import 'package:mocktail/mocktail.dart';

class MockExerciseService extends Mock implements ExerciseService {}

class MockWorkoutService extends Mock implements WorkoutService {}

class MockExerciseEntryService extends Mock implements ExerciseEntryService {}
