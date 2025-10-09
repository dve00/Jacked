import 'package:flutter_test/flutter_test.dart';
import 'package:jacked/src/db/models/exercise.dart';
import 'package:jacked/src/db/service_provider.dart';
import 'package:jacked/src/widgets/pages/exercises_page.dart';
import 'package:jacked/src/widgets/shared/exercise_list.dart';
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

  group('ExercisePage', () {
    testWidgets('has exercise list', (tester) async {
      when(() => exerciseSvc.list()).thenAnswer((_) async => [const Exercise(key: 'bench_press')]);
      await tester.pumpWidget(
        ServiceProvider(
          exerciseService: exerciseSvc,
          workoutService: workoutSvc,
          exerciseEntryService: exerciseEntrySvc,
          child: makeTestApp(const ExercisesPage()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ExerciseList), findsOneWidget);
      expect(find.text('Bench Press'), findsOneWidget);
    });
  });
}
