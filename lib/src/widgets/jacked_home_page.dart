import 'package:flutter/material.dart';
import 'package:jacked/src/widgets/active_workout/active_workout.dart';
import 'package:jacked/src/widgets/pages/diary_page.dart';
import 'package:jacked/src/widgets/pages/exercises_page.dart';
import 'package:jacked/src/widgets/pages/program_page.dart';
import 'package:jacked/src/widgets/pages/workout_page.dart';
import 'package:jacked/src/widgets/pages/you_page.dart';
import 'package:jacked/src/widgets/shared/build_context.dart';

class JackedHomePage extends StatefulWidget {
  const JackedHomePage({super.key});

  @override
  State<JackedHomePage> createState() => _JackedHomePageState();
}

class _JackedHomePageState extends State<JackedHomePage> {
  int currentPageIndex = 0;
  bool isWorkoutActive = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (index) => setState(() {
              currentPageIndex = index;
            }),
            selectedIndex: currentPageIndex,
            destinations: <Widget>[
              NavigationDestination(
                icon: const Icon(Icons.person_2_outlined),
                selectedIcon: const Icon(Icons.person_2),
                label: context.l10n.homepage_navbar_you,
              ),
              NavigationDestination(
                icon: const Icon(Icons.auto_stories_outlined),
                selectedIcon: const Icon(Icons.auto_stories),
                label: context.l10n.homepage_navbar_diary,
              ),
              NavigationDestination(
                icon: const Icon(Icons.add_box_outlined),
                selectedIcon: const Icon(Icons.add_box),
                label: context.l10n.homepage_navbar_workout,
              ),
              NavigationDestination(
                icon: const Icon(Icons.edit_calendar_outlined),
                selectedIcon: const Icon(Icons.edit_calendar),
                label: context.l10n.homepage_navbar_program,
              ),
              NavigationDestination(
                icon: const Icon(Icons.fitness_center_outlined),
                selectedIcon: const Icon(Icons.fitness_center),
                label: context.l10n.homepage_navbar_exercises,
              ),
            ],
          ),
          body: Stack(
            children: [
              <Widget>[
                const YouPage(),
                const DiaryPage(),
                WorkoutPage(
                  onStartWorkout: () {
                    setState(() {
                      isWorkoutActive = true;
                    });
                  },
                ),
                const ProgramPage(),
                const ExercisesPage(),
              ][currentPageIndex],
              if (isWorkoutActive)
                SafeArea(
                  child: ActiveWorkout(
                    onCancelWorkout: () {
                      setState(() {
                        isWorkoutActive = false;
                      });
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
