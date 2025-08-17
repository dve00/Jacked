class ExerciseSet {
  final int? exerciseSetId;
  final int reps;
  final double weight;
  final int? rpe;

  const ExerciseSet({
    this.exerciseSetId,
    required this.reps,
    required this.weight,
    this.rpe,
  });

  ExerciseSet copWith(int? reps, double? weight, int? rpe) {
    return ExerciseSet(
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      rpe: rpe ?? this.rpe,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExerciseSet &&
        exerciseSetId == other.exerciseSetId &&
        reps == other.reps &&
        weight == other.weight &&
        rpe == other.rpe;
  }

  @override
  int get hashCode => Object.hash(exerciseSetId, reps, weight, rpe);
}
