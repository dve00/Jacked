import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jacked/src/db/models/workout.dart';
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
            return DiaryEntry(workout: workout);
          },
          itemCount: workouts.length,
        );
      },
    );
  }
}

class DiaryEntry extends StatelessWidget {
  const DiaryEntry({
    super.key,
    required this.workout,
  });

  final Workout workout;

  @override
  Widget build(BuildContext context) {
    final duration = workout.endTime?.difference(workout.startTime);

    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              workout.title,
              style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(DateFormat('EEEE, d. MMMM').format(workout.startTime)),
            if (duration != null) Text('${duration.inHours}h ${duration.inMinutes}m'),
          ],
        ),
      ),
    );
  }
}
