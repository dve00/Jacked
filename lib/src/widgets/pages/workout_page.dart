import 'package:flutter/material.dart';
import 'package:jacked/src/widgets/shared/build_context.dart';
import 'package:jacked/src/widgets/shared/widgets/jacked_button.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key, required this.onStartWorkout});

  final VoidCallback onStartWorkout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headlineStyle = theme.textTheme.headlineMedium;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JackedButton(
              label: context.l10n.pages_workout_startEmptyWorkout,
              onPressed: onStartWorkout,
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
    );
  }
}
