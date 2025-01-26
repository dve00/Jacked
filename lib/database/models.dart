class Workout {
  final int workoutId;
  final String title;
  final DateTime startTime;
  final Duration duration;
  final String? description;

  const Workout(
      {required this.workoutId,
      required this.title,
      required this.startTime,
      required this.duration,
      this.description});
}

class ExerciseEntry {
  final int exerciseEntryId;
  final List<ExerciseSet> sets;
  final Exercise exercise;
  final Workout workout;

  const ExerciseEntry(
      {required this.exerciseEntryId,
      required this.sets,
      required this.exercise,
      required this.workout});
}

class ExerciseSet {
  final int exerciseSetId;
  final int reps;
  final double weight;

  const ExerciseSet(
      {required this.exerciseSetId, required this.reps, required this.weight});
}

class Exercise {
  final int exerciseId;
  final String name;
  final String? description;
  final List<ExerciseEntry> entries;

  const Exercise(
      {required this.exerciseId,
      required this.name,
      this.description,
      required this.entries});
}
