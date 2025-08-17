import 'package:flutter/foundation.dart';
import 'package:jacked/src/db/models/exercise.dart';
import 'package:jacked/src/db/models/exercise_set.dart';

class ExerciseEntry {
  final int? exerciseEntryId;
  final Exercise exercise;
  final List<ExerciseSet> sets;

  const ExerciseEntry({
    this.exerciseEntryId,
    required this.exercise,
    required this.sets,
  });

  ExerciseEntry copyWith(List<ExerciseSet>? sets) {
    return ExerciseEntry(
      exerciseEntryId: exerciseEntryId,
      exercise: exercise,
      sets: sets ?? this.sets,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExerciseEntry &&
        exerciseEntryId == other.exerciseEntryId &&
        listEquals(sets, other.sets) &&
        exercise == other.exercise;
  }

  @override
  int get hashCode => Object.hash(exerciseEntryId, Object.hashAll(sets), exercise);
}
