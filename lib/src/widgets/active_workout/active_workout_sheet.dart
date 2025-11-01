import 'package:flutter/material.dart';
import 'package:jacked/src/db/models/exercise.dart';
import 'package:jacked/src/db/services/exercise_service.dart';
import 'package:jacked/src/widgets/active_workout/active_workout_body.dart';
import 'package:jacked/src/widgets/shared/exercise_list.dart';

class ActiveWorkoutSheet extends StatefulWidget {
  final ExerciseService exerciseSvc;
  final double sheetMinSnap;
  final double sheetMaxSnap;
  final DraggableScrollableController controller;
  final VoidCallback onCancelWorkout;

  const ActiveWorkoutSheet({
    super.key,
    required this.exerciseSvc,
    required this.sheetMinSnap,
    required this.sheetMaxSnap,
    required this.controller,
    required this.onCancelWorkout,
  });

  @override
  State<StatefulWidget> createState() => _ActiveWorkoutSheetState();
}

class _ActiveWorkoutSheetState extends State<ActiveWorkoutSheet> {
  double _minChildSize = 0;

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
      initialChildSize: widget.sheetMinSnap,
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
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            controller: scrollController,
            child: Column(
              children: [
                const DraggableHeader(),
                ActiveWorkoutBody(
                  onCancelWorkout: () async {
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
                    widget.onCancelWorkout();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DraggableHeader extends StatelessWidget {
  const DraggableHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const MinimizedWorkoutHeader(),
            ],
          ),
        ],
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

class AddExerciseCard extends StatelessWidget {
  final ExerciseService exerciseSvc;
  final VoidCallback onClose;
  final void Function(Exercise?) onSelectedExercise;

  const AddExerciseCard({
    super.key,
    required this.exerciseSvc,
    required this.onSelectedExercise,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Select Exercise', style: Theme.of(context).textTheme.displaySmall),
                const Spacer(),
                IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
              ],
            ),
          ),
          Expanded(
            child: ExerciseList(exercisesSvc: exerciseSvc, onSelectedExercise: onSelectedExercise),
          ),
        ],
      ),
    );
  }
}
