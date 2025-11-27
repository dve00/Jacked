import 'package:equatable/equatable.dart';

class ExerciseSet extends Equatable {
  final int? id;
  final int exerciseEntryId;
  final int? reps;

  /// weight in kg
  final double? weight;

  /// duration in seconds
  final Duration? duration;
  final int? rpe;

  const ExerciseSet({
    this.id,
    required this.exerciseEntryId,
    this.reps,
    this.weight,
    this.duration,
    this.rpe,
  });

  ExerciseSet copyWith({
    int? id,
    int? reps,
    double? weight,
    Duration? duration,
    int? rpe,
    bool? hasNegativeWeight,
  }) {
    return ExerciseSet(
      id: id ?? this.id,
      exerciseEntryId: exerciseEntryId,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      duration: duration ?? this.duration,
      rpe: rpe ?? this.rpe,
    );
  }

  factory ExerciseSet.fromMap(Map<String, Object?> map) => ExerciseSet(
    id: map['id'] as int,
    exerciseEntryId: map['exerciseEntryId'] as int,
    reps: map['reps'] != null ? map['reps'] as int : null,
    weight: map['weight'] != null ? map['weight'] as double : null,
    duration: map['duration'] != null ? Duration(seconds: map['duration'] as int) : null,
    rpe: map['rpe'] != null ? map['rpe'] as int : null,
  );

  Map<String, Object?> toMap() => {
    'exerciseEntryId': exerciseEntryId,
    'reps': reps,
    'weight': weight,
    'duration': duration?.inSeconds,
    'rpe': rpe,
  };

  @override
  List<Object?> get props => [id, exerciseEntryId, reps, weight, duration, rpe];
}
