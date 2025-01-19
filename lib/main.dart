import 'package:flutter/material.dart';
import 'package:jacked/pages/diary_page.dart';
import 'package:jacked/pages/exercises_page.dart';
import 'package:jacked/pages/program_page.dart';
import 'package:jacked/pages/workout_page.dart';
import 'package:jacked/pages/you_page.dart';

void main() {
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

class JackedHomePage extends StatefulWidget {
  const JackedHomePage({super.key});

  @override
  State<JackedHomePage> createState() => _JackedHomePageState();
}

class _JackedHomePageState extends State<JackedHomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
          onDestinationSelected: (index) => setState(() {
                currentPageIndex = index;
              }),
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
                icon: Icon(Icons.person_2_outlined),
                selectedIcon: Icon(Icons.person_2),
                label: "You"),
            NavigationDestination(
                icon: Icon(Icons.auto_stories_outlined),
                selectedIcon: Icon(Icons.auto_stories),
                label: "Diary"),
            NavigationDestination(
                icon: Icon(Icons.add_box_outlined),
                selectedIcon: Icon(Icons.add_box),
                label: "Workout"),
            NavigationDestination(
                icon: Icon(Icons.edit_calendar_outlined),
                selectedIcon: Icon(Icons.edit_calendar),
                label: "Program"),
            NavigationDestination(
                icon: Icon(Icons.fitness_center_outlined),
                selectedIcon: Icon(Icons.fitness_center),
                label: "Exercises")
          ]),
      body: <Widget>[
        YouPage(),
        DiaryPage(),
        WorkoutPage(),
        ProgramPage(),
        ExercisesPage(),
      ][currentPageIndex],
    );
  }
}
