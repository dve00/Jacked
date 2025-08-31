import 'package:flutter/material.dart';
import 'package:jacked/src/db/services/exercise_service.dart';

class ServiceProvider extends InheritedWidget {
  final ExerciseService exerciseService;

  const ServiceProvider({
    super.key,
    required this.exerciseService,
    required super.child,
  });

  static ServiceProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ServiceProvider>()!;

  @override
  bool updateShouldNotify(ServiceProvider oldWidget) =>
      exerciseService != oldWidget.exerciseService;
}
