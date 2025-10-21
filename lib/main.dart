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
  await JackedDatabase.init();
  runApp(
    Jacked(
      exerciseSvc: await ExerciseService.instance,
      exerciseEntryService: await ExerciseEntryService.instance,
      exerciseSetService: await ExerciseSetService.instance,
      workoutSvc: await WorkoutService.instance,
    ),
  );
}

class Jacked extends StatelessWidget {
  final ExerciseService exerciseSvc;
  final ExerciseEntryService exerciseEntryService;
  final ExerciseSetService exerciseSetService;
  final WorkoutService workoutSvc;

  const Jacked({
    super.key,
    required this.exerciseSvc,
    required this.exerciseEntryService,
    required this.exerciseSetService,
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
        exerciseEntryService: exerciseEntryService,
        exerciseSetSvc: exerciseSetService,
        workoutSvc: workoutSvc,
      ),
    );
  }
}
