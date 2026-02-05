import 'package:flutter/material.dart';
import 'package:jacked/src/db/db.dart';
import 'package:jacked/src/db/repositories/exercise_entry_repository.dart';
import 'package:jacked/src/db/repositories/exercise_repository.dart';
import 'package:jacked/src/db/repositories/exercise_set_repository.dart';
import 'package:jacked/src/db/repositories/workout_repository.dart';
import 'package:jacked/src/widgets/jacked_home_page.dart';
import 'src/l10n/generated/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JackedDb.database;
  runApp(
    Jacked(
      exerciseRepo: await ExerciseRepository.instance,
      exerciseEntryRepo: await ExerciseEntryRepository.instance,
      exerciseSetRepo: await ExerciseSetRepository.instance,
      workoutRepo: await WorkoutRepository.instance,
    ),
  );
}

class Jacked extends StatelessWidget {
  final ExerciseRepository exerciseRepo;
  final ExerciseEntryRepository exerciseEntryRepo;
  final ExerciseSetRepository exerciseSetRepo;
  final WorkoutRepository workoutRepo;

  const Jacked({
    super.key,
    required this.exerciseRepo,
    required this.exerciseEntryRepo,
    required this.exerciseSetRepo,
    required this.workoutRepo,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jacked',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
        fontFamily: 'OpenSans',
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: JackedHomePage(
        exerciseRepo: exerciseRepo,
        exerciseEntryRepo: exerciseEntryRepo,
        exerciseSetRepo: exerciseSetRepo,
        workoutRepo: workoutRepo,
      ),
    );
  }
}
