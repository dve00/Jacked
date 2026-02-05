import 'package:flutter/material.dart';
import 'package:jacked/src/db/repositories/exercise_entry_repository.dart';
import 'package:jacked/src/db/repositories/exercise_repository.dart';
import 'package:jacked/src/db/repositories/workout_repository.dart';
import 'package:jacked/src/widgets/active_workout/active_workout_body.dart';
import 'package:jacked/src/widgets/shared/widgets/draggable_header_sheet.dart';

class ActiveWorkout extends StatelessWidget {
  final DraggableScrollableController controller;
  final double sheetMinSnap;
  final double sheetMaxSnap;
  final ExerciseRepository exerciseRepo;
  final WorkoutRepository workoutRepo;
  final ExerciseEntryRepository exerciseEntryService;
  final VoidCallback onCancelWorkout;
  final VoidCallback onSaveWorkout;

  final sheetKey = GlobalKey<DraggableHeaderSheetState>();

  ActiveWorkout({
    super.key,
    required this.controller,
    required this.sheetMinSnap,
    required this.sheetMaxSnap,
    required this.exerciseRepo,
    required this.workoutRepo,
    required this.exerciseEntryService,
    required this.onCancelWorkout,
    required this.onSaveWorkout,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableHeaderSheet(
      key: sheetKey,
      controller: controller,
      sheetMinSnap: sheetMinSnap,
      sheetMaxSnap: sheetMaxSnap,
      headerBody: const MinimizedWorkoutHeader(),
      body: ActiveWorkoutBody(
        exerciseRepo: exerciseRepo,
        workoutRepo: workoutRepo,
        exerciseEntryRepo: exerciseEntryService,
        onCancelWorkout: () async {
          await sheetKey.currentState?.closeSheet();
          onCancelWorkout();
        },
        onSaveWorkout: () async {
          await sheetKey.currentState?.closeSheet();
          onSaveWorkout();
        },
      ),
    );
  }
}

class MinimizedWorkoutHeader extends StatelessWidget {
  const MinimizedWorkoutHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 4),
        Text("Let's put a header here"),
        SizedBox(height: 2),
        Text('05:34'),
      ],
    );
  }
}
