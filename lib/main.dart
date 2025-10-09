import 'package:flutter/material.dart';
import 'package:jacked/src/db/db.dart';
import 'package:jacked/src/db/service_provider.dart';
import 'package:jacked/src/db/services/exercise_entry_service.dart';
import 'package:jacked/src/db/services/exercise_service.dart';
import 'package:jacked/src/db/services/workout_service.dart';
import 'package:jacked/src/widgets/jacked_home_page.dart';
import 'src/l10n/generated/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = await AppDatabase.database;
  runApp(
    ServiceProvider(
      exerciseService: ExerciseService(db: db),
      workoutService: WorkoutService(db: db),
      exerciseEntryService: ExerciseEntryService(db: db),
      child: const Jacked(),
    ),
  );
}

class Jacked extends StatelessWidget {
  const Jacked({super.key});

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
      home: const JackedHomePage(),
    );
  }
}
