import 'package:flutter_test/flutter_test.dart';
import 'package:jacked/src/db/models/exercise_entry.dart';
import 'package:jacked/src/db/models/workout.dart';

import '../../../../fixtures.dart';

void main() {
  setUp();
  group('WorkoutHydrator', () {
    group('hydrateWorkout()', () {
      setUp(() {
        reset(workoutSvc);
      });

      final inputs = [
        {
          'name': 'no exercise entries',
          'workout': fixtureWorkout(),
          'exerciseEntries': <ExerciseEntry>[],
          'want': fixtureWorkout((w) {
            return w.copyWith(exerciseEntries: <ExerciseEntry>[]);
          }),
        },
        {
          'name': 'one exercise entry',
          'workout': fixtureWorkout(),
          'exerciseEntries': <ExerciseEntry>[
            fixtureExerciseEntry(),
          ],
          'want': fixtureWorkout((w) {
            return w.copyWith(
              exerciseEntries: <ExerciseEntry>[
                fixtureExerciseEntry(),
              ],
            );
          }),
        },
        {
          'name': 'two exercise entries',
          'workout': fixtureWorkout(),
          'exerciseEntries': <ExerciseEntry>[
            fixtureExerciseEntry(),
            fixtureExerciseEntry((w) {
              return w.copyWith(id: 2);
            }),
          ],
          'want': fixtureWorkout((w) {
            return w.copyWith(
              exerciseEntries: <ExerciseEntry>[
                fixtureExerciseEntry(),
                fixtureExerciseEntry((w) {
                  return w.copyWith(id: 2);
                }),
              ],
            );
          }),
        },
      ];
      for (var {
            'name': name as String,
            'workout': workout as Workout,
            'exerciseEntries': exerciseEntries as List<ExerciseEntry>,
            'want': want as Workout,
          }
          in inputs) {
        test(
          name,
          () async {
            // given - exercise entries
            Future<List<ExerciseEntry>> listExerciseEntriesMock() =>
                exerciseEntrySvc.listByWorkoutId(1);
            when(listExerciseEntriesMock).thenAnswer((_) async => exerciseEntries);

            // and - exercise sets
            for (final entry in exerciseEntries) {
              when(() => exerciseSvc.get(entry.exerciseId)).thenAnswer((_) async => entry.exercise);
              when(
                () => exerciseSetSvc.listByExerciseEntryId(entry.id!),
              ).thenAnswer((_) async => entry.sets!);
            }

            // when - loadWorkoutData is called
            final got = await loadWorkoutData(workout, exerciseEntrySvc, exerciseSvc, exerciseSetSvc);

            // then - the exercise entries are listed
            verify(listExerciseEntriesMock).called(1);

            // and - the workout was populated
            expect(got, equals(want));
          },
        );
      }
    });
  })
}
