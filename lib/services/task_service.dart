import 'package:firebase_database/firebase_database.dart';

import '../models/models.dart';

class TaskService {
  factory TaskService() {
    return _instance;
  }

  TaskService._internal();
  static final TaskService _instance = TaskService._internal();

  final taskReference = FirebaseDatabase.instance.ref().child('tasks');

  Stream<List<TaskModel>> getTaskRealtime() {
    return taskReference.onValue.map((event) {
      if (event.snapshot.value == null) {
        return <TaskModel>[];
      }
      final data = Map<Object?, Object?>.from(event.snapshot.value as Map);
      final tasks = data.entries.map((entry) {
        final task =
            TaskModel.fromJson(Map<String, dynamic>.from(entry.value as Map));
        task.id = entry.key as String?;
        return task;
      }).toList();
      return tasks;
    });
  }

  Future<bool> createTask(TaskModel task) async {
    try {
      final newTaskRef = taskReference.push();
      await newTaskRef.set(task.toJson());
      task.id = newTaskRef.key;
      await newTaskRef.update({'id': task.id});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateTask(TaskModel task) async {
    try {
      final taskRef = taskReference.child(task.id!);
      await taskRef.update(task.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteTask(String id) async {
    try {
      final taskRef = taskReference.child(id);
      await taskRef.remove();
      return true;
    } catch (e) {
      return false;
    }
  }
}

final taskService = TaskService._internal();
