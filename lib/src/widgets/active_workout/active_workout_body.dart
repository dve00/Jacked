import 'package:flutter/material.dart';
import 'package:jacked/src/widgets/shared/build_context.dart';
import 'package:jacked/src/widgets/shared/widgets/jacked_button.dart';

class ActiveWorkoutBody extends StatelessWidget {
  const ActiveWorkoutBody({
    super.key,
    required this.onCancelWorkout,
  });

  final VoidCallback onCancelWorkout;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (_, i) {
            if (i == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Title'),
                  JackedButton(
                    label: context.l10n.active_workout_addExercise,
                    onPressed: () => {},
                  ),
                  JackedButton(
                    label: context.l10n.active_workout_cancelWorkout,
                    onPressed: onCancelWorkout,
                  ),
                ],
              );
            }
            return null;
          },
        ),
      ),
    );
  }
}
