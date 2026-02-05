import 'package:flutter_test/flutter_test.dart';
import 'package:jacked/src/db/models/exercise_entry.dart';
import 'package:jacked/src/db/models/exercise_set.dart';
import 'package:jacked/src/db/repositories/repositories.dart';
import 'package:jacked/src/widgets/pages/diary_page/workout_hydrator.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late Repositories repos;

  setUp(() {
    repos = Repositories(
      exerciseRepo: MockExerciseRepo(),
      exerciseEntryRepo: MockExerciseEntryRepo(),
      exerciseSetRepo: MockExerciseSetRepo(),
      workoutRepo: MockWorkoutRepo(),
    );
  });

  group('WorkoutHydrator', () {
    group('hydrateWorkout', () {
      test('no exercise entries', () async {
        // given - exercise entries
        when(() => repos.exerciseEntryRepo.listByWorkoutId(1)).thenAnswer(
          (_) async => <ExerciseEntry>[],
        );

        // when - the workout is hydrated
        final got = await WorkoutHydrator(
          repos: repos,
          workout: fixtureWorkout(),
        ).hydrateWorkout();

        expect(
          got,
          equals(
            fixtureWorkout((w) {
              return w.copyWith(exerciseEntries: <ExerciseEntry>[]);
            }),
          ),
        );
      });

      test('one exercise entry', () async {
        // given - an exercise entry
        when(() => repos.exerciseEntryRepo.listByWorkoutId(1)).thenAnswer(
          (_) async => <ExerciseEntry>[
            fixtureExerciseEntry((ee) => ee.copyWith(exercise: null, sets: null)),
          ],
        );

        // given - an exercise
        when(() => repos.exerciseRepo.get(1)).thenAnswer((_) async => fixtureExercise());

        // given - an exercise set
        when(
          () => repos.exerciseSetRepo.listByExerciseEntryId(1),
        ).thenAnswer((_) async => <ExerciseSet>[fixtureExerciseSet()]);

        // given - a previous exercise entry
        when(
          () => repos.exerciseEntryRepo.getMostRecentExerciseEntry(
            exerciseId: 1,
            startTime: fixtureWorkout().startTime,
          ),
        ).thenAnswer((_) async => fixtureExerciseEntry((ee) => ee.copyWith(id: 2, workoutId: 2)));

        // given - a previous exercise set
        when(
          () => repos.exerciseSetRepo.listByExerciseEntryId(2),
        ).thenAnswer((_) async => <ExerciseSet>[fixtureExerciseSet((es) => es.copyWith(id: 2))]);

        // when - the workout is hydrated
        final got = await WorkoutHydrator(
          repos: repos,
          workout: fixtureWorkout(),
        ).hydrateWorkout();

        expect(
          got,
          equals(
            fixtureWorkout((w) {
              return w.copyWith(
                exerciseEntries: <ExerciseEntry>[
                  fixtureExerciseEntry(
                    (ee) => ee.copyWith(
                      sets: <ExerciseSet>[fixtureExerciseSet()],
                      previousSets: <ExerciseSet>[fixtureExerciseSet((es) => es.copyWith(id: 2))],
                    ),
                  ),
                ],
              );
            }),
          ),
        );
      });
    });
  });
}
