import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:task_manager/models/models.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'mocks.mocks.dart';

void main() {
  late MockTaskService mockTaskService;
  late MockConnectivityService mockConnectivityService;
  late MockBuildContext mockBuildContext;
  late TaskProvider taskProvider;

  setUp(() {
    mockTaskService = MockTaskService();
    mockConnectivityService = MockConnectivityService();
    mockBuildContext = MockBuildContext();
    taskProvider = TaskProvider();
  });

  group('TaskProvider', () {
    test('should fetch tasks from Firebase when online', () async {
      when(mockConnectivityService.checkStatus()).thenAnswer((_) async => true);
      when(mockTaskService.getTaskRealtime()).thenAnswer((_) async => Stream.value([
        TaskModel(name: 'Task 1', description: 'Description 1', isCompleted: false),
        TaskModel(name: 'Task 2', description: 'Description 2', isCompleted: true),
      ]));

      await taskProvider.listenToTasks();

      expect(taskProvider.tasks.length, 2);
      expect(taskProvider.tasks[0].name, 'Task 1');
      expect(taskProvider.tasks[1].name, 'Task 2');
    });

    test('should fetch tasks from local storage when offline', () async {
      when(mockConnectivityService.checkStatus()).thenAnswer((_) async => false);
      when(GetStorage().read('tasks')).thenReturn([
        {'name': 'Task 1', 'description': 'Description 1', 'isCompleted': false},
        {'name': 'Task 2', 'description': 'Description 2', 'isCompleted': true},
      ]);

      await taskProvider.listenToTasks();

      expect(taskProvider.tasks.length, 2);
      expect(taskProvider.tasks[0].name, 'Task 1');
      expect(taskProvider.tasks[1].name, 'Task 2');
    });

    test('should add task to Firebase when online', () async {
      when(mockConnectivityService.checkStatus()).thenAnswer((_) async => true);
      when(mockTaskService.createTask(any)).thenAnswer((_) async => true);

      final task = TaskModel(name: 'New Task', description: 'New Description', isCompleted: false);
      await taskProvider.addTask(task, mockBuildContext);

      verify(mockTaskService.createTask(task)).called(1);
      expect(taskProvider.tasks.contains(task), isTrue);
    });

    test('should add task to local storage when offline', () async {
      when(mockConnectivityService.checkStatus()).thenAnswer((_) async => false);

      final task = TaskModel(name: 'New Task', description: 'New Description', isCompleted: false);
      await taskProvider.addTask(task, mockBuildContext);

      expect(taskProvider.tasks.contains(task), isTrue);
      final storedTasks = GetStorage().read('tasks') as List;
      expect(storedTasks.any((t) => t['name'] == 'New Task'), isTrue);
    });

    test('should remove task from Firebase when online', () async {
      when(mockConnectivityService.checkStatus()).thenAnswer((_) async => true);
      when(mockTaskService.deleteTask(any)).thenAnswer((_) async => true);

      final task = TaskModel(name: 'Task to Delete', description: 'Description', isCompleted: false);
      taskProvider.tasks.add(task);
      await taskProvider.removeTask(task, mockBuildContext);

      verify(mockTaskService.deleteTask(task.id!)).called(1);
      expect(taskProvider.tasks.contains(task), isFalse);
    });

    test('should update task in Firebase when online', () async {
      when(mockConnectivityService.checkStatus()).thenAnswer((_) async => true);
      when(mockTaskService.updateTask(any)).thenAnswer((_) async => true);

      final task = TaskModel(name: 'Task to Update', description: 'Description', isCompleted: false);
      taskProvider.tasks.add(task);
      task.name = 'Updated Task';
      await taskProvider.updateTask(task, mockBuildContext);

      verify(mockTaskService.updateTask(task)).called(1);
      expect(taskProvider.tasks.any((t) => t.name == 'Updated Task'), isTrue);
    });
  });
}