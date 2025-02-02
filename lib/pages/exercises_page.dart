import 'package:flutter/material.dart';
import 'package:jacked/database/models.dart';
import 'package:jacked/database/repositories.dart';

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
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          title: const Text('Exercises'),
          titleTextStyle: Theme.of(context).textTheme.displaySmall,
          centerTitle: false,
          shadowColor: Theme.of(context).colorScheme.shadow,
          actions: [
            IconButton(
              icon: Icon(
                Icons.help_outline_outlined,
              ),
              onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: const Text('Exercises Page'),
                        content: const Text('Display help here!'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'))
                        ],
                      )),
            ),
          ],
        ),
        body: FutureBuilder(
            future: ExerciseRepository().getAll(),
            builder: (BuildContext context,
                AsyncSnapshot<List<Exercise>> asyncSnapshot) {
              if (!asyncSnapshot.hasData) return const SizedBox();
              return ListView.separated(
                  itemBuilder: (context, index) {
                    final exercise = asyncSnapshot.data![index];
                    return ListTile(
                      title: Text(exercise.name),
                      onTap: () => setState(() {
                        selectedExercise = exercise;
                      }),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                        indent: 10,
                        endIndent: 10,
                      ),
                  itemCount: asyncSnapshot.data!.length);
            }),
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
        )
    ]);
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
                  Spacer(),
                  Spacer(),
                  IconButton(
                    onPressed: onClose,
                    icon: Icon(
                      Icons.close_outlined,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
