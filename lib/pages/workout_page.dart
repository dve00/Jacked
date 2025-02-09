import 'package:flutter/material.dart';
import 'package:jacked/database/models.dart';
import 'package:jacked/jacked_home_page.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({
    super.key,
  });

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  var showStartWorkoutCard = false;

  void setShowStartWorkout(bool value) {
    setState(() {
      showStartWorkoutCard = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayStyle = theme.textTheme.displaySmall;
    final headlineStyle = theme.textTheme.headlineMedium;
    final workoutState = ActiveWorkoutDisplayState.of(context);

    return Stack(children: [
      Scaffold(
          appBar: AppBar(
            title: const Text('Workout'),
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
                          title: const Text('Workout Page'),
                          content: const Text('Display help here!'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'))
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
                        Text('Program', style: headlineStyle),
                        const Text(
                            'Next workout and history of the running program live here!')
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Templates', style: headlineStyle),
                        const Text('Previews for templates live here!')
                      ],
                    ),
                  ),
                ],
              ),
            ]),
            if (showStartWorkoutCard)
              Column(
                children: [
                  Spacer(),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Start workout',
                                    style: theme.textTheme.headlineMedium,
                                  ),
                                  Spacer(),
                                  IconButton(
                                    onPressed: () => setShowStartWorkout(false),
                                    icon: Icon(
                                      Icons.close_outlined,
                                    ),
                                  )
                                ],
                              ),
                              Text('Choose what kind of workout to start.'),
                              Container(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Your Program',
                                      style: theme.textTheme.headlineSmall,
                                    ),
                                    Text(
                                        'Preview to next program workout lives here!')
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Your Templates',
                                      style: theme.textTheme.headlineSmall,
                                    ),
                                    Text('Preview for templates live here!')
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Quick Workout',
                                      style: theme.textTheme.headlineSmall,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: FloatingActionButton.extended(
                                          elevation: 2,
                                          onPressed: () {
                                            workoutState
                                                .setHasActiveWorkout(true);
                                            workoutState
                                                .setIsWorkoutFocused(true);
                                            setState(() {
                                              showStartWorkoutCard = false;
                                            });
                                          },
                                          label: Text(
                                            'Start empty workout',
                                            style: theme.textTheme.labelLarge,
                                          ),
                                          icon: Icon(Icons.add),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
          ]),
          floatingActionButton: (!workoutState.hasActiveWorkout &&
                  !showStartWorkoutCard)
              ? FloatingActionButton(
                  onPressed: () {
                    setShowStartWorkout(true);
                    ActiveWorkoutData.of(context).updateActiveWorkout(Workout(
                        title: 'New Workout', startTime: DateTime.now()));
                  },
                  child: const Icon(Icons.add),
                )
              : null),
    ]);
  }
}
