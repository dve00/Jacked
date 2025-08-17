import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jacked/src/db/models/exercise.dart';
import 'package:jacked/src/db/models/exercise_entry.dart';
import 'package:jacked/src/db/models/exercise_set.dart';
import 'package:jacked/src/db/models/workout.dart';
import 'package:jacked/src/widgets/jacked_home_page.dart';
import 'package:jacked/src/widgets/pages/exercises_page.dart';

class ActiveWorkout extends StatefulWidget {
  const ActiveWorkout({
    super.key,
  });

  @override
  State<ActiveWorkout> createState() => _ActiveWorkoutState();
}

class _ActiveWorkoutState extends State<ActiveWorkout> {
  bool isEditingWorkoutTitle = false;
  bool showAddExerciseCard = false;
  bool showDeleteExerciseEntryCard = false;
  ExerciseEntry? _exerciseEntryToDelete;

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final workoutDisplayState = ActiveWorkoutDisplayState.of(context);
    final activeWorkoutData = ActiveWorkoutData.of(context);

    return Stack(
      children: [
        Card(
          elevation: 10,
          color: theme.colorScheme.secondaryContainer,
          shadowColor: Theme.of(context).colorScheme.shadow,
          child: SizedBox(
            height: double.infinity,
            child: Column(
              children: [
                Flexible(
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            topRight: Radius.circular(12.0),
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: isEditingWorkoutTitle
                                  ? LayoutBuilder(
                                      builder: (context, constraints) {
                                        return IntrinsicWidth(
                                          child: TextField(
                                            controller: _controller,
                                            autofocus: true,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              contentPadding: EdgeInsets.all(4.0),
                                            ),
                                            onChanged: (value) => setState(() {
                                              activeWorkoutData.updateActiveWorkout(
                                                activeWorkoutData.activeWorkout.copWith(
                                                  title: value,
                                                ),
                                              );
                                            }),
                                            style: theme.textTheme.displaySmall,
                                          ),
                                        );
                                      },
                                    )
                                  : GestureDetector(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          activeWorkoutData.activeWorkout.title,
                                          style: theme.textTheme.displaySmall,
                                        ),
                                      ),
                                      onTap: () => setState(() {
                                        _controller = TextEditingController(
                                          text: activeWorkoutData.activeWorkout.title,
                                        );
                                        isEditingWorkoutTitle = true;
                                      }),
                                    ),
                            ),
                            if (isEditingWorkoutTitle)
                              IconButton(
                                onPressed: () => setState(() {
                                  setState(() {
                                    isEditingWorkoutTitle = false;
                                  });
                                }),
                                icon: const Icon(
                                  Icons.done_outlined,
                                ),
                              ),
                          ],
                        ),
                        pinned: true,
                        floating: true,
                        automaticallyImplyLeading: false,
                        elevation: 8,
                        scrolledUnderElevation: 8,
                        flexibleSpace: Container(
                          height: 8,
                        ),
                        shadowColor: Theme.of(context).colorScheme.shadow,
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                        actions: [
                          IconButton(
                            onPressed: () => workoutDisplayState.setIsWorkoutFocused(false),
                            icon: const Icon(
                              Icons.close_outlined,
                            ),
                          ),
                        ],
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          activeWorkoutData.activeWorkout.exerciseEntries
                                  ?.map(
                                    (exerciseEntry) => ExerciseForm(
                                      exerciseEntry: exerciseEntry,
                                      onDeleteExerciseEntry: (exerciseEntry) {
                                        setState(() {
                                          showDeleteExerciseEntryCard = true;
                                        });
                                        _exerciseEntryToDelete = exerciseEntry;
                                      },
                                    ),
                                  )
                                  .toList() ??
                              [],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                showAddExerciseCard = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                            ),
                            child: Text(
                              'Add Exercise',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          workoutDisplayState.setHasActiveWorkout(false);
                          workoutDisplayState.setIsWorkoutFocused(false);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red.withAlpha(150)),
                        child: Text(
                          'Cancel Workout',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSecondary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          workoutDisplayState.setHasActiveWorkout(false);
                          workoutDisplayState.setIsWorkoutFocused(false);
                          // TODO: save workout
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.withAlpha(150),
                        ),
                        child: Text(
                          'Finish',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showAddExerciseCard)
          AddExerciseCard(
            onClose: () => setState(() {
              showAddExerciseCard = false;
            }),
            onSelectedExercise: (exercise) {
              ExerciseEntry newExerciseEntry = ExerciseEntry(
                sets: <ExerciseSet>[
                  const ExerciseSet(reps: 0, weight: 0.0),
                  const ExerciseSet(reps: 0, weight: 0.0),
                  const ExerciseSet(reps: 0, weight: 0.0),
                ],
                exercise: Exercise(name: exercise!.name),
              );
              Workout updatedWorkout = activeWorkoutData.activeWorkout.addExerciseEntry(
                newExerciseEntry,
              );
              activeWorkoutData.updateActiveWorkout(updatedWorkout);
              setState(() {
                showAddExerciseCard = false;
              });
            },
          ),
        if (showDeleteExerciseEntryCard)
          DeleteExerciseEntryCard(
            onKeep: () => setState(() {
              showDeleteExerciseEntryCard = false;
            }),
            onDelete: () {
              activeWorkoutData.updateActiveWorkout(
                activeWorkoutData.activeWorkout.deleteExerciseEntry(_exerciseEntryToDelete!),
              );
              setState(() {
                showDeleteExerciseEntryCard = false;
              });
            },
          ),
      ],
    );
  }
}

class DeleteExerciseEntryCard extends StatelessWidget {
  final VoidCallback onKeep;
  final VoidCallback onDelete;

  const DeleteExerciseEntryCard({super.key, required this.onKeep, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Adjust blur intensity
            child: Container(
              color: Colors.black.withAlpha(100), // Optional: Add a semi-transparent overlay
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(64.0),
            child: Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'Are you sure?',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: onDelete,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.withAlpha(150),
                            ),
                            child: Text(
                              'Yes, delete',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: onKeep,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            ),
                            child: Text(
                              'Keep',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ExerciseForm extends StatelessWidget {
  final ExerciseEntry exerciseEntry;
  final void Function(ExerciseEntry) onDeleteExerciseEntry;

  const ExerciseForm({super.key, required this.exerciseEntry, required this.onDeleteExerciseEntry});

  List<TableRow> _buildSetRow(List<ExerciseSet> items) {
    int counter = 1;
    List<TableRow> rows = [
      const TableRow(
        children: [
          Center(child: Text('Set')),
          Center(child: Text('Previous')),
          Center(child: Text('kg')),
          Center(child: Text('Reps')),
          Center(child: Icon(Icons.done, size: 20)),
        ],
      ),
    ];

    for (var _ in items) {
      rows.add(
        TableRow(
          children: [
            Center(child: Text('${counter++}')),
            const Center(child: Text('tbd')),
            const Center(
              child: SizedBox(
                width: 60,
                child: Padding(
                  padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: TextField(
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                      border: OutlineInputBorder(),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const Center(
              child: SizedBox(
                width: 60,
                child: Padding(
                  padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: TextField(
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                      border: OutlineInputBorder(),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const Center(child: Icon(Icons.done, size: 20)),
          ],
        ),
      );
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  exerciseEntry.exercise.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                IconButton(
                  onPressed: () => onDeleteExerciseEntry(exerciseEntry),
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ),
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: const {
              0: IntrinsicColumnWidth(), // Set column
              1: FlexColumnWidth(1), // Previous column
              2: FlexColumnWidth(1), // kg column
              3: FlexColumnWidth(1), // Reps column
              4: IntrinsicColumnWidth(), // Done icon column - will take minimum width needed
            },
            children: _buildSetRow(exerciseEntry.sets),
          ),
        ],
      ),
    );
  }
}

class AddExerciseCard extends StatelessWidget {
  final VoidCallback onClose;
  final void Function(Exercise?) onSelectedExercise;

  const AddExerciseCard({super.key, required this.onSelectedExercise, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
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
        ),
      ),
    );
  }
}
