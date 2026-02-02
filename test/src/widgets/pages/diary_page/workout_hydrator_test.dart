import 'package:flutter_test/flutter_test.dart';
import 'package:jacked/src/db/models/exercise_entry.dart';
import 'package:jacked/src/db/models/exercise_set.dart';
import 'package:jacked/src/widgets/pages/diary_page/workout_hydrator.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late MockExerciseService exerciseSvc;
  late MockExerciseEntryService exerciseEntrySvc;
  late MockExerciseSetService exerciseSetSvc;

  setUp(() {
    exerciseSvc = MockExerciseService();
    exerciseEntrySvc = MockExerciseEntryService();
    exerciseSetSvc = MockExerciseSetService();
  });

  group('WorkoutHydrator', () {
    group('hydrateWorkout', () {
      test('no exercise entries', () async {
        // given - exercise entries
        when(() => exerciseEntrySvc.listByWorkoutId(1)).thenAnswer(
          (_) async => <ExerciseEntry>[],
        );

        // when - the workout is hydrated
        final got = await WorkoutHydrator(
          workout: fixtureWorkout(),
          exerciseEntrySvc: exerciseEntrySvc,
          exerciseSetSvc: exerciseSetSvc,
          exerciseSvc: exerciseSvc,
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
        when(() => exerciseEntrySvc.listByWorkoutId(1)).thenAnswer(
          (_) async => <ExerciseEntry>[
            fixtureExerciseEntry((ee) => ee.copyWith(exercise: null, sets: null)),
          ],
        );

        // given - an exercise
        when(() => exerciseSvc.get(1)).thenAnswer((_) async => fixtureExercise());

        // given - an exercise set
        when(
          () => exerciseSetSvc.listByExerciseEntryId(1),
        ).thenAnswer((_) async => <ExerciseSet>[fixtureExerciseSet()]);

        // given - a previous exercise entry
        when(
          () => exerciseEntrySvc.getMostRecentExerciseEntry(
            exerciseId: 1,
            startTime: fixtureWorkout().startTime,
          ),
        ).thenAnswer((_) async => fixtureExerciseEntry((ee) => ee.copyWith(id: 2, workoutId: 2)));

        // given - a previous exercise set
        when(
          () => exerciseSetSvc.listByExerciseEntryId(2),
        ).thenAnswer((_) async => <ExerciseSet>[fixtureExerciseSet((es) => es.copyWith(id: 2))]);

        // when - the workout is hydrated
        final got = await WorkoutHydrator(
          workout: fixtureWorkout(),
          exerciseEntrySvc: exerciseEntrySvc,
          exerciseSetSvc: exerciseSetSvc,
          exerciseSvc: exerciseSvc,
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
