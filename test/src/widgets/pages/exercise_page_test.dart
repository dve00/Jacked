import 'package:flutter_test/flutter_test.dart';
import 'package:jacked/src/db/repositories/repositories.dart';
import 'package:jacked/src/widgets/pages/exercises_page.dart';
import 'package:jacked/src/widgets/shared/widgets/exercise_list.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures.dart';
import '../../../mocks.dart';
import '../../../test_config.dart';

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

  group('ExercisePage', () {
    testWidgets('has exercise list', (tester) async {
      when(() => repos.exerciseRepo.list()).thenAnswer((_) async => [fixtureExercise()]);
      await tester.pumpWidget(
        makeTestApp(
          ExercisesPage(
            repos: repos,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ExerciseList), findsOneWidget);
      expect(find.text('Bench Press'), findsOneWidget);
    });
  });
}
