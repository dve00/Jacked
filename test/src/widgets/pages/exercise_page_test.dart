import 'package:flutter_test/flutter_test.dart';
import 'package:jacked/src/widgets/pages/exercises_page.dart';
import 'package:jacked/src/widgets/shared/widgets/exercise_list.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures.dart';
import '../../../mocks.dart';
import '../../../test_config.dart';

void main() {
  late MockExerciseService exerciseRepo;

  setUp(() {
    exerciseRepo = MockExerciseService();
  });

  group('ExercisePage', () {
    testWidgets('has exercise list', (tester) async {
      when(() => exerciseRepo.list()).thenAnswer((_) async => [fixtureExercise()]);
      await tester.pumpWidget(
        makeTestApp(
          ExercisesPage(
            exerciseRepo: exerciseRepo,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ExerciseList), findsOneWidget);
      expect(find.text('Bench Press'), findsOneWidget);
    });
  });
}
