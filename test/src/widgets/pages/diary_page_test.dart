import 'package:flutter_test/flutter_test.dart';
import 'package:jacked/src/db/models/exercise.dart';
import 'package:jacked/src/db/models/exercise_entry.dart';
import 'package:jacked/src/db/models/workout.dart';
import 'package:jacked/src/db/service_provider.dart';
import 'package:jacked/src/widgets/pages/diary_page.dart';
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
  });

  group('Diary Page', () {
    testWidgets('has workout list', (tester) async {
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
      when(
        () => workoutSvc.list(),
      ).thenAnswer(
        (_) async => [
          Workout(id: 1, title: 'W1', startTime: DateTime.now()),
          Workout(id: 2, title: 'W2', startTime: DateTime.now()),
        ],
      );
      when(
        () => exerciseEntrySvc.listByWorkoutId(1),
      ).thenAnswer((_) async => [const ExerciseEntry(id: 1, workoutId: 1, exerciseId: 1)]);
      when(
        () => exerciseEntrySvc.listByWorkoutId(2),
      ).thenAnswer((_) async => [const ExerciseEntry(id: 2, workoutId: 2, exerciseId: 2)]);
      await tester.pumpWidget(
        ServiceProvider(
          exerciseService: exerciseSvc,
          workoutService: workoutSvc,
          exerciseEntryService: exerciseEntrySvc,
          child: makeTestApp(const DiaryPage()),
        ),
      );
      await tester.pumpAndSettle();
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
      await tester.pumpWidget(
        ServiceProvider(
          exerciseService: exerciseSvc,
          workoutService: workoutSvc,
          exerciseEntryService: exerciseEntrySvc,
          child: makeTestApp(
            DiaryEntry(
              workout: Workout(id: 1, title: 'W1', startTime: DateTime.now()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Bench Press'), findsOneWidget);
    });
  });
}
