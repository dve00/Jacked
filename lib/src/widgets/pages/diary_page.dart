import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jacked/src/db/models/exercise_entry.dart';
import 'package:jacked/src/db/models/workout.dart';
import 'package:jacked/src/db/seeds.dart';
import 'package:jacked/src/db/services/exercise_entry_service.dart';
import 'package:jacked/src/db/services/exercise_service.dart';
import 'package:jacked/src/db/services/exercise_set_service.dart';
import 'package:jacked/src/db/services/workout_service.dart';
import 'package:jacked/src/widgets/shared/build_context.dart';

class DiaryPage extends StatelessWidget {
  final WorkoutService workoutSvc;
  final ExerciseService exerciseSvc;
  final ExerciseEntryService exerciseEntrySvc;
  final ExerciseSetService exerciseSetSvc;

  const DiaryPage({
    super.key,
    required this.exerciseSvc,
    required this.exerciseEntrySvc,
    required this.exerciseSetSvc,
    required this.workoutSvc,
  });

  Future<List<Workout>> listWorkoutsFuture() async {
    return workoutSvc.list();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: listWorkoutsFuture(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center();
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final workouts = snapshot.requireData;
        return ListView.builder(
          cacheExtent: 100 * MediaQuery.of(context).size.height,
          itemBuilder: (context, index) {
            final workout = workouts[index];
            return DiaryEntry(
              workout: workout,
              exerciseEntrySvc: exerciseEntrySvc,
              exerciseSetSvc: exerciseSetSvc,
              exerciseSvc: exerciseSvc,
            );
          },
          itemCount: workouts.length,
        );
      },
    );
  }
}

Future<List<ExerciseEntry>> loadExerciseEntries(
  int? workoutId,
  ExerciseEntryService exerciseEntrySvc,
  ExerciseService exerciseSvc,
  ExerciseSetService exerciseSetSvc,
) async {
  if (workoutId == null) return [];
  final exerciseEntries = await exerciseEntrySvc.listByWorkoutId(workoutId);
  for (int i = 0; i < exerciseEntries.length; i++) {
    final exercise = await exerciseSvc.get(exerciseEntries[i].exerciseId);
    exerciseEntries[i] = exerciseEntries[i].copyWith(exercise: exercise);
    final exerciseEntryId = exerciseEntries[i].id;
    if (exerciseEntryId != null) {
      final sets = await exerciseSetSvc.listByExerciseEntryId(
        exerciseEntryId,
      );
      exerciseEntries[i] = exerciseEntries[i].copyWith(sets: sets);
    }
  }
  return exerciseEntries;
}

class DiaryEntry extends StatelessWidget {
  final ExerciseService exerciseSvc;
  final ExerciseEntryService exerciseEntrySvc;
  final ExerciseSetService exerciseSetSvc;
  final Workout workout;

  const DiaryEntry({
    super.key,
    required this.exerciseSvc,
    required this.exerciseEntrySvc,
    required this.exerciseSetSvc,
    required this.workout,
  });

  Future<List<ExerciseEntry>> loadExerciseEntriesFuture() async {
    return loadExerciseEntries(
      workout.id,
      exerciseEntrySvc,
      exerciseSvc,
      exerciseSetSvc,
    );
  }

  @override
  Widget build(BuildContext context) {
    final duration = workout.endTime?.difference(workout.startTime);

    return FutureBuilder(
      future: loadExerciseEntriesFuture(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center();
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final exerciseEntries = snapshot.requireData;
        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              constraints: const BoxConstraints(
                maxWidth: double.infinity,
              ),
              builder: (context) {
                return DiaryEntryDetails(
                  workout: workout,
                );
              },
            );
          },
          child: Card.outlined(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.title,
                    style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (workout.description != null)
                    Text(
                      workout.description!,
                      style: context.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                    ),
                  Text(DateFormat('EEEE, d. MMMM').format(workout.startTime)),
                  if (duration != null) Text('${duration.inHours}h ${duration.inMinutes}m'),
                  ...exerciseEntries.where((entry) => entry.exercise != null).map(
                    (entry) {
                      final translation = context.l10n.exerciseTranslation(entry.exercise!.key);
                      final sets = entry.sets;
                      return Row(
                        children: [
                          Text(translation.name),
                          if (sets != null && sets.isNotEmpty)
                            Text(' ${sets[0].weight}kg x ${sets[0].reps}'),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class DiaryEntryDetails extends StatelessWidget {
  final Workout workout;
  const DiaryEntryDetails({
    super.key,
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: const BoxConstraints(minWidth: double.infinity),
        child: Column(
          children: [Text(workout.title)],
        ),
      ),
    );
  }
}
