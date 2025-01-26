import 'package:flutter/material.dart';

class MinimizedActiveWorkout extends StatelessWidget {
  const MinimizedActiveWorkout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
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
                style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
              ),
            )
          ],
        ),
      ),
    );
  }
}
