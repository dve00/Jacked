import 'package:jacked/src/db/models/exercise_entry.dart';
import 'package:jacked/src/db/models/workout.dart';
import 'package:jacked/src/db/repositories/exercise_entry_repository.dart';
import 'package:jacked/src/db/repositories/exercise_repository.dart';
import 'package:jacked/src/db/repositories/exercise_set_repository.dart';

class WorkoutHydrator {
  final Workout workout;
  final ExerciseEntryRepository exerciseEntryRepo;
  final ExerciseRepository exerciseRepo;
  final ExerciseSetRepository exerciseSetRepo;

  WorkoutHydrator({
    required this.workout,
    required this.exerciseEntryRepo,
    required this.exerciseRepo,
    required this.exerciseSetRepo,
  });

  Future<ExerciseEntry> _hydrateExerciseEntry(ExerciseEntry exerciseEntry) async {
    final exerciseId = exerciseEntry.exerciseId;
    final exercise = await exerciseRepo.get(exerciseId);
    exerciseEntry = exerciseEntry.copyWith(exercise: exercise);

    final sets = await exerciseSetRepo.listByExerciseEntryId(
      exerciseEntry.id,
    );
    exerciseEntry = exerciseEntry.copyWith(sets: sets);

    final previousEntry = await exerciseEntryRepo.getMostRecentExerciseEntry(
      exerciseId: exerciseId,
      startTime: workout.startTime,
    );
    if (previousEntry == null) return exerciseEntry;
    final previousSets = await exerciseSetRepo.listByExerciseEntryId(
      previousEntry.id,
    );
    return exerciseEntry.copyWith(previousSets: previousSets);
  }

  Future<List<ExerciseEntry>> _hydrateExerciseEntries(List<ExerciseEntry> exerciseEntries) async {
    var res = <ExerciseEntry>[];
    for (final entry in exerciseEntries) {
      final hydratedExerciseEntry = await _hydrateExerciseEntry(entry);
      res.add(hydratedExerciseEntry);
    }
    return res;
  }

  Future<Workout?> hydrateWorkout() async {
    final exerciseEntries = await exerciseEntryRepo.listByWorkoutId(workout.id);
    final hydratedExerciseEntries = await _hydrateExerciseEntries(exerciseEntries);
    return workout.copyWith(exerciseEntries: hydratedExerciseEntries);
  }
}
