import 'package:flutter/material.dart';
import 'package:jacked/src/db/db.dart';
import 'package:jacked/src/db/models/exercise.dart';
import 'package:jacked/src/db/seeds.dart';
import 'package:jacked/src/db/services/exercise_service.dart';
import 'package:jacked/src/widgets/shared/build_context.dart';

class ExercisesPage extends StatelessWidget {
  const ExercisesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          showDialog(
            context: context,
            builder: (context) => Dialog(
              insetPadding: const EdgeInsets.all(16),
              child: ExerciseDetailCard(exercise: exercise),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ExerciseList extends StatelessWidget {
  final void Function(Exercise) onSelectedExercise;
  const ExerciseList({super.key, required this.onSelectedExercise});

  Future<List<Exercise>> _loadExercises() async {
    return ExerciseService(db: await AppDatabase.database).getAll();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadExercises(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center();
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final exercises = snapshot.requireData;
        return ListView.separated(
          itemBuilder: (context, index) {
            final exercise = exercises[index];
            return ListTile(
              title: Text(context.l10n.exerciseTranslation(exercise.key).name),
              onTap: () => onSelectedExercise(exercise),
            );
          },
          separatorBuilder: (context, index) => const Divider(
            indent: 16,
            endIndent: 16,
          ),
          itemCount: exercises.length,
        );
      },
    );
  }
}

class ExerciseDetailCard extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    final translation = context.l10n.exerciseTranslation(exercise.key);

    // TODO: Handle custom exercises

    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
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
    );
  }
}
