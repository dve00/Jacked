import 'package:flutter/material.dart';
import 'package:jacked/jacked_home_page.dart';

class ActiveWorkout extends StatelessWidget {
  const ActiveWorkout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final workoutState = WorkoutState.of(context);

    return Card(
        elevation: 10,
        color: theme.colorScheme.secondaryContainer,
        shadowColor: Theme.of(context).colorScheme.shadow,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Workout Title',
                    style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer),
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () => workoutState.setWorkoutFocused(false),
                  icon: Icon(
                    Icons.close_outlined,
                  ),
                )
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  workoutState.setActiveWorkout(false);
                  workoutState.setWorkoutFocused(false);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withAlpha(150)),
                child: Text(
                  'Cancel Wor kout',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.onSecondary),
                )),
          ],
        ));
  }
}
