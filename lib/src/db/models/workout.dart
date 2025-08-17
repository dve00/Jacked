import 'package:flutter/foundation.dart';
import 'package:jacked/src/db/models/exercise_entry.dart';

class Workout {
  final int? workoutId;
  final String title;
  final DateTime startTime;
  final DateTime? stopTime;
  final String? description;
  final List<ExerciseEntry>? exerciseEntries;

  Workout({
    this.workoutId,
    required this.title,
    required this.startTime,
    this.stopTime,
    this.description,
    this.exerciseEntries,
  });

  Workout copWith({
    String? title,
    DateTime? stopTime,
    String? description,
    List<ExerciseEntry>? exerciseEntries,
  }) {
    return Workout(
      workoutId: workoutId,
      title: title ?? this.title,
      startTime: startTime,
      stopTime: stopTime ?? this.stopTime,
      description: description ?? this.description,
      exerciseEntries: exerciseEntries ?? this.exerciseEntries,
    );
  }

  Workout addExerciseEntry(ExerciseEntry newEntry) {
    final currentEntries = exerciseEntries ?? <ExerciseEntry>[];
    final updatedEntries = List<ExerciseEntry>.from(currentEntries)..add(newEntry);

    return copWith(exerciseEntries: updatedEntries);
  }

  Workout deleteExerciseEntry(ExerciseEntry exerciseEntry) {
    final currentEntries = exerciseEntries ?? <ExerciseEntry>[];
    final updatedEntries = currentEntries.where((entry) => entry != exerciseEntry).toList();

    return copWith(exerciseEntries: updatedEntries);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Workout &&
        workoutId == other.workoutId &&
        title == other.title &&
        startTime == other.startTime &&
        stopTime == other.stopTime &&
        description == other.description &&
        listEquals(exerciseEntries, other.exerciseEntries);
  }

  @override
  int get hashCode => Object.hash(
    workoutId,
    title,
    startTime,
    stopTime,
    description,
    Object.hashAll(exerciseEntries ?? []),
  );
}
