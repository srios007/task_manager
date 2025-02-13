// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_manager/services/task_service.dart';
import '../models/models.dart';
import '../utils/utils.dart';

class TaskProvider extends ChangeNotifier {
  List<TaskModel> tasks = [];

  /// Listen to the tasks in the realtime database
  Future<void> listenToTasks() async {
    if ((await connectivityService.checkStatus())) {
      await validateSyncTaskToRemote();
    }
    await taskService.getTaskRealtime().then(
          (stream) => stream.listen((updatedTasks) {
            tasks = updatedTasks;
            tasks.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
            notifyListeners();
          }),
        );
  }

  /// Validate the tasks that are pending to be updated or created
  Future<void> validateSyncTaskToRemote() async {
    try {
      final storageTasks = GetStorage().read('tasks');
      if (storageTasks == null) return;
      if (storageTasks != null) {
        for (var task in storageTasks) {
          final taskModel = TaskModel.fromJson(task);
          if (taskModel.isPendingToUpdate!) {
            taskModel.isPendingToUpdate = false;
            await taskService.updateTask(taskModel);
          }
          if (taskModel.isPendingToCreate!) {
            taskModel.isPendingToCreate = false;
            await taskService.createTask(taskModel);
          }
        }
      }
      GetStorage().remove('tasks');
    } catch (_) {}
  }

  /// Add a task to the realtime database
  Future<void> addTask(TaskModel task, BuildContext context) async {
    if ((await connectivityService.checkStatus())) {
      final result = await taskService.createTask(task);
      showValdiationSnackBars(result, context);
    } else {
      final storageTasks = GetStorage().read('tasks') ?? [];
      task.isPendingToCreate = true;
      tasks.add(task);
      storageTasks.add(task.toJson());
      GetStorage().write('tasks', storageTasks);
    }

    notifyListeners();
  }

  /// Remove a task from the realtime database
  Future<void> removeTask(TaskModel task, BuildContext context) async {
    if (!(await connectivityService.checkStatus())) {
      snackbarService.showErrorSnackbar(
        context,
        message: 'To delete a task, you need to be connected to the internet',
      );
      return;
    }
    final result = await taskService.deleteTask(task.id!);
    showValdiationSnackBars(result, context);

    notifyListeners();
  }

  /// Update a task in the realtime database
  Future<void> updateTask(TaskModel task, BuildContext context) async {
    final result = await taskService.updateTask(task);
    showValdiationSnackBars(result, context);

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
