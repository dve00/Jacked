import 'package:flutter_test/flutter_test.dart';
import 'package:jacked/src/db/models/exercise_entry.dart';
import 'package:jacked/src/db/models/exercise_set.dart';
import 'package:jacked/src/widgets/pages/diary_page/workout_hydrator.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late MockExerciseService exerciseRepo;
  late MockExerciseEntryService exerciseEntryRepo;
  late MockExerciseSetService exerciseSetRepo;

  setUp(() {
    exerciseRepo = MockExerciseService();
    exerciseEntryRepo = MockExerciseEntryService();
    exerciseSetRepo = MockExerciseSetService();
  });

  group('WorkoutHydrator', () {
    group('hydrateWorkout', () {
      test('no exercise entries', () async {
        // given - exercise entries
        when(() => exerciseEntryRepo.listByWorkoutId(1)).thenAnswer(
          (_) async => <ExerciseEntry>[],
        );

        // when - the workout is hydrated
        final got = await WorkoutHydrator(
          workout: fixtureWorkout(),
          exerciseEntryRepo: exerciseEntryRepo,
          exerciseSetRepo: exerciseSetRepo,
          exerciseRepo: exerciseRepo,
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
        when(() => exerciseEntryRepo.listByWorkoutId(1)).thenAnswer(
          (_) async => <ExerciseEntry>[
            fixtureExerciseEntry((ee) => ee.copyWith(exercise: null, sets: null)),
          ],
        );

        // given - an exercise
        when(() => exerciseRepo.get(1)).thenAnswer((_) async => fixtureExercise());

        // given - an exercise set
        when(
          () => exerciseSetRepo.listByExerciseEntryId(1),
        ).thenAnswer((_) async => <ExerciseSet>[fixtureExerciseSet()]);

        // given - a previous exercise entry
        when(
          () => exerciseEntryRepo.getMostRecentExerciseEntry(
            exerciseId: 1,
            startTime: fixtureWorkout().startTime,
          ),
        ).thenAnswer((_) async => fixtureExerciseEntry((ee) => ee.copyWith(id: 2, workoutId: 2)));

        // given - a previous exercise set
        when(
          () => exerciseSetRepo.listByExerciseEntryId(2),
        ).thenAnswer((_) async => <ExerciseSet>[fixtureExerciseSet((es) => es.copyWith(id: 2))]);

        // when - the workout is hydrated
        final got = await WorkoutHydrator(
          workout: fixtureWorkout(),
          exerciseEntryRepo: exerciseEntryRepo,
          exerciseSetRepo: exerciseSetRepo,
          exerciseRepo: exerciseRepo,
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
