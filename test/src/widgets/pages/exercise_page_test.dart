import 'package:flutter_test/flutter_test.dart';
import 'package:jacked/src/db/models/exercise.dart';
import 'package:jacked/src/db/service_provider.dart';
import 'package:jacked/src/widgets/pages/exercises_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../../../test_config.dart';

void main() {
  late MockExerciseService svc;

  setUp(() {
    svc = MockExerciseService();
  });

  group('ExercisePage', () {
    testWidgets('has exercise list', (tester) async {
      when(() => svc.list()).thenAnswer((_) async => [const Exercise(key: 'bench_press')]);
      await tester.pumpWidget(
        ServiceProvider(
          exerciseService: svc,
          child: makeTestApp(const ExercisesPage()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ExerciseList), findsOneWidget);
      expect(find.text('Bench Press'), findsOneWidget);
    });
  });
}
