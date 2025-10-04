import 'package:jacked/src/db/models/exercise.dart';
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
  ),
  Workout(
    title: 'Test Workout 2',
    startTime: DateTime(2025, 9, 9, 7, 30),
    endTime: DateTime(2025, 9, 9, 8, 15),
  ),
  Workout(
    title: 'Test Workout 3',
    startTime: DateTime(2025, 9, 10, 12, 0),
    endTime: DateTime(2025, 9, 10, 12, 45),
  ),
  Workout(
    title: 'Test Workout 4',
    startTime: DateTime(2025, 9, 11, 17, 15),
    endTime: DateTime(2025, 9, 11, 18, 0),
  ),
  Workout(
    title: 'Test Workout 5',
    startTime: DateTime(2025, 9, 12, 6, 0),
    endTime: DateTime(2025, 9, 12, 6, 50),
  ),
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
