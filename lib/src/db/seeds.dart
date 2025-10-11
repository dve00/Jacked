import 'package:jacked/src/db/models/exercise.dart';
import 'package:jacked/src/db/models/exercise_entry.dart';
import 'package:jacked/src/db/models/exercise_set.dart';
import 'package:jacked/src/db/models/workout.dart';
import 'package:jacked/src/l10n/generated/app_localizations.dart';

const seedExercises = <Exercise>[
  Exercise(id: 1, key: 'bench_press'),
  Exercise(id: 2, key: 'lat_pulldown'),
  Exercise(id: 3, key: 'overhead_press'),
  Exercise(id: 4, key: 'seated_row'),
  Exercise(id: 5, key: 'back_squat'),
];

final seedWorkouts = <Workout>[
  Workout(
    title: 'Test Workout 1',
    startTime: DateTime(2025, 9, 8, 18, 0),
    endTime: DateTime(2025, 9, 8, 19, 0),
    description: 'Desc1',
  ),
  Workout(
    title: 'Test Workout 2',
    startTime: DateTime(2025, 9, 9, 7, 30),
    endTime: DateTime(2025, 9, 9, 8, 15),
    description: 'Desc2',
  ),
  Workout(
    title: 'Test Workout 3',
    startTime: DateTime(2025, 9, 10, 12, 0),
    endTime: DateTime(2025, 9, 10, 12, 45),
    description: 'Desc3',
  ),
  Workout(
    title: 'Test Workout 4',
    startTime: DateTime(2025, 9, 11, 17, 15),
    endTime: DateTime(2025, 9, 11, 18, 0),
    description: 'Desc4',
  ),
  Workout(
    title: 'Test Workout 5',
    startTime: DateTime(2025, 9, 12, 6, 0),
    endTime: DateTime(2025, 9, 12, 6, 50),
    description: 'Desc5 is super duper mega long so that the line will break',
  ),
];

const seedExerciseEntries = <ExerciseEntry>[
  ExerciseEntry(id: 1, workoutId: 1, exerciseId: 1),
  ExerciseEntry(id: 2, workoutId: 1, exerciseId: 2),
  ExerciseEntry(id: 3, workoutId: 1, exerciseId: 3),
  ExerciseEntry(id: 4, workoutId: 2, exerciseId: 2),
  ExerciseEntry(id: 5, workoutId: 3, exerciseId: 3),
  ExerciseEntry(id: 6, workoutId: 4, exerciseId: 4),
  ExerciseEntry(id: 7, workoutId: 5, exerciseId: 5),
];

const seedExerciseSets = <ExerciseSet>[
  ExerciseSet(id: 1, exerciseEntryId: 1, reps: 1, weight: 1.0),
  ExerciseSet(id: 2, exerciseEntryId: 1, reps: 2, weight: 2.0),
  ExerciseSet(id: 3, exerciseEntryId: 2, reps: 3, weight: 3.0),
  ExerciseSet(id: 4, exerciseEntryId: 2, duration: Duration(seconds: 4)),
];

class UnknownExerciseKeyException implements Exception {
  final String key;
  UnknownExerciseKeyException(this.key);

  @override
  String toString() => 'UnknownExerciseKeyException: "$key" not found';
}

extension ExerciseL10n on AppLocalizations {
  ({String name, String description}) exerciseTranslation(String key) {
    switch (key) {
      case 'bench_press':
        return (name: db_seeds_benchPress, description: db_seeds_benchPressDesc);
      case 'lat_pulldown':
        return (name: db_seeds_LatPulldown, description: db_seeds_LatPulldownDesc);
      case 'overhead_press':
        return (name: db_seeds_overheadPress, description: db_seeds_overheadPressDesc);
      case 'seated_row':
        return (name: db_seeds_seatedRow, description: db_seeds_seatedRowDesc);
      case 'back_squat':
        return (name: db_seeds_backSquat, description: db_seeds_backSquatDesc);
      default:
        throw UnknownExerciseKeyException(key);
    }
  }
}
