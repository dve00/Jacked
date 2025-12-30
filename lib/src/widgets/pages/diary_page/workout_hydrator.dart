import 'package:jacked/src/db/models/exercise_entry.dart';
import 'package:jacked/src/db/models/exercise_set.dart';
import 'package:jacked/src/db/models/workout.dart';
import 'package:jacked/src/db/services/exercise_entry_service.dart';
import 'package:jacked/src/db/services/exercise_service.dart';
import 'package:jacked/src/db/services/exercise_set_service.dart';

class WorkoutHydrator {
  ExerciseService exerciseSvc;
  ExerciseSetService exerciseSetSvc;
  ExerciseEntryService exerciseEntrySvc;
  WorkoutHydrator({
    required this.exerciseSvc,
    required this.exerciseSetSvc,
    required this.exerciseEntrySvc,
  });

  Future<List<ExerciseSet>?> _loadSets(
    ExerciseSetService exerciseSetSvc,
    int? exerciseEntryId,
  ) async {
    if (exerciseEntryId == null) return null;
    return exerciseSetSvc.listByExerciseEntryId(exerciseEntryId);
  }

  Future<ExerciseEntry> _hydrateExerciseEntry({
    required ExerciseEntry entry,
    required DateTime workoutStartTime,
  }) async {
    final exercise = await exerciseSvc.get(entry.exerciseId);

    final previousEntry = await exerciseEntrySvc.getMostRecentExerciseEntry(
      exerciseId: entry.exerciseId,
      startTime: workoutStartTime,
    );

    final sets = await _loadSets(
      exerciseSetSvc,
      entry.id,
    );

    final previousSets = await _loadSets(
      exerciseSetSvc,
      previousEntry?.id,
    );

    return entry.copyWith(
      exercise: exercise,
      sets: sets,
      previousSets: previousSets,
    );
  }

  Future<List<ExerciseEntry>> _hydrateExerciseEntries({
    required List<ExerciseEntry> entries,
    required DateTime workoutStartTime,
  }) async {
    return Future.wait(
      entries.map(
        (entry) => _hydrateExerciseEntry(
          entry: entry,
          workoutStartTime: workoutStartTime,
        ),
      ),
    );
  }

  Future<Workout?> hydrateWorkout(
    Workout workout,
  ) async {
    final workoutId = workout.id;
    if (workoutId == null) return null;

    final entries = await exerciseEntrySvc.listByWorkoutId(workoutId);

    final hydratedEntries = await _hydrateExerciseEntries(
      entries: entries,
      workoutStartTime: workout.startTime,
    );

    return workout.copyWith(exerciseEntries: hydratedEntries);
  }
}
