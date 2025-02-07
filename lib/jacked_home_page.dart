import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:jacked/active_workout.dart';
import 'package:jacked/database/models.dart';
import 'package:jacked/minimized_active_workout.dart';
import 'package:jacked/pages/diary_page.dart';
import 'package:jacked/pages/exercises_page.dart';
import 'package:jacked/pages/program_page.dart';
import 'package:jacked/pages/workout_page.dart';
import 'package:jacked/pages/you_page.dart';

class ActiveWorkoutDisplayState extends InheritedWidget {
  const ActiveWorkoutDisplayState(
      {super.key,
      required this.hasActiveWorkout,
      required this.isWorkoutFocused,
      required this.setHasActiveWorkout,
      required this.setIsWorkoutFocused,
      required super.child});

  final bool hasActiveWorkout;
  final bool isWorkoutFocused;
  final void Function(bool) setHasActiveWorkout;
  final void Function(bool) setIsWorkoutFocused;

  static ActiveWorkoutDisplayState? maybeOf(BuildContext context) {
    return context.getInheritedWidgetOfExactType<ActiveWorkoutDisplayState>();
  }

  static ActiveWorkoutDisplayState of(BuildContext context) {
    final ActiveWorkoutDisplayState? result = maybeOf(context);
    assert(result != null, 'No ActiveWorkoutDisplayState found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ActiveWorkoutDisplayState oldWidget) =>
      hasActiveWorkout != oldWidget.hasActiveWorkout ||
      isWorkoutFocused != oldWidget.isWorkoutFocused;
}

class ActiveWorkoutData extends InheritedWidget {
  const ActiveWorkoutData(
      {required this.title,
      required this.exerciseEntries,
      required this.updateTitle,
      required this.updateExerciseEntries,
      super.key,
      required super.child});

  final String title;
  final List<ExerciseEntry> exerciseEntries;
  final void Function(String) updateTitle;
  final void Function(List<ExerciseEntry>) updateExerciseEntries;

  static ActiveWorkoutData? maybeOf(BuildContext context) {
    return context.getInheritedWidgetOfExactType<ActiveWorkoutData>();
  }

  static ActiveWorkoutData of(BuildContext context) {
    final ActiveWorkoutData? result = maybeOf(context);
    assert(result != null, 'No ActiveWorkoutData found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant ActiveWorkoutData oldWidget) =>
      title != oldWidget.title ||
      !DeepCollectionEquality().equals(
          exerciseEntries,
          oldWidget
              .exerciseEntries); // always create new lists to trigger updates
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
  String activeWorkoutTitle = 'New Workout';
  List<ExerciseEntry> activeWorkoutExerciseEntries = [];

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

  void updateActiveWorkoutTitle(String newTitle) {
    setState(() {
      activeWorkoutTitle = newTitle;
    });
  }

  void updateActiveWorkoutExerciseEntries(
      List<ExerciseEntry> newExerciseEntries) {
    setState(() {
      activeWorkoutExerciseEntries = newExerciseEntries;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ActiveWorkoutDisplayState(
      hasActiveWorkout: activeWorkout,
      isWorkoutFocused: workoutFocused,
      setHasActiveWorkout: setActiveWorkout,
      setIsWorkoutFocused: setWorkoutFocused,
      child: ActiveWorkoutData(
        title: activeWorkoutTitle,
        exerciseEntries: activeWorkoutExerciseEntries,
        updateTitle: updateActiveWorkoutTitle,
        updateExerciseEntries: updateActiveWorkoutExerciseEntries,
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
      ),
    );
  }
}
