class Workout {
  final int? workoutId;
  String title;
  final DateTime startTime;
  final DateTime? stopTime;
  final String? description;

  Workout(
      {this.workoutId,
      this.title = 'New Workout',
      required this.startTime,
      this.stopTime,
      this.description});
}

class ExerciseEntry {
  final int? exerciseEntryId;
  final List<ExerciseSet> sets;
  final Exercise exercise;
  final Workout workout;

  const ExerciseEntry(
      {this.exerciseEntryId,
      required this.sets,
      required this.exercise,
      required this.workout});
}

class ExerciseSet {
  final int? exerciseSetId;
  final int reps;
  final double weight;

  const ExerciseSet(
      {this.exerciseSetId, required this.reps, required this.weight});
}

class Exercise {
  final int? exerciseId;
  final String name;
  final String? description;
  final List<ExerciseEntry> entries;

  const Exercise(
      {this.exerciseId,
      required this.name,
      this.description,
      required this.entries});
}
