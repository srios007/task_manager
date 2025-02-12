import 'package:flutter/material.dart';

class TaskProvider extends ChangeNotifier {
  List<String> tasks = [];

  void addTask(String task) {
    tasks.add(task);
    notifyListeners();
  }

  void removeTask(String task) {
    tasks.remove(task);
    notifyListeners();
  }
}