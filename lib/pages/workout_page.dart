import 'package:flutter/material.dart';
import 'package:jacked/main.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({
    super.key,
  });

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayStyle = theme.textTheme.displaySmall;
    final headlineStyle = theme.textTheme.headlineMedium;
    final workoutState = WorkoutState.of(context);

    return Stack(children: [
      Scaffold(
          appBar: AppBar(
            title: const Text("Workout"),
            titleTextStyle: displayStyle,
            centerTitle: false,
            shadowColor: Theme.of(context).colorScheme.shadow,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.help_outline_outlined,
                ),
                onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text("Workout Page"),
                          content: const Text("Display help here!"),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context, "OK"),
                                child: const Text("OK"))
                          ],
                        )),
              ),
            ],
          ),
          body: Stack(children: [
            ListView(padding: EdgeInsets.all(16), children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Program", style: headlineStyle),
                        const Text(
                            "Next workout and history of the running program live here")
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Templates", style: headlineStyle),
                        const Text("Previews for templates live here")
                      ],
                    ),
                  ),
                ],
              ),
            ]),
            if (workoutState.activeWorkout)
              if (!workoutState.workoutFocused)
                Column(
                  children: [
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: GestureDetector(
                          onTap: () => workoutState.toggleWorkoutFocused(),
                          child: Card(
                            color: theme.colorScheme.primaryContainer,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Workout Title"),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("n/m exercises"),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "47:25",
                                      style: TextStyle(
                                          color: theme
                                              .colorScheme.onPrimaryContainer),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
          ]),
          floatingActionButton: !workoutState.activeWorkout
              ? FloatingActionButton(
                  onPressed: () {
                    workoutState.toggleActiveWorkout();
                    workoutState.toggleWorkoutFocused();
                  },
                  child: const Icon(Icons.add),
                )
              : null),
    ]);
  }
}
