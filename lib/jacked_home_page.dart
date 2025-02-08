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
      {required this.activeWorkout,
      required this.updateActiveWorkout,
      super.key,
      required super.child});

  final Workout activeWorkout;
  final void Function(Workout) updateActiveWorkout;

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
      activeWorkout != oldWidget.activeWorkout;
}

class JackedHomePage extends StatefulWidget {
  const JackedHomePage({super.key});

  @override
  State<JackedHomePage> createState() => _JackedHomePageState();
}

class _JackedHomePageState extends State<JackedHomePage> {
  int currentPageIndex = 0;
  bool isWorkoutActive = false;
  bool isWorkoutFocused = false;

  Workout activeWorkout =
      Workout(title: 'New Workout', startTime: DateTime.now());

  void setActiveWorkout(bool value) {
    setState(() {
      isWorkoutActive = value;
    });
  }

  void setWorkoutFocused(bool value) {
    setState(() {
      isWorkoutFocused = value;
    });
  }

  void updateActiveWorkout(Workout newWorkout) {
    setState(() {
      activeWorkout = newWorkout;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ActiveWorkoutDisplayState(
      hasActiveWorkout: isWorkoutActive,
      isWorkoutFocused: isWorkoutFocused,
      setHasActiveWorkout: setActiveWorkout,
      setIsWorkoutFocused: setWorkoutFocused,
      child: ActiveWorkoutData(
        activeWorkout: activeWorkout,
        updateActiveWorkout: updateActiveWorkout,
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
              if (isWorkoutActive && isWorkoutFocused)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ActiveWorkout(),
                  ),
                ),
              if (isWorkoutActive && !isWorkoutFocused)
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
