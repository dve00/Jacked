import 'package:flutter/material.dart';
import 'package:jacked/src/db/models/exercise.dart';
import 'package:jacked/src/db/models/exercise_entry.dart';
import 'package:jacked/src/db/models/workout.dart';
import 'package:jacked/src/db/seeds.dart';
import 'package:jacked/src/db/services/exercise_entry_service.dart';
import 'package:jacked/src/db/services/exercise_service.dart';
import 'package:jacked/src/db/services/workout_service.dart';
import 'package:jacked/src/widgets/shared/build_context.dart';
import 'package:jacked/src/widgets/shared/widgets/exercise_list.dart';
import 'package:jacked/src/widgets/shared/widgets/jacked_button.dart';

class ActiveWorkoutBody extends StatefulWidget {
  const ActiveWorkoutBody({
    super.key,
    required this.exerciseSvc,
    required this.workoutSvc,
    required this.exerciseEntrySvc,
    required this.onCancelWorkout,
    required this.onSaveWorkout,
  });

  final ExerciseService exerciseSvc;
  final WorkoutService workoutSvc;
  final ExerciseEntryService exerciseEntrySvc;
  final VoidCallback onCancelWorkout;
  final VoidCallback onSaveWorkout;

  @override
  State<ActiveWorkoutBody> createState() => _ActiveWorkoutBodyState();
}

Future<bool> saveWorkout(
  WorkoutService workoutSvc,
  ExerciseEntryService exerciseEntrySvc,
  List<ExerciseFormData> formData,
) async {
  final workout = Workout(
    title: 'Saved Workout',
    startTime: DateTime.now(),
    endTime: DateTime.now(),
  );
  final workoutId = await workoutSvc.create(workout);
  for (var data in formData) {
    final exerciseId = data.exercise.id;
    if (exerciseId == null) return false;
    await exerciseEntrySvc.create(
      ExerciseEntry(
        workoutId: workoutId,
        exerciseId: exerciseId,
      ),
    );
  }
  return true;
}

class _ActiveWorkoutBodyState extends State<ActiveWorkoutBody> {
  final List<ExerciseFormData> formData = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: formData.length + 1,
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
                              setState(() {
                                formData.add(
                                  ExerciseFormData(key: GlobalKey<FormState>(), exercise: exercise),
                                );
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
                      onPressed: () async {
                        if (!await saveWorkout(
                          widget.workoutSvc,
                          widget.exerciseEntrySvc,
                          formData,
                        )) {
                          if (context.mounted) {
                            return showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(context.l10n.active_workout_savingWorkoutFailed),
                                  content: Text(
                                    context.l10n.active_workout_savingWorkoutFailedContent,
                                  ),
                                  actions: [
                                    JackedButton(
                                      label: context.l10n.labels_ok,
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                        widget.onSaveWorkout();
                      },
                    ),
                  ),
                ],
              );
            }
            return ExerciseForm(formData: formData[i - 1]);
          },
        ),
      ),
    );
  }
}

class ExerciseFormData {
  final GlobalKey<FormState> key;
  final Exercise exercise;

  const ExerciseFormData({
    required this.key,
    required this.exercise,
  });
}

class ExerciseForm extends StatefulWidget {
  final ExerciseFormData formData;

  const ExerciseForm({
    super.key,
    required this.formData,
  });

  @override
  State<ExerciseForm> createState() => _ExerciseFormState();
}

class _ExerciseFormState extends State<ExerciseForm> {
  @override
  Widget build(BuildContext context) {
    final formData = widget.formData;
    var translation = context.l10n.exerciseTranslationsByKey[formData.exercise.key];
    if (translation == null) {
      throw UnknownExerciseKeyException(formData.exercise.key);
    }
    return Form(
      key: formData.key,
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
