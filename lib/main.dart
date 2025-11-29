import 'package:flutter/material.dart';
import 'package:jacked/src/db/db.dart';
import 'package:jacked/src/db/services/exercise_entry_service.dart';
import 'package:jacked/src/db/services/exercise_service.dart';
import 'package:jacked/src/db/services/exercise_set_service.dart';
import 'package:jacked/src/db/services/workout_service.dart';
import 'package:jacked/src/widgets/jacked_home_page.dart';
import 'src/l10n/generated/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JackedDb.database;
  runApp(
    Jacked(
      exerciseSvc: await ExerciseService.instance,
      exerciseEntrySvc: await ExerciseEntryService.instance,
      exerciseSetSvc: await ExerciseSetService.instance,
      workoutSvc: await WorkoutService.instance,
    ),
  );
}

class Jacked extends StatelessWidget {
  final ExerciseService exerciseSvc;
  final ExerciseEntryService exerciseEntrySvc;
  final ExerciseSetService exerciseSetSvc;
  final WorkoutService workoutSvc;

  const Jacked({
    super.key,
    required this.exerciseSvc,
    required this.exerciseEntrySvc,
    required this.exerciseSetSvc,
    required this.workoutSvc,
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
        exerciseSvc: exerciseSvc,
        exerciseEntrySvc: exerciseEntrySvc,
        exerciseSetSvc: exerciseSetSvc,
        workoutSvc: workoutSvc,
      ),
    );
  }
}
