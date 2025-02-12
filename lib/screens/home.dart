import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/widgets/task_container.dart';

import '../models/models.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    Provider.of<TaskProvider>(context, listen: false).listenToTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        surfaceTintColor: Colors.white,
        title: const Text(
          'My tasks',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 80,
              child: Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  if (taskProvider.tasks.isEmpty) {
                    return const Center(child: Text('No tasks available'));
                  } else {
                    return ListView.builder(
                      itemCount: taskProvider.tasks.length,
                      itemBuilder: (context, index) {
                        final task = taskProvider.tasks[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index == taskProvider.tasks.length - 1
                                ? 100
                                : 0,
                          ),
                          child: TaskContainer(
                            task: task,
                            onChange: () async => await taskProvider.updateTask(
                              task,
                              context,
                            ),
                            onDelete: () async => await taskProvider.removeTask(
                              task,
                              context,
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 80,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: Colors.white,
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      try {
                        final newTask = TaskModel(
                          name: 'New Task',
                          description:
                              'New Description asd as dasd abghsdgashj dkjhasg djkhasghjdk askjh djkahsgd kjhasg d khjasg kdjga skhjdask d',
                          isCompleted: false,
                        );
                        await Provider.of<TaskProvider>(context, listen: false)
                            .addTask(newTask, context);
                      } catch (e) {
                        log('Error: $e');
                      }
                    },
                    child: const Text(
                      'Add Task',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
