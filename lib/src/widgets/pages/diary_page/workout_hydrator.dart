import 'package:jacked/src/db/models/exercise_entry.dart';
import 'package:jacked/src/db/models/workout.dart';
import 'package:jacked/src/db/services/exercise_entry_service.dart';
import 'package:jacked/src/db/services/exercise_service.dart';
import 'package:jacked/src/db/services/exercise_set_service.dart';

class WorkoutHydrator {
  final Workout workout;
  final ExerciseEntryService exerciseEntrySvc;
  final ExerciseService exerciseSvc;
  final ExerciseSetService exerciseSetSvc;

  WorkoutHydrator({
    required this.workout,
    required this.exerciseEntrySvc,
    required this.exerciseSvc,
    required this.exerciseSetSvc,
  });

  Future<ExerciseEntry> _hydrateExerciseEntry(ExerciseEntry exerciseEntry) async {
    final exerciseId = exerciseEntry.exerciseId;
    final exercise = await exerciseSvc.get(exerciseId);
    exerciseEntry = exerciseEntry.copyWith(exercise: exercise);

    final sets = await exerciseSetSvc.listByExerciseEntryId(
      exerciseEntry.id,
    );
    exerciseEntry = exerciseEntry.copyWith(sets: sets);

    final previousEntry = await exerciseEntrySvc.getMostRecentExerciseEntry(
      exerciseId: exerciseId,
      startTime: workout.startTime,
    );
    if (previousEntry == null) return exerciseEntry;
    final previousSets = await exerciseSetSvc.listByExerciseEntryId(
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
    final exerciseEntries = await exerciseEntrySvc.listByWorkoutId(workout.id);
    final hydratedExerciseEntries = await _hydrateExerciseEntries(exerciseEntries);
    return workout.copyWith(exerciseEntries: hydratedExerciseEntries);
  }
}
