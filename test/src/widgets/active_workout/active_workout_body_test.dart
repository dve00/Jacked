import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jacked/src/db/models/exercise.dart';
import 'package:jacked/src/widgets/active_workout/active_workout_body.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../../../test_config.dart';

void main() {
  late MockExerciseService exerciseSvc;

  setUp(() {
    exerciseSvc = MockExerciseService();
  });

  group('Active Workout Body', () {
    testWidgets('adding exercise adds form', (tester) async {
      // given - an exercise
      when(
        () => exerciseSvc.list(),
      ).thenAnswer((_) async => <Exercise>[const Exercise(id: 1, key: 'bench_press')]);

      // when - an active workout body is pumped
      await tester.pumpWidget(
        makeTestApp(
          ActiveWorkoutBody(
            exerciseSvc: exerciseSvc,
            onCancelWorkout: () {},
            onSaveWorkout: () {},
          ),
        ),
      );

      // then - the add exercise and cancel workout buttons are shown
      expect(find.widgetWithText(ElevatedButton, 'Add Exercise'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Cancel Workout'), findsOneWidget);

      // when - the add exercise button is tapped
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add Exercise'));
      await tester.pumpAndSettle();

      // then - a dialog is opened
      expect(find.byType(Dialog), findsOneWidget);

      // and - a list of exercises is displayed
      expect(find.byType(ListTile), findsOneWidget);

      // when - the bench press exercise is tapped
      await tester.tap(find.widgetWithText(ListTile, 'Bench Press'));
      await tester.pump();

      // then - a form with a text form field is shown
      expect(find.byType(Form), findsExactly(1));
      expect(find.byType(TextFormField), findsExactly(1));
    });
  });
}
