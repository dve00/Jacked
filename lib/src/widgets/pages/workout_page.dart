import 'package:flutter/material.dart';
import 'package:jacked/src/widgets/shared/build_context.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key, required this.onStartWorkout});

  final VoidCallback onStartWorkout;

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

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.pages_workout_workout),
            titleTextStyle: displayStyle,
            centerTitle: false,
            shadowColor: Theme.of(context).colorScheme.shadow,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.help_outline_outlined,
                ),
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(context.l10n.pages_workout_workoutPage),
                    content: Text(context.l10n.pages_workout_helpBody),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            widget.onStartWorkout();
                          },
                          child: Text(context.l10n.pages_workout_startEmptyWorkout),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(context.l10n.pages_workout_program, style: headlineStyle),
                            const Text(
                              'Next workout and history of the running program live here!',
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(context.l10n.pages_workout_templates, style: headlineStyle),
                            const Text('Previews for templates live here!'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
