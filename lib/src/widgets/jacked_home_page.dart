import 'package:flutter/material.dart';
import 'package:jacked/src/widgets/active_workout.dart';
import 'package:jacked/src/database/models.dart';
import 'package:jacked/src/widgets/minimized_active_workout.dart';
import 'package:jacked/src/widgets/pages/diary_page.dart';
import 'package:jacked/src/widgets/pages/exercises_page.dart';
import 'package:jacked/src/widgets/pages/program_page.dart';
import 'package:jacked/src/widgets/pages/workout_page.dart';
import 'package:jacked/src/widgets/pages/you_page.dart';
import 'package:jacked/src/widgets/shared/build_context.dart';

class ActiveWorkoutDisplayState extends InheritedWidget {
  const ActiveWorkoutDisplayState({
    super.key,
    required this.hasActiveWorkout,
    required this.isWorkoutFocused,
    required this.setHasActiveWorkout,
    required this.setIsWorkoutFocused,
    required super.child,
  });

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
  const ActiveWorkoutData({
    required this.activeWorkout,
    required this.updateActiveWorkout,
    super.key,
    required super.child,
  });

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

  Workout activeWorkout = Workout(
    title: 'New Workout',
    startTime: DateTime.now(),
  );

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
        child: Stack(
          children: [
            Scaffold(
              bottomNavigationBar: NavigationBar(
                onDestinationSelected: (index) => setState(() {
                  currentPageIndex = index;
                }),
                selectedIndex: currentPageIndex,
                destinations: <Widget>[
                  NavigationDestination(
                    icon: Icon(Icons.person_2_outlined),
                    selectedIcon: Icon(Icons.person_2),
                    label: context.l10n.homepage_navbar_you,
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.auto_stories_outlined),
                    selectedIcon: Icon(Icons.auto_stories),
                    label: context.l10n.homepage_navbar_diary,
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.add_box_outlined),
                    selectedIcon: Icon(Icons.add_box),
                    label: context.l10n.homepage_navbar_workout,
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.edit_calendar_outlined),
                    selectedIcon: Icon(Icons.edit_calendar),
                    label: context.l10n.homepage_navbar_program,
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.fitness_center_outlined),
                    selectedIcon: Icon(Icons.fitness_center),
                    label: context.l10n.homepage_navbar_exercises,
                  ),
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
                    ),
                ],
              ),
            ),
            if (isWorkoutActive && isWorkoutFocused)
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ActiveWorkout(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
