import 'package:flutter/material.dart';
import 'package:jacked/src/db/services/exercise_entry_service.dart';
import 'package:jacked/src/db/services/exercise_service.dart';
import 'package:jacked/src/db/services/exercise_set_service.dart';
import 'package:jacked/src/db/services/workout_service.dart';

class ServiceProvider extends InheritedWidget {
  final ExerciseService exerciseService;
  final WorkoutService workoutService;
  final ExerciseEntryService exerciseEntryService;
  final ExerciseSetService exerciseSetService;

  const ServiceProvider({
    super.key,
    required this.exerciseService,
    required this.workoutService,
    required this.exerciseEntryService,
    required this.exerciseSetService,
    required super.child,
  });

  static ServiceProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ServiceProvider>()!;

  @override
  bool updateShouldNotify(ServiceProvider oldWidget) =>
      exerciseService != oldWidget.exerciseService || workoutService != oldWidget.workoutService;
}
