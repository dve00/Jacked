import 'package:flutter/material.dart';
import 'package:jacked/src/widgets/shared/build_context.dart';

class DiaryPage extends StatelessWidget {
  const DiaryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.svc.workoutService.list(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center();
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final workouts = snapshot.requireData;
        return ListView.builder(
          itemBuilder: (context, index) {
            final workout = workouts[index];
            return Card.outlined(
              child: Text(workout.title),
            );
          },
          itemCount: workouts.length,
        );
      },
    );
  }
}
