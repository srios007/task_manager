import 'package:firebase_database/firebase_database.dart';
import 'package:get_storage/get_storage.dart';

import '../models/models.dart';
import '../utils/utils.dart';

class TaskService {
  factory TaskService() {
    return _instance;
  }

  TaskService._internal();
  static final TaskService _instance = TaskService._internal();

  final taskReference = FirebaseDatabase.instance.ref().child('tasks');

  /// Get the tasks in the realtime database
  Future<Stream<List<TaskModel>>> getTaskRealtime() async {
    if ((await connectivityService.checkStatus())) {
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

        GetStorage().write('tasks', tasks.map((e) => e.toJson()).toList());

        return tasks;
      });
    } else {
      final tasks = GetStorage().read('tasks');
      if (tasks != null) {
        return Stream.value(
          List<TaskModel>.from(
            tasks.map((e) => TaskModel.fromJson(e)).toList(),
          ),
        );
      } else {
        return Stream.value(<TaskModel>[]);
      }
    }
  }

  /// Create a task in the realtime database
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

  /// Update a task in the realtime database
  Future<bool> updateTask(TaskModel task) async {
    try {
      if (await connectivityService.checkStatus()) {
        final taskRef = taskReference.child(task.id!);
        await taskRef.update(task.toJson());
        return true;
      } else {
        final tasks = GetStorage().read('tasks');
        if (tasks != null) {
          final list = List<TaskModel>.from(
            tasks.map((e) => TaskModel.fromJson(e)).toList(),
          );

          for (var element in list) {
            if (element.id == task.id) {
              element.name = task.name;
              element.description = task.description;
              element.isCompleted = task.isCompleted;
              element.isPendingToUpdate = true;
              element.createdAt = task.createdAt;
              element.isPendingToCreate = task.isPendingToCreate;
              GetStorage().write('tasks', list.map((e) => e.toJson()).toList());

              return true;
            }
          }
          return false;
        } else {
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }

  /// Remove a task from the realtime database
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
