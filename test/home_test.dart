import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/models/models.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/screens/home.dart';
import 'package:task_manager/screens/new_task.dart';
import 'package:task_manager/utils/routes.dart';

void main() {
  testWidgets('Home screen displays tasks', (WidgetTester tester) async {
    final taskProvider = TaskProvider();
    taskProvider.tasks = [
      TaskModel(
        name: 'Task 1',
        description: 'Description 1',
        isCompleted: false,
        createdAt: DateTime.now(),
        isPendingToCreate: false,
        isPendingToUpdate: false,
      ),
      TaskModel(
        name: 'Task 2',
        description: 'Description 2',
        isCompleted: true,
        createdAt: DateTime.now(),
        isPendingToCreate: false,
        isPendingToUpdate: false,
      ),
    ];

    await tester.pumpWidget(
      ChangeNotifierProvider<TaskProvider>.value(
        value: taskProvider,
        child: const MaterialApp(
          home: Home(),
        ),
      ),
    );

    expect(find.text('Task 1'), findsOneWidget);
    expect(find.text('Task 2'), findsOneWidget);
  });

  testWidgets('Home screen navigates to new task screen',
      (WidgetTester tester) async {
    final taskProvider = TaskProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<TaskProvider>.value(
        value: taskProvider,
        child: MaterialApp(
          home: const Home(),
          routes: {
            Routes.newTask: (context) => const NewTask(),
          },
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
  });
}
