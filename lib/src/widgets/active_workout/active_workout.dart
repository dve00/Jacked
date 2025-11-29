import 'package:flutter/material.dart';
import 'package:jacked/src/db/services/exercise_entry_service.dart';
import 'package:jacked/src/db/services/exercise_service.dart';
import 'package:jacked/src/db/services/workout_service.dart';
import 'package:jacked/src/widgets/active_workout/active_workout_body.dart';
import 'package:jacked/src/widgets/shared/widgets/draggable_header_sheet.dart';

class ActiveWorkout extends StatefulWidget {
  final ExerciseService exerciseSvc;
  final WorkoutService workoutSvc;
  final ExerciseEntryService exerciseEntryService;
  final double sheetMinSnap;
  final double sheetMaxSnap;
  final DraggableScrollableController controller;
  final VoidCallback onCancelWorkout;
  final VoidCallback onSaveWorkout;

  const ActiveWorkout({
    super.key,
    required this.exerciseSvc,
    required this.workoutSvc,
    required this.exerciseEntryService,
    required this.sheetMinSnap,
    required this.sheetMaxSnap,
    required this.controller,
    required this.onCancelWorkout,
    required this.onSaveWorkout,
  });

  @override
  State<StatefulWidget> createState() => _ActiveWorkoutState();
}

class _ActiveWorkoutState extends State<ActiveWorkout> {
  double _minChildSize = 0;

  Future<void> closeSheet() async {
    setState(() {
      _minChildSize = 0;
    });
    // allow the widget to rebuild before animating to 0
    await Future.delayed(const Duration(milliseconds: 5));
    widget.controller.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void initState() {
    super.initState();
    _minChildSize = widget.sheetMinSnap;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.animateTo(
        widget.sheetMaxSnap,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: widget.controller,
      initialChildSize: _minChildSize,
      minChildSize: _minChildSize,
      maxChildSize: widget.sheetMaxSnap,
      snapAnimationDuration: const Duration(milliseconds: 200),
      snap: true,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: DraggableHeaderSheet(
            scrollController: scrollController,
            headerBody: const MinimizedWorkoutHeader(),
            body: ActiveWorkoutBody(
              exerciseSvc: widget.exerciseSvc,
              workoutSvc: widget.workoutSvc,
              exerciseEntrySvc: widget.exerciseEntryService,
              onCancelWorkout: () async {
                await closeSheet();
                widget.onCancelWorkout();
              },
              onSaveWorkout: () async {
                await closeSheet();
                widget.onSaveWorkout();
              },
            ),
          ),
        );
      },
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
