import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jacked/src/widgets/shared/widgets/jacked_button.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../test_config.dart';

class MockCallback extends Mock {
  void call();
}

void main() {
  group('JackedButton', () {
    testWidgets('JackedButton calls onPressed', (tester) async {
      final mockCallback = MockCallback();

      await tester.pumpWidget(
        makeTestApp(JackedButton(label: 'Press Me', onPressed: mockCallback.call)),
      );

      expect(find.text('Press Me'), findsOneWidget);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      verify(mockCallback.call).called(1);
    });
  });
}
