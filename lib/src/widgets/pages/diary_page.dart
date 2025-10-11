import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jacked/src/db/models/exercise_entry.dart';
import 'package:jacked/src/db/models/workout.dart';
import 'package:jacked/src/db/seeds.dart';
import 'package:jacked/src/widgets/shared/build_context.dart';

class DiaryPage extends StatelessWidget {
  const DiaryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.svc.workoutService.list(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center();
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final workouts = snapshot.requireData;
        return ListView.builder(
          itemBuilder: (context, index) {
            final workout = workouts[index];
            return DiaryEntry(workout: workout);
          },
          itemCount: workouts.length,
        );
      },
    );
  }
}

class DiaryEntry extends StatelessWidget {
  const DiaryEntry({
    super.key,
    required this.workout,
  });

  final Workout workout;

  Future<List<ExerciseEntry>> loadExerciseEntries(BuildContext context) async {
    final workoutId = workout.id;
    if (workoutId == null) return [];
    final exerciseEntries = await context.svc.exerciseEntryService.listByWorkoutId(workoutId);
    for (int i = 0; i < exerciseEntries.length; i++) {
      if (!context.mounted) return [];
      final exercise = await context.svc.exerciseService.get(exerciseEntries[i].exerciseId);
      exerciseEntries[i] = exerciseEntries[i].copyWith(exercise: exercise);
      final exerciseEntryId = exerciseEntries[i].id;
      if (exerciseEntryId != null) {
        if (!context.mounted) return [];
        final sets = await context.svc.exerciseSetService.listByExerciseEntryId(
          exerciseEntryId,
        );
        exerciseEntries[i] = exerciseEntries[i].copyWith(sets: sets);
      }
    }
    return exerciseEntries;
  }

  @override
  Widget build(BuildContext context) {
    final duration = workout.endTime?.difference(workout.startTime);

    return FutureBuilder(
      future: loadExerciseEntries(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center();
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final exerciseEntries = snapshot.requireData;
        return Card.outlined(
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
                        // TODO: Display the best set
                        if (sets != null && sets.isNotEmpty)
                          Text(' ${sets[0].weight}kg x ${sets[0].reps}'),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
