import 'package:flutter/material.dart';
import 'package:jacked/src/db/db.dart';
import 'package:jacked/src/db/models/exercise.dart';
import 'package:jacked/src/db/seeds.dart';
import 'package:jacked/src/db/services/exercise_service.dart';
import 'package:jacked/src/widgets/shared/build_context.dart';

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
            title: Text(context.l10n.pages_exercises_exercises),
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
                    title: Text(context.l10n.pages_exercises_help),
                    content: Text(context.l10n.pages_exercises_helpBody),
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

  Future<List<Exercise>> _loadExercises() async {
    return ExerciseService(db: await AppDatabase.database).getAll();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadExercises(),
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
      title: Text(context.l10n.exerciseTranslation(exercise.key).name),
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
    final translation = context.l10n.exerciseTranslation(exercise.key);

    // TODO: Handle custom exercises

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
                    translation.name,
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(translation.description),
            ),
          ],
        ),
      ),
    );
  }
}
