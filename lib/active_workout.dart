import 'package:flutter/material.dart';
import 'package:jacked/jacked_home_page.dart';

class ActiveWorkout extends StatefulWidget {
  const ActiveWorkout({
    super.key,
  });

  @override
  State<ActiveWorkout> createState() => _ActiveWorkoutState();
}

class _ActiveWorkoutState extends State<ActiveWorkout> {
  bool isEditing = false;
  String title = 'New workout';
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: title);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                  child: isEditing
                      ? LayoutBuilder(
                          builder: (context, constraints) {
                            return IntrinsicWidth(
                              child: TextField(
                                controller: _controller,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.all(4.0)),
                                onChanged: (value) => setState(() {
                                  title = value;
                                }),
                                style: theme.textTheme.displaySmall,
                              ),
                            );
                          },
                        )
                      : GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              title,
                              style: theme.textTheme.displaySmall,
                            ),
                          ),
                          onTap: () => setState(() {
                            isEditing = true;
                          }),
                        ),
                ),
                if (isEditing)
                  IconButton(
                    onPressed: () => setState(() {
                      setState(() {
                        isEditing = false;
                      });
                    }),
                    icon: Icon(
                      Icons.done_outlined,
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
                    backgroundColor: theme.colorScheme.primary),
                child: Text(
                  'Add Exercise',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.onSecondary),
                )),
            ElevatedButton(
                onPressed: () {
                  workoutState.setActiveWorkout(false);
                  workoutState.setWorkoutFocused(false);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withAlpha(150)),
                child: Text(
                  'Cancel Workout',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.onSecondary),
                )),
          ],
        ));
  }
}
