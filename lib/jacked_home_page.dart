import 'package:flutter/material.dart';
import 'package:jacked/active_workout.dart';
import 'package:jacked/minimized_active_workout.dart';
import 'package:jacked/pages/diary_page.dart';
import 'package:jacked/pages/exercises_page.dart';
import 'package:jacked/pages/program_page.dart';
import 'package:jacked/pages/workout_page.dart';
import 'package:jacked/pages/you_page.dart';

class WorkoutState extends InheritedWidget {
  const WorkoutState(
      {super.key,
      required this.activeWorkout,
      required this.workoutFocused,
      required this.setActiveWorkout,
      required this.setWorkoutFocused,
      required super.child});

  final bool activeWorkout;
  final bool workoutFocused;
  final void Function(bool) setActiveWorkout;
  final void Function(bool) setWorkoutFocused;

  static WorkoutState? maybeOf(BuildContext context) {
    return context.getInheritedWidgetOfExactType<WorkoutState>();
  }

  static WorkoutState of(BuildContext context) {
    final WorkoutState? result = maybeOf(context);
    assert(result != null, 'No WorkoutState found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(WorkoutState oldWidget) =>
      activeWorkout != oldWidget.activeWorkout ||
      workoutFocused != oldWidget.workoutFocused;
}

class JackedHomePage extends StatefulWidget {
  const JackedHomePage({super.key});

  @override
  State<JackedHomePage> createState() => _JackedHomePageState();
}

class _JackedHomePageState extends State<JackedHomePage> {
  int currentPageIndex = 0;
  bool activeWorkout = false;
  bool workoutFocused = false;

  void setActiveWorkout(bool value) {
    setState(() {
      activeWorkout = value;
    });
  }

  void setWorkoutFocused(bool value) {
    setState(() {
      workoutFocused = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WorkoutState(
      activeWorkout: activeWorkout,
      workoutFocused: workoutFocused,
      setActiveWorkout: setActiveWorkout,
      setWorkoutFocused: setWorkoutFocused,
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (index) => setState(() {
            currentPageIndex = index;
          }),
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
                icon: Icon(Icons.person_2_outlined),
                selectedIcon: Icon(Icons.person_2),
                label: 'You'),
            NavigationDestination(
                icon: Icon(Icons.auto_stories_outlined),
                selectedIcon: Icon(Icons.auto_stories),
                label: 'Diary'),
            NavigationDestination(
                icon: Icon(Icons.add_box_outlined),
                selectedIcon: Icon(Icons.add_box),
                label: 'Workout'),
            NavigationDestination(
                icon: Icon(Icons.edit_calendar_outlined),
                selectedIcon: Icon(Icons.edit_calendar),
                label: 'Program'),
            NavigationDestination(
                icon: Icon(Icons.fitness_center_outlined),
                selectedIcon: Icon(Icons.fitness_center),
                label: 'Exercises')
          ],
        ),
        body: Stack(
          children: [
            <Widget>[
              YouPage(),
              DiaryPage(),
              WorkoutPage(),
              ProgramPage(),
              ExercisesPage(),
            ][currentPageIndex],
            if (activeWorkout && workoutFocused)
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ActiveWorkout(),
                ),
              ),
            if (activeWorkout && !workoutFocused)
              Column(
                children: [
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: GestureDetector(
                        onTap: () => setWorkoutFocused(true),
                        child: MinimizedActiveWorkout(),
                      ),
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
