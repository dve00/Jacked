import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jacked/src/db/models/exercise.dart';
import 'package:jacked/src/db/models/exercise_entry.dart';
import 'package:jacked/src/db/models/exercise_set.dart';
import 'package:jacked/src/db/models/workout.dart';
import 'package:jacked/src/widgets/pages/diary_page/diary_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks.dart';
import '../../../../test_config.dart';

void main() {
  late MockExerciseService exerciseSvc;
  late MockWorkoutService workoutSvc;
  late MockExerciseEntryService exerciseEntrySvc;
  late MockExerciseSetService exerciseSetSvc;

  setUp(() {
    exerciseSvc = MockExerciseService();
    workoutSvc = MockWorkoutService();
    exerciseEntrySvc = MockExerciseEntryService();
    exerciseSetSvc = MockExerciseSetService();
  });

  group('Diary Page', () {
    testWidgets('has workout list', (tester) async {
      // given - two exercises
      when(
        () => exerciseSvc.get(1),
      ).thenAnswer(
        (_) async => const Exercise(id: 1, key: 'bench_press'),
      );
      when(
        () => exerciseSvc.get(2),
      ).thenAnswer(
        (_) async => const Exercise(id: 2, key: 'lat_pulldown'),
      );

      // and - two workouts
      when(
        () => workoutSvc.list(orderBy: 'startTime desc'),
      ).thenAnswer(
        (_) async => [
          Workout(id: 1, title: 'W1', startTime: DateTime(2025, 11, 27)),
          Workout(id: 2, title: 'W2', startTime: DateTime(2025, 11, 28)),
        ],
      );

      // and - two exercise entries
      when(
        () => exerciseEntrySvc.listByWorkoutId(1),
      ).thenAnswer((_) async => [const ExerciseEntry(id: 1, workoutId: 1, exerciseId: 1)]);
      when(
        () => exerciseEntrySvc.listByWorkoutId(2),
      ).thenAnswer((_) async => [const ExerciseEntry(id: 2, workoutId: 2, exerciseId: 2)]);

      // when - the widget is pumped
      await tester.pumpWidget(
        makeTestApp(
          DiaryPage(
            exerciseEntrySvc: exerciseEntrySvc,
            exerciseSetSvc: exerciseSetSvc,
            exerciseSvc: exerciseSvc,
            workoutSvc: workoutSvc,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // then - there are two diary entries
      expect(find.byType(DiaryEntry), findsExactly(2));
    });

    group('DiaryEntry', () {
      final startTime = DateTime(2025, 12, 4);
      testWidgets('shows previous and opens details on tap', (tester) async {
        // given - an exercise
        when(
          () => exerciseSvc.get(1),
        ).thenAnswer(
          (_) async => const Exercise(id: 1, key: 'bench_press'),
        );

        // and - an exercise entry
        when(
          () => exerciseEntrySvc.listByWorkoutId(1),
        ).thenAnswer((_) async => [const ExerciseEntry(id: 1, workoutId: 1, exerciseId: 1)]);

        // and - a previous exercise entry
        when(
          () => exerciseEntrySvc.getMostRecentExerciseEntry(exerciseId: 1, startTime: startTime),
        ).thenAnswer((_) async => null);

        // and - an exercise set
        when(
          () => exerciseSetSvc.listByExerciseEntryId(1),
        ).thenAnswer((_) async => [const ExerciseSet(exerciseEntryId: 1, reps: 1, weight: 1.0)]);

        // when - the widget is pumped
        await tester.pumpWidget(
          makeTestApp(
            DiaryEntry(
              exerciseEntrySvc: exerciseEntrySvc,
              exerciseSetSvc: exerciseSetSvc,
              exerciseSvc: exerciseSvc,
              workout: Workout(id: 1, title: 'W1', startTime: startTime),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // then - a row for the bench press exercise is found with correct preview
        expect(find.text('Bench Press 1.0kg x 1'), findsOneWidget);

        // when - the diary entry is tapped
        await tester.tap(find.byKey(const Key('diary_entry')));
        await tester.pumpAndSettle();

        // then - a modal bottom sheet is opened
        expect(find.byType(DiaryEntryDetails), findsExactly(1));
      });
    });
  });

  group('getSetRows()', () {
    final inputs = [
      {
        'name': 'null',
        'sets': null,
        'previousSets': null,
        'want': 0,
      },
      {
        'name': 'empty',
        'sets': <ExerciseSet>[],
        'previousSets': <ExerciseSet>[],
        'want': 0,
      },
      {
        'name': 'one set',
        'sets': <ExerciseSet>[
          fixtureExerciseSet(),
        ],
        'previousSets': <ExerciseSet>[
          fixtureExerciseSet(),
        ],
        'want': 1,
      },
      {
        'name': 'two sets',
        'sets': <ExerciseSet>[
          fixtureExerciseSet(),
          fixtureExerciseSet(),
        ],
        'previousSets': <ExerciseSet>[
          fixtureExerciseSet(),
          fixtureExerciseSet(),
        ],
        'want': 3,
      },
    ];
    for (var {
          'name': name as String,
          'sets': sets as List<ExerciseSet>?,
          'previousSets': previousSets as List<ExerciseSet>?,
          'want': want as int,
        }
        in inputs) {
      test(name, () {
        expect(getSetRows(sets, previousSets, 'en').length, equals(want));
      });
    }
  });

  group('getExercisePreviewRow()', () {
    final input = [
      {
        'name': 'null',
        'entries': null,
        'want': <ExercisePreview>[],
      },
      {
        'name': 'empty entries',
        'entries': <ExerciseEntry>[],
        'want': <ExercisePreview>[],
      },
      {
        'name': 'one entry',
        'entries': <ExerciseEntry>[
          fixtureExerciseEntry(),
        ],
        'want': <ExercisePreview>[
          const ExercisePreview(
            key: 'bench_press',
            displaySet: '20.0kg x 8',
          ),
        ],
      },
      {
        'name': 'two entries',
        'entries': <ExerciseEntry>[
          fixtureExerciseEntry(),
          fixtureExerciseEntry(),
        ],
        'want': <ExercisePreview>[
          const ExercisePreview(
            key: 'bench_press',
            displaySet: '20.0kg x 8',
          ),
          const ExercisePreview(
            key: 'bench_press',
            displaySet: '20.0kg x 8',
          ),
        ],
      },
    ];
    for (var {
          'name': name as String,
          'entries': entries as List<ExerciseEntry>?,
          'want': want as List<ExercisePreview>,
        }
        in input) {
      test(name, () {
        expect(getExercisePreviews(entries), want);
      });
    }
  });
}
