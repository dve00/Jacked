import 'package:flutter/material.dart';
import 'package:jacked/src/db/models/exercise.dart';
import 'package:jacked/src/db/seeds.dart';
import 'package:jacked/src/db/services/exercise_service.dart';
import 'package:jacked/src/widgets/shared/build_context.dart';

class ExerciseList extends StatelessWidget {
  final ExerciseService exercisesSvc;
  final void Function(Exercise) onSelectedExercise;

  const ExerciseList({
    super.key,
    required this.exercisesSvc,
    required this.onSelectedExercise,
  });

  Future<List<Exercise>> listExercisesFuture() async {
    return exercisesSvc.list();
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
