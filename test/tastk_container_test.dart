import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/models/models.dart';
import 'package:task_manager/widgets/task_container.dart';

void main() {
  testWidgets('TaskContainer displays task details',
      (WidgetTester tester) async {
    final task = TaskModel(
      name: 'Sample Task',
      description: 'This is a sample task description',
      isCompleted: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskContainer(
            task: task,
            onChange: () {},
            onDelete: () {},
          ),
        ),
      ),
    );

    expect(find.text('Sample Task'), findsOneWidget);
    expect(find.text('This is a sample task description'), findsOneWidget);
    expect(find.byType(Checkbox), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);
  });

  testWidgets('TaskContainer calls onChange when checkbox is tapped',
      (WidgetTester tester) async {
    final task = TaskModel(
      name: 'Sample Task',
      description: 'This is a sample task description',
      isCompleted: false,
    );

    bool onChangeCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskContainer(
            task: task,
            onChange: () {
              onChangeCalled = true;
            },
            onDelete: () {},
          ),
        ),
      ),
    );

    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    expect(onChangeCalled, isTrue);
  });

  testWidgets('TaskContainer calls onDelete when delete icon is tapped',
      (WidgetTester tester) async {
    final task = TaskModel(
      name: 'Sample Task',
      description: 'This is a sample task description',
      isCompleted: false,
    );

    bool onDeleteCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskContainer(
            task: task,
            onChange: () {},
            onDelete: () {
              onDeleteCalled = true;
            },
          ),
        ),
      ),
    );

    // Tap the delete icon
    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pump();

    expect(onDeleteCalled, isTrue);
  });

  testWidgets('TaskContainer toggles checkbox state',
      (WidgetTester tester) async {
    TaskModel task = TaskModel(
      name: 'Sample Task',
      description: 'This is a sample task description',
      isCompleted: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return TaskContainer(
                task: task,
                onChange: () {
                  setState(() {
                    task.isCompleted = true;
                  });
                },
                onDelete: () {},
              );
            },
          ),
        ),
      ),
    );

    expect(find.byType(Checkbox), findsOneWidget);
    expect((tester.widget(find.byType(Checkbox)) as Checkbox).value, isFalse);

    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    expect((tester.widget(find.byType(Checkbox)) as Checkbox).value, isTrue);
  });
}
