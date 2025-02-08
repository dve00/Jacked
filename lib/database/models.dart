import 'package:flutter/foundation.dart';

class Workout {
  final int? workoutId;
  final String title;
  final DateTime startTime;
  final DateTime? stopTime;
  final String? description;
  final List<ExerciseEntry>? exerciseEntries;

  Workout(
      {this.workoutId,
      required this.title,
      required this.startTime,
      this.stopTime,
      this.description,
      this.exerciseEntries});

  Workout copWith(
      {String? title,
      DateTime? stopTime,
      String? description,
      List<ExerciseEntry>? exerciseEntries}) {
    return Workout(
        workoutId: workoutId,
        title: title ?? this.title,
        startTime: startTime,
        stopTime: stopTime ?? this.stopTime,
        description: description ?? this.description,
        exerciseEntries: exerciseEntries ?? this.exerciseEntries);
  }

  Workout addExerciseEntry(ExerciseEntry newEntry) {
    final currentEntries = exerciseEntries ?? <ExerciseEntry>[];
    final updatedEntries = List<ExerciseEntry>.from(currentEntries)
      ..add(newEntry);

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
        listEquals(
            exerciseEntries, other.exerciseEntries); // Check List Equality
  }

  @override
  int get hashCode => Object.hash(workoutId, title, startTime, stopTime,
      description, Object.hashAll(exerciseEntries ?? []));
}

class ExerciseEntry {
  final int? exerciseEntryId;
  final List<ExerciseSet> sets;
  final Exercise exercise;

  const ExerciseEntry({
    this.exerciseEntryId,
    required this.sets,
    required this.exercise,
  });

  ExerciseEntry copyWith(List<ExerciseSet>? sets) {
    return ExerciseEntry(
      exerciseEntryId: exerciseEntryId,
      sets: sets ?? this.sets,
      exercise: exercise,
    );
  }
}

class ExerciseSet {
  final int? exerciseSetId;
  final int reps;
  final double weight;
  final int? exerciseEntryId;
  final int? rpe;

  const ExerciseSet(
      {this.exerciseSetId,
      required this.reps,
      required this.weight,
      this.exerciseEntryId,
      this.rpe});

  ExerciseSet copWith(int? reps, double? weight, int? rpe) {
    return ExerciseSet(
        reps: reps ?? this.reps,
        weight: weight ?? this.weight,
        rpe: rpe ?? this.rpe);
  }
}

class Exercise {
  final int? exerciseId;
  final String name;
  final String? description;

  const Exercise({
    this.exerciseId,
    required this.name,
    this.description,
  });

  Exercise copyWith(String? name, String? description) {
    return Exercise(
        name: name ?? this.name, description: description ?? this.description);
  }
}
