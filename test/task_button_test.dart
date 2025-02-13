import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/widgets/task_button.dart';

void main() {
  testWidgets('TaskButton displays the correct label',
      (WidgetTester tester) async {
    const label = 'Create task';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskButton(
            onPressed: () {},
            label: label,
          ),
        ),
      ),
    );

    expect(find.text(label), findsOneWidget);
  });

  testWidgets('TaskButton calls onPressed when tapped',
      (WidgetTester tester) async {
    bool wasPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskButton(
            onPressed: () {
              wasPressed = true;
            },
            label: 'Create task button',
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(wasPressed, isTrue);
  });
}
