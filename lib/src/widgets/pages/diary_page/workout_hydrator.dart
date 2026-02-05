import 'package:jacked/src/db/models/exercise_entry.dart';
import 'package:jacked/src/db/models/workout.dart';
import 'package:jacked/src/db/repositories/repositories.dart';

class WorkoutHydrator {
  final Repositories repos;
  final Workout workout;

  WorkoutHydrator({
    required this.repos,
    required this.workout,
  });

  Future<ExerciseEntry> _hydrateExerciseEntry(ExerciseEntry exerciseEntry) async {
    final exerciseId = exerciseEntry.exerciseId;
    final exercise = await repos.exerciseRepo.get(exerciseId);
    exerciseEntry = exerciseEntry.copyWith(exercise: exercise);

    final sets = await repos.exerciseSetRepo.listByExerciseEntryId(
      exerciseEntry.id,
    );
    exerciseEntry = exerciseEntry.copyWith(sets: sets);

    final previousEntry = await repos.exerciseEntryRepo.getMostRecentExerciseEntry(
      exerciseId: exerciseId,
      startTime: workout.startTime,
    );
    if (previousEntry == null) return exerciseEntry;
    final previousSets = await repos.exerciseSetRepo.listByExerciseEntryId(
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
    final exerciseEntries = await repos.exerciseEntryRepo.listByWorkoutId(workout.id);
    final hydratedExerciseEntries = await _hydrateExerciseEntries(exerciseEntries);
    return workout.copyWith(exerciseEntries: hydratedExerciseEntries);
  }
}
