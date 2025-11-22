import 'package:flutter_test/flutter_test.dart';
import 'package:jacked/src/db/models/exercise.dart';
import 'package:jacked/src/db/models/exercise_entry.dart';
import 'package:jacked/src/db/models/exercise_set.dart';
import 'package:jacked/src/db/models/workout.dart';
import 'package:jacked/src/widgets/pages/diary_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../../../test_config.dart';

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
        () => workoutSvc.list(),
      ).thenAnswer(
        (_) async => [
          Workout(id: 1, title: 'W1', startTime: DateTime.now()),
          Workout(id: 2, title: 'W2', startTime: DateTime.now()),
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
    testWidgets('DiaryEntry', (tester) async {
      when(
        () => exerciseSvc.get(1),
      ).thenAnswer(
        (_) async => const Exercise(id: 1, key: 'bench_press'),
      );
      when(
        () => exerciseEntrySvc.listByWorkoutId(1),
      ).thenAnswer((_) async => [const ExerciseEntry(id: 1, workoutId: 1, exerciseId: 1)]);
      when(
        () => exerciseSetSvc.listByExerciseEntryId(1),
      ).thenAnswer((_) async => [const ExerciseSet(exerciseEntryId: 1, reps: 1, weight: 1.0)]);
      await tester.pumpWidget(
        makeTestApp(
          DiaryEntry(
            exerciseEntrySvc: exerciseEntrySvc,
            exerciseSetSvc: exerciseSetSvc,
            exerciseSvc: exerciseSvc,
            workout: Workout(id: 1, title: 'W1', startTime: DateTime.now()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Bench Press'), findsOneWidget);
      // when - the diary entry is tapped
      await tester.tap(find.byType(DiaryEntry));
      await tester.pumpAndSettle();

      // then - a modal bottom sheet was opened
      expect(find.byType(DiaryEntryDetails), findsExactly(1));
    });
  });
}
