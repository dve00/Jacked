import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jacked/database/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jacked/database/repositories.dart';
import 'package:jacked/database/database.dart';
import 'package:jacked/jacked_home_page.dart';
import 'l10n/generated/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = await DatabaseHelper.instance.database;

  final prefs = await SharedPreferences.getInstance();
  const isFirstRunKey = 'first_run';
  const isFirstRunDevKey = 'first_run_dev';

  final isFirstRun = prefs.getBool(kDebugMode ? isFirstRunDevKey : isFirstRunKey) ?? true;

  if (isFirstRun) {
    final tableExists = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='exercises'",
    );

    if (tableExists.isNotEmpty) {
      // Table exists, so drop it
      await db.execute('DROP TABLE exercises');
    }
    await db.execute(
      'CREATE TABLE exercises(exerciseId INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, description Text)',
    );
    final jsonString = await rootBundle.loadString('assets/exercises.json');
    await DatabaseHelper.instance.database;
    List<dynamic> exerciseData = json.decode(jsonString);
    final exercises = exerciseData
        .map(
          (map) => Exercise(
            exerciseId: map['exerciseId'],
            name: map['name'],
            description: map['description'],
          ),
        )
        .toList();
    final exerciseRepo = ExerciseRepository();
    await Future.wait(exercises.map((ex) => exerciseRepo.insert(ex)));
    final exs = await exerciseRepo.getAll();
    assert(exs.isNotEmpty, 'No exercise were inserted');
    prefs.setBool(kDebugMode ? isFirstRunDevKey : isFirstRunKey, false);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jacked',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const JackedHomePage(),
    );
  }
}
