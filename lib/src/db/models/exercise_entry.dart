import 'package:equatable/equatable.dart';
import 'package:jacked/src/db/models/exercise.dart';
import 'package:jacked/src/db/models/exercise_set.dart';

class ExerciseEntry extends Equatable {
  final int id;
  final int workoutId;
  final int exerciseId;
  final String? notes;
  final Exercise? exercise;
  final List<ExerciseSet>? sets;
  final List<ExerciseSet>? previousSets;

  const ExerciseEntry({
    required this.id,
    required this.workoutId,
    required this.exerciseId,
    this.notes,
    this.exercise,
    this.sets,
    this.previousSets,
  });

  ExerciseEntry copyWith({
    int? id,
    int? workoutId,
    int? exerciseId,
    String? notes,
    Exercise? exercise,
    List<ExerciseSet>? sets,
    List<ExerciseSet>? previousSets,
  }) => ExerciseEntry(
    id: id ?? this.id,
    workoutId: workoutId ?? this.workoutId,
    exerciseId: exerciseId ?? this.exerciseId,
    notes: notes ?? this.notes,
    exercise: exercise ?? this.exercise,
    sets: sets ?? this.sets,
    previousSets: previousSets ?? this.previousSets,
  );

  factory ExerciseEntry.fromMap(Map<String, Object?> map) => ExerciseEntry(
    id: map['id'] as int,
    workoutId: map['workoutId'] as int,
    exerciseId: map['exerciseId'] as int,
    notes: map['notes'] != null ? map['notes'] as String : null,
  );

  Map<String, Object?> toMap() => {
    'workoutId': workoutId,
    'exerciseId': exerciseId,
    'notes': notes,
  };

  @override
  List<Object?> get props => [id, workoutId, exerciseId, notes, sets, previousSets];
}

class NewExerciseEntry extends Equatable {
  final int workoutId;
  final int exerciseId;
  final String? notes;

  const NewExerciseEntry({
    required this.workoutId,
    required this.exerciseId,
    this.notes,
  });

  Map<String, Object?> toMap() => {
    'workoutId': workoutId,
    'exerciseId': exerciseId,
    'notes': notes,
  };

  @override
  List<Object?> get props => [workoutId, exerciseId, notes];
}
