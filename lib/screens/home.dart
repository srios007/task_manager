import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:task_manager/services/task_service.dart';

import '../models/models.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            // ignore: avoid_print
            try {
              taskService.createTask(TaskModel(
                id: '1',
                name: 'Task 1',
                description: 'Description 1',
                isCompleted: false,
              ));
            } catch (e) {
              log('Error: $e');
            }
          },
          child: const Text('Welcome to Task Manager'),
        ),
      ),
    );
  }
}
