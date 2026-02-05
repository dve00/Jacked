import 'package:flutter/material.dart';
import 'package:jacked/src/db/repositories/repositories.dart';
import 'package:jacked/src/widgets/active_workout/active_workout.dart';
import 'package:jacked/src/widgets/pages/diary_page/diary_page.dart';
import 'package:jacked/src/widgets/pages/exercises_page.dart';
import 'package:jacked/src/widgets/pages/program_page.dart';
import 'package:jacked/src/widgets/pages/workout_page.dart';
import 'package:jacked/src/widgets/pages/you_page.dart';
import 'package:jacked/src/widgets/shared/build_context.dart';

class JackedHomePage extends StatelessWidget {
  final Repositories repos;

  final navigationKey = GlobalKey<_JackedNavigationState>();
  final scrollController = DraggableScrollableController();

  JackedHomePage({
    super.key,
    required this.repos,
  });

  @override
  Widget build(BuildContext context) {
    final sheetMinSnap =
        (150 + MediaQuery.of(context).padding.bottom) / MediaQuery.of(context).size.height;
    return JackedNavigation(
      key: navigationKey,
      scrollController: scrollController,
      pages: [
        const YouPage(),
        DiaryPage(
          repos: repos,
        ),
        WorkoutPage(
          onStartWorkout: () {
            navigationKey.currentState?.setWorkoutActive();
          },
        ),
        const ProgramPage(),
        ExercisesPage(repos: repos),
      ],
      activeWorkout: ActiveWorkout(
        repos: repos,
        controller: scrollController,
        sheetMinSnap: sheetMinSnap,
        sheetMaxSnap: 1.0,
        onCancelWorkout: () async {
          await Future.delayed(const Duration(milliseconds: 300));
          navigationKey.currentState?.setWorkoutInactive();
        },
        onSaveWorkout: () async {
          await Future.delayed(const Duration(milliseconds: 300));
          navigationKey.currentState?.setWorkoutInactive();
        },
      ),
    );
  }
}

class JackedNavigation extends StatefulWidget {
  final DraggableScrollableController scrollController;
  final List<Widget> pages;
  final Widget activeWorkout;

  const JackedNavigation({
    super.key,
    required this.scrollController,
    required this.pages,
    required this.activeWorkout,
  });

  @override
  State<JackedNavigation> createState() => _JackedNavigationState();
}

class _JackedNavigationState extends State<JackedNavigation> {
  int _currentPageIndex = 0;
  bool _isWorkoutActive = false;

  final _sheetMaxSnap = 1.0;
  double _sheetMinSnap = 0;

  late DraggableScrollableController _sheetController;

  @override
  void initState() {
    super.initState();

    _sheetController = widget.scrollController;

    /// compute the correct height for the minimized active workout sheet
    /// 150 is the navbar height + draggable header height
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final height = MediaQuery.of(context).size.height;

      setState(() {
        _sheetMinSnap = 150.0 / height;
      });
    });
  }

  void setWorkoutInactive() {
    setState(() {
      _isWorkoutActive = false;
    });
  }

  void setWorkoutActive() {
    setState(() {
      _isWorkoutActive = true;
    });
  }

  double get navBarSlide {
    if (!_sheetController.isAttached) return 0.0;
    return ((_sheetController.size - _sheetMinSnap) / (_sheetMaxSnap - _sheetMinSnap)).clamp(
      0.0,
      1.0,
    );
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
          ][_currentPageIndex],
          body: Padding(
            // padding matches height of navbar
            padding: const EdgeInsets.only(bottom: 80.0),
            child: widget.pages[_currentPageIndex],
          ),
        ),
        if (_isWorkoutActive) widget.activeWorkout,
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
                      _currentPageIndex = index;
                    }),
                    selectedIndex: _currentPageIndex,
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
