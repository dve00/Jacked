import 'package:flutter/material.dart';
import 'package:jacked/src/db/models/exercise.dart';
import 'package:jacked/src/db/seeds.dart';
import 'package:jacked/src/db/repositories/exercise_repository.dart';
import 'package:jacked/src/widgets/shared/build_context.dart';

class ExerciseList extends StatelessWidget {
  final ExerciseRepository exercisesRepo;
  final void Function(Exercise) onSelectedExercise;

  const ExerciseList({
    super.key,
    required this.exercisesRepo,
    required this.onSelectedExercise,
  });

  Future<List<Exercise>> listExercisesFuture() async {
    return exercisesRepo.list();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: listExercisesFuture(),
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
            final translations = context.l10n.exerciseTranslationsByKey[exercise.key];
            if (translations == null) {
              throw UnknownExerciseKeyException(exercise.key);
            }
            return ListTile(
              title: Text(translations.name),
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
