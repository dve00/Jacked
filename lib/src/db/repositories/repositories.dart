import 'package:jacked/src/db/repositories/exercise_entry_repository.dart';
import 'package:jacked/src/db/repositories/exercise_repository.dart';
import 'package:jacked/src/db/repositories/exercise_set_repository.dart';
import 'package:jacked/src/db/repositories/workout_repository.dart';

class Repositories {
  final ExerciseRepository exerciseRepo;
  final ExerciseEntryRepository exerciseEntryRepo;
  final ExerciseSetRepository exerciseSetRepo;
  final WorkoutRepository workoutRepo;

  Repositories({
    required this.exerciseRepo,
    required this.exerciseEntryRepo,
    required this.exerciseSetRepo,
    required this.workoutRepo,
  });
}
