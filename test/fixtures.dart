import 'package:jacked/src/db/models/exercise.dart';
import 'package:jacked/src/db/models/exercise_entry.dart';
import 'package:jacked/src/db/models/exercise_set.dart';
import 'package:jacked/src/db/models/workout.dart';

Workout fixtureWorkout([Workout Function(Workout)? mod]) {
  var workout = Workout(
    id: 1,
    title: 'Workout 1',
    startTime: DateTime(2025, 11, 23),
    endTime: DateTime(2025, 11, 23),
    description: 'Some workout description',
  );

  if (mod != null) {
    workout = mod(workout);
  }

  return workout;
}

ExerciseEntry fixtureExerciseEntry([ExerciseEntry Function(ExerciseEntry)? mod]) {
  var exerciseEntry = const ExerciseEntry(
    id: 1,
    workoutId: 1,
    exerciseId: 1,
    exercise: Exercise(
      id: 1,
      key: 'bench_press',
    ),
    sets: <ExerciseSet>[
      ExerciseSet(exerciseEntryId: 1, reps: 8, weight: 20),
    ],
  );

  if (mod != null) {
    exerciseEntry = mod(exerciseEntry);
  }

  return exerciseEntry;
}

ExerciseSet fixtureExerciseSet([ExerciseSet Function(ExerciseSet)? mod]) {
  var exerciseSet = const ExerciseSet(
    id: 1,
    exerciseEntryId: 1,
  );

  if (mod != null) {
    exerciseSet = mod(exerciseSet);
  }

  return exerciseSet;
}

Exercise fixtureExercise([Exercise Function(Exercise)? mod]) {
  var exercise = const Exercise(id: 1, key: 'bench_press');

  if (mod != null) {
    exercise = mod(exercise);
  }

  return exercise;
}
