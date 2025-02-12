import 'package:firebase_database/firebase_database.dart';

import '../models/models.dart';

class TaskService {
  factory TaskService() {
    return _instance;
  }

  TaskService._internal();
  static final TaskService _instance = TaskService._internal();

  final taskReference = FirebaseDatabase.instance.ref().child('tasks');

  Future<List<TaskModel>> getTasks() async {
    // Fetch tasks from the server

    return [];
  }

  Future<TaskModel?> getTask(int id) async {
    // Fetch task from the server
    return null;
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
    // Update task on the server
    return true;
  }

  Future<void> deleteTask(int id) async {
    // Delete task on the server
  }
}

final taskService = TaskService._internal();
