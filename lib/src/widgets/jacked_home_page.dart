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

  static const sheetMinSnap = 0.23;
  static const sheetMaxSnap = 1.0;

  late final DraggableScrollableController _sheetController = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
  }

  double get navBarSlide {
    if (!_sheetController.isAttached) return 0.0;
    return ((_sheetController.size - sheetMinSnap) / (sheetMaxSnap - sheetMinSnap)).clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  PreferredSizeWidget constructAppBar(String title, String helpBody) {
    return AppBar(
      title: Text(title),
      titleTextStyle: context.textTheme.displaySmall,
      centerTitle: false,
      shadowColor: Theme.of(context).colorScheme.shadow,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.help_outline_outlined,
          ),
          onPressed: () => showDialog<String>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(context.l10n.pages_workout_workoutPage),
              content: Text(helpBody),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: [
            constructAppBar(context.l10n.homepage_you, context.l10n.homepage_help_you),
            constructAppBar(context.l10n.homepage_diary, context.l10n.homepage_help_diary),
            constructAppBar(context.l10n.homepage_workout, context.l10n.homepage_help_workout),
            constructAppBar(context.l10n.homepage_program, context.l10n.homepage_help_program),
            constructAppBar(context.l10n.homepage_exercises, context.l10n.homepage_help_exercises),
          ][currentPageIndex],
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
            ],
          ),
        ),
        if (isWorkoutActive)
          Material(
            type: MaterialType.transparency,
            child: SafeArea(
              top: true,
              bottom: false,
              child: ActiveWorkout(
                sheetMinSnap: sheetMinSnap,
                sheetMaxSnap: sheetMaxSnap,
                controller: _sheetController,
                onCancelWorkout: () async {
                  await Future.delayed(const Duration(milliseconds: 300));
                  setState(() {
                    isWorkoutActive = false;
                  });
                },
              ),
            ),
          ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: AnimatedBuilder(
            animation: _sheetController,
            builder: (context, child) {
              return AnimatedSlide(
                offset: Offset(0, navBarSlide),
                duration: const Duration(milliseconds: 0),
                child: SafeArea(
                  top: true,
                  bottom: false,
                  child: NavigationBar(
                    onDestinationSelected: (index) => setState(() {
                      currentPageIndex = index;
                    }),
                    selectedIndex: currentPageIndex,
                    destinations: <Widget>[
                      NavigationDestination(
                        icon: const Icon(Icons.person_2_outlined),
                        selectedIcon: const Icon(Icons.person_2),
                        label: context.l10n.homepage_you,
                      ),
                      NavigationDestination(
                        icon: const Icon(Icons.auto_stories_outlined),
                        selectedIcon: const Icon(Icons.auto_stories),
                        label: context.l10n.homepage_diary,
                      ),
                      NavigationDestination(
                        icon: const Icon(Icons.add_box_outlined),
                        selectedIcon: const Icon(Icons.add_box),
                        label: context.l10n.homepage_workout,
                      ),
                      NavigationDestination(
                        icon: const Icon(Icons.edit_calendar_outlined),
                        selectedIcon: const Icon(Icons.edit_calendar),
                        label: context.l10n.homepage_program,
                      ),
                      NavigationDestination(
                        icon: const Icon(Icons.fitness_center_outlined),
                        selectedIcon: const Icon(Icons.fitness_center),
                        label: context.l10n.homepage_exercises,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
