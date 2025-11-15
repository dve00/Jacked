import 'package:flutter/material.dart';
import 'package:jacked/src/db/models/exercise_entry.dart';
import 'package:jacked/src/db/models/workout.dart';
import 'package:jacked/src/db/seeds.dart';
import 'package:jacked/src/db/services/exercise_service.dart';
import 'package:jacked/src/widgets/shared/build_context.dart';
import 'package:jacked/src/widgets/shared/exercise_list.dart';
import 'package:jacked/src/widgets/shared/widgets/jacked_button.dart';

class ActiveWorkoutBody extends StatefulWidget {
  const ActiveWorkoutBody({
    super.key,
    required this.exerciseSvc,
    required this.onCancelWorkout,
    required this.onSaveWorkout,
  });

  final ExerciseService exerciseSvc;
  final VoidCallback onCancelWorkout;
  final VoidCallback onSaveWorkout;

  @override
  State<ActiveWorkoutBody> createState() => _ActiveWorkoutBodyState();
}

class _ActiveWorkoutBodyState extends State<ActiveWorkoutBody> {
  Workout workout = Workout(title: '', startTime: DateTime.now());

  @override
  Widget build(BuildContext context) {
    List<ExerciseEntry>? exerciseEntries = workout.exerciseEntries;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: exerciseEntries == null ? 1 : exerciseEntries.length + 1,
          itemBuilder: (_, i) {
            if (i == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text('New Workout'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: JackedButton(
                      label: context.l10n.active_workout_addExercise,
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: ExerciseList(
                            exercisesSvc: widget.exerciseSvc,
                            onSelectedExercise: (exercise) {
                              int? exerciseId = exercise.id;
                              if (exerciseId == null) return;
                              List<ExerciseEntry> entries = <ExerciseEntry>[];
                              if (exerciseEntries != null) entries = exerciseEntries;
                              entries.add(
                                ExerciseEntry(
                                  workoutId: -1,
                                  exerciseId: exerciseId,
                                  exercise: exercise,
                                ),
                              );
                              setState(() {
                                workout = workout.copyWith(exerciseEntries: entries);
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: JackedButton(
                      label: context.l10n.active_workout_cancelWorkout,
                      onPressed: widget.onCancelWorkout,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: JackedButton(
                      label: context.l10n.active_workout_saveWorkout,
                      onPressed: () {
                        widget.onSaveWorkout();
                      },
                    ),
                  ),
                ],
              );
            }
            if (exerciseEntries == null) return null;
            return ExerciseForm(exerciseEntry: exerciseEntries[i - 1]);
          },
        ),
      ),
    );
  }
}

class ExerciseForm extends StatefulWidget {
  const ExerciseForm({
    super.key,
    required this.exerciseEntry,
  });

  final ExerciseEntry exerciseEntry;

  @override
  State<ExerciseForm> createState() => _ExerciseFormState();
}

class _ExerciseFormState extends State<ExerciseForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var exercise = widget.exerciseEntry.exercise;
    if (exercise == null) return const SizedBox.shrink();
    var translation = context.l10n.exerciseTranslation(exercise.key);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(translation.name),
          TextFormField(
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ],
      ),
    );
  }
}
