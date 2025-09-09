import 'package:flutter/material.dart';
import 'package:jacked/src/db/models/exercise.dart';
import 'package:jacked/src/widgets/shared/build_context.dart';
import 'package:jacked/src/widgets/shared/exercise_list.dart';

class ActiveWorkout extends StatefulWidget {
  const ActiveWorkout({
    super.key,
    required this.sheetMinSnap,
    required this.sheetMaxSnap,
    required this.controller,
    required this.onCancelWorkout,
  });

  final double sheetMinSnap;
  final double sheetMaxSnap;
  final DraggableScrollableController controller;
  final VoidCallback onCancelWorkout;

  @override
  State<StatefulWidget> createState() => _ActiveWorkoutState();
}

class _ActiveWorkoutState extends State<ActiveWorkout> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.animateTo(
        widget.sheetMaxSnap,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: widget.controller,
      initialChildSize: widget.sheetMinSnap,
      minChildSize: widget.sheetMinSnap,
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (_, i) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Title'),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Text(context.l10n.active_workout_addExercise),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  widget.controller.animateTo(
                                    0,
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeOut,
                                  );
                                  widget.onCancelWorkout();
                                },
                                child: Text(context.l10n.active_workout_cancelWorkout),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
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
  final VoidCallback onClose;
  final void Function(Exercise?) onSelectedExercise;

  const AddExerciseCard({super.key, required this.onSelectedExercise, required this.onClose});

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
          Expanded(child: ExerciseList(onSelectedExercise: onSelectedExercise)),
        ],
      ),
    );
  }
}
