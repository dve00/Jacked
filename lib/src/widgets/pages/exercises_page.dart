import 'package:flutter/material.dart';
import 'package:jacked/src/db/models/exercise.dart';
import 'package:jacked/src/db/repositories/repositories.dart';
import 'package:jacked/src/db/seeds.dart';
import 'package:jacked/src/widgets/shared/build_context.dart';
import 'package:jacked/src/widgets/shared/widgets/exercise_list.dart';

class ExercisesPage extends StatelessWidget {
  final Repositories repos;

  const ExercisesPage({
    super.key,
    required this.repos,
  });

  @override
  Widget build(BuildContext context) {
    return ExerciseList(
      exercisesRepo: repos.exerciseRepo,
      onSelectedExercise: (exercise) {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            insetPadding: const EdgeInsets.all(16),
            child: ExerciseDetailCard(exercise: exercise),
          ),
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
    final translations = context.l10n.exerciseTranslationsByKey[exercise.key];
    if (translations == null) {
      throw UnknownExerciseKeyException(exercise.key);
    }

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
                  translations.name,
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
            child: Text(translations.description),
          ),
        ],
      ),
    );
  }
}
