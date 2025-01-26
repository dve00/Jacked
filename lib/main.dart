import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jacked/database/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jacked/database/repositories.dart';
import 'package:jacked/database/database.dart';
import 'package:jacked/jacked_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;

  final prefs = await SharedPreferences.getInstance();
  final isFirstRun = prefs.getBool('first_run') ?? true;
  if (isFirstRun) {
    final jsonString = await rootBundle.loadString('assets/exercises.json');
    List<dynamic> exerciseData = json.decode(jsonString);
    final exercises = exerciseData
        .map((map) => Exercise(
            exerciseId: map['id'],
            name: map['name'],
            description: map['description'],
            entries: List<ExerciseEntry>.empty()))
        .toList();
    final exerciseRepo = ExerciseRepository();
    await Future.wait(exercises.map((ex) => exerciseRepo.insert(ex)));
    final exs = await exerciseRepo.getAll();
    assert(exs.isNotEmpty, "No exercise were inserted");
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
        ),
        useMaterial3: true,
      ),
      home: const JackedHomePage(),
    );
  }
}
