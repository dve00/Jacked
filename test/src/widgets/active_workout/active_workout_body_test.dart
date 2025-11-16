import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jacked/src/db/models/exercise.dart';
import 'package:jacked/src/db/models/exercise_entry.dart';
import 'package:jacked/src/db/models/workout.dart';
import 'package:jacked/src/widgets/active_workout/active_workout_body.dart';
import 'package:jacked/src/widgets/shared/widgets/jacked_button.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../../../test_config.dart';

void main() {
  late MockExerciseService exerciseSvc;
  late MockWorkoutService workoutSvc;
  late MockExerciseEntryService exerciseEntrySvc;

  setUp(() {
    exerciseSvc = MockExerciseService();
    workoutSvc = MockWorkoutService();
    exerciseEntrySvc = MockExerciseEntryService();
    registerFallbackValue(Workout(title: 'New Workout', startTime: DateTime.now()));
    registerFallbackValue(const ExerciseEntry(workoutId: 1, exerciseId: 1));
  });

  group('saveWorkout()', () {
    tearDown(() {
      reset(workoutSvc);
    });

    final inputs = [
      {
        'name': 'empty',
        'formData': <ExerciseFormData>[],
        'wantError': false,
      },
      {
        'name': 'one ExerciseEntry',
        'formData': <ExerciseFormData>[
          ExerciseFormData(
            exercise: const Exercise(id: 1, key: 'bench_press'),
            key: GlobalKey<FormState>(),
          ),
        ],
        'wantError': false,
      },
      {
        'name': 'multiple ExerciseEntries',
        'formData': <ExerciseFormData>[
          ExerciseFormData(
            exercise: const Exercise(id: 1, key: 'bench_press'),
            key: GlobalKey<FormState>(),
          ),
          ExerciseFormData(
            exercise: const Exercise(id: 2, key: 'back_squat'),
            key: GlobalKey<FormState>(),
          ),
        ],
        'wantError': false,
      },
      {
        'name': 'throws - no exercise id',
        'formData': <ExerciseFormData>[
          ExerciseFormData(
            exercise: const Exercise(key: 'bench_press'),
            key: GlobalKey<FormState>(),
          ),
        ],
        'wantError': true,
      },
    ];
    for (var {
          'name': name as String,
          'formData': formData as List<ExerciseFormData>,
          'wantError': wantError as bool,
        }
        in inputs) {
      test('saveWorkout() - $name', () async {
        // given - a workout id
        Future<int> saveWorkoutMock() => workoutSvc.create(any());
        when(saveWorkoutMock).thenAnswer((_) async => 1);

        // and - an exercise entry id
        Future<int> saveExerciseEntryMock() => exerciseEntrySvc.create(any());
        when(saveExerciseEntryMock).thenAnswer((_) async => 1);

        // when - saveWorkout is called
        final res = await saveWorkout(workoutSvc, exerciseEntrySvc, formData);

        // then - the workout is saved
        verify(saveWorkoutMock).called(1);

        // and - all exercise entries are saved;
        if (formData.isEmpty || wantError) {
          verifyNever(saveExerciseEntryMock);
        } else {
          verify(saveExerciseEntryMock).called(formData.length);
        }

        // and - the result is true on success and false on fail
        expect(res, !wantError);
      });
    }
  });

  group('ActiveWorkoutBody', () {
    tearDown(() {
      reset(exerciseSvc);
    });

    testWidgets('adding exercise without id shows error dialog', (tester) async {
      // given - an exercise without id
      when(
        () => exerciseSvc.list(),
      ).thenAnswer(
        (_) async => <Exercise>[
          const Exercise(
            key: 'bench_press',
          ),
        ],
      );

      // and - a workout id
      when(() => workoutSvc.create(any())).thenAnswer((_) async => 1);

      // when - an active workout body is pumped
      await tester.pumpWidget(
        makeTestApp(
          ActiveWorkoutBody(
            exerciseSvc: exerciseSvc,
            workoutSvc: workoutSvc,
            exerciseEntrySvc: exerciseEntrySvc,
            onCancelWorkout: () {},
            onSaveWorkout: () {},
          ),
        ),
      );

      // when - the add exercise button is tapped
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add Exercise'));
      await tester.pumpAndSettle();

      // then - a dialog is opened
      expect(find.byType(Dialog), findsOneWidget);

      // and - a list of exercises is displayed
      expect(find.byType(ListTile), findsOneWidget);

      // when - the bench press exercise is tapped
      await tester.tap(find.widgetWithText(ListTile, 'Bench Press'));
      await tester.pumpAndSettle();

      // and - the save workout button is tapped
      await tester.tap(find.widgetWithText(JackedButton, 'Save Workout'));
      await tester.pumpAndSettle();

      // then - An alert dialog is shown
      expect(find.widgetWithText(Dialog, 'Saving Workout Failed!'), findsOneWidget);
    });

    testWidgets('adding exercise adds form', (tester) async {
      // given - an exercise
      when(
        () => exerciseSvc.list(),
      ).thenAnswer(
        (_) async => <Exercise>[
          const Exercise(
            id: 1,
            key: 'bench_press',
          ),
        ],
      );

      // and - a workout id
      Future<int> createWorkoutMock() => workoutSvc.create(any());
      when(createWorkoutMock).thenAnswer((_) async => 1);

      // and - an exercise entry id
      Future<int> createExerciseEntryMock() =>
          exerciseEntrySvc.create(const ExerciseEntry(workoutId: 1, exerciseId: 1));
      when(createExerciseEntryMock).thenAnswer((_) async => 1);

      // when - an active workout body is pumped
      await tester.pumpWidget(
        makeTestApp(
          ActiveWorkoutBody(
            exerciseSvc: exerciseSvc,
            workoutSvc: workoutSvc,
            exerciseEntrySvc: exerciseEntrySvc,
            onCancelWorkout: () {},
            onSaveWorkout: () {},
          ),
        ),
      );

      // then - all buttons are shown
      expect(find.widgetWithText(ElevatedButton, 'Add Exercise'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Cancel Workout'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Save Workout'), findsOneWidget);

      // when - the add exercise button is tapped
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add Exercise'));
      await tester.pumpAndSettle();

      // then - a dialog is opened
      expect(find.byType(Dialog), findsOneWidget);

      // and - a list of exercises is displayed
      expect(find.byType(ListTile), findsOneWidget);

      // when - the bench press exercise is tapped
      await tester.tap(find.widgetWithText(ListTile, 'Bench Press'));
      await tester.pumpAndSettle();

      // then - a form with a text form field is shown
      expect(find.byType(Form), findsExactly(1));
      expect(find.byType(TextFormField), findsExactly(1));

      // when - the save workout button is tapped
      await tester.tap(find.widgetWithText(JackedButton, 'Save Workout'));
      await tester.pumpAndSettle();

      // then - the workout is saved
      verify(createWorkoutMock).called(1);
      verify(createExerciseEntryMock).called(1);
    });
  });
}
