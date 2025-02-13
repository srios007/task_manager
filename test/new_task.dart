import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/screens/new_task.dart';

void main() {
  testWidgets('New task screen displays form fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<TaskProvider>(
        create: (_) => TaskProvider(),
        child: const MaterialApp(
          home: NewTask(),
        ),
      ),
    );

    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
  });

  testWidgets('New task screen creates a task', (WidgetTester tester) async {
    final taskProvider = TaskProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<TaskProvider>.value(
        value: taskProvider,
        child: const MaterialApp(
          home: NewTask(),
        ),
      ),
    );

    await tester.enterText(find.byKey(const Key('titleField')), 'New Task');
    await tester.enterText(
        find.byKey(const Key('descriptionField')), 'New Description');

    await tester.tap(find.text('Create task'));
    await tester.pumpAndSettle();

    expect(taskProvider.tasks.length, 1);
    expect(taskProvider.tasks[0].name, 'New Task');
    expect(taskProvider.tasks[0].description, 'New Description');
  });
}
