import 'package:flutter/material.dart';
import 'package:jacked/src/database/models.dart';
import 'package:jacked/src/database/repositories.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({
    super.key,
  });

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  Exercise? selectedExercise;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Exercises'),
            titleTextStyle: Theme.of(context).textTheme.displaySmall,
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
                    title: const Text('Exercises Page'),
                    content: const Text('Display help here!'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          body: ExerciseList(
            onSelectedExercise: (exercise) {
              setState(() {
                selectedExercise = exercise;
              });
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
        ),
        if (selectedExercise != null)
          SafeArea(
            child: ExerciseDetailCard(
              exercise: selectedExercise!,
              onClose: () => setState(() {
                selectedExercise = null;
              }),
            ),
          ),
      ],
    );
  }
}

class ExerciseList extends StatelessWidget {
  final void Function(Exercise?) onSelectedExercise;

  const ExerciseList({super.key, required this.onSelectedExercise});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ExerciseRepository().getAll(),
      builder: (context, asyncSnapshot) {
        if (!asyncSnapshot.hasData) return const SizedBox();
        return ListView.separated(
          itemBuilder: (context, index) {
            final exercise = asyncSnapshot.data![index];
            return ExerciseListItem(
              exercise: exercise,
              onSelectedExercise: onSelectedExercise,
            );
          },
          separatorBuilder: (context, index) => const Divider(
            indent: 10,
            endIndent: 10,
          ),
          itemCount: asyncSnapshot.data!.length,
        );
      },
    );
  }
}

class ExerciseListItem extends StatelessWidget {
  final Exercise exercise;
  final void Function(Exercise?) onSelectedExercise;

  const ExerciseListItem({super.key, required this.exercise, required this.onSelectedExercise});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(exercise.name),
      onTap: () => onSelectedExercise(exercise),
    );
  }
}

class ExerciseDetailCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onClose;

  const ExerciseDetailCard({
    super.key,
    required this.exercise,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    exercise.name,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const Spacer(),
                  const Spacer(),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(
                      Icons.close_outlined,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
