import 'package:equatable/equatable.dart';
import 'package:jacked/src/db/models/exercise_set.dart';

class ExerciseEntry extends Equatable {
  final int? id;
  final int workoutId;
  final int exerciseId;
  final List<ExerciseSet>? sets;

  const ExerciseEntry({
    this.id,
    required this.workoutId,
    required this.exerciseId,
    this.sets,
  });

  ExerciseEntry copyWith(List<ExerciseSet>? sets) => ExerciseEntry(
    id: id,
    workoutId: workoutId,
    exerciseId: exerciseId,
    sets: sets ?? this.sets,
  );

  factory ExerciseEntry.fromMap(Map<String, Object?> map) => ExerciseEntry(
    id: map['id'] as int,
    workoutId: map['workoutId'] as int,
    exerciseId: map['exerciseId'] as int,
  );

  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'workoutId': workoutId,
    'exerciseId': exerciseId,
  };

  @override
  List<Object?> get props => [id, workoutId, exerciseId, sets];
}
