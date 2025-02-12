// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:task_manager/services/task_service.dart';
import 'package:task_manager/utils/snackbar_service.dart';
import '../models/models.dart';

class TaskProvider extends ChangeNotifier {
  List<TaskModel> tasks = [];

  /// Listen to the tasks in the realtime database
  void listenToTasks() {
    taskService.getTaskRealtime().listen((updatedTasks) {
      tasks = updatedTasks;
      notifyListeners();
    });
  }

  /// Add a task to the realtime database
  Future<void> addTask(TaskModel task, BuildContext context) async {
    final result = await taskService.createTask(task);
    showValdiationSnackBars(result, context);
    notifyListeners();
  }

  /// Remove a task from the realtime database
  Future<void> removeTask(TaskModel task, BuildContext context) async {
    final result = await taskService.deleteTask(task.id!);
    showValdiationSnackBars(result, context);

    notifyListeners();
  }

  /// Update a task in the realtime database
  Future<void> updateTask(TaskModel task, BuildContext context) async {
    await taskService.updateTask(task);

    notifyListeners();
  }

  /// Show a snackbar based on the result of the operation
  showValdiationSnackBars(bool result, BuildContext context) {
    if (result) {
      snackbarService.showSuccessSnackbar(context);
    } else {
      snackbarService.showErrorSnackbar(context);
    }
  }
}
