import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/utils/routes.dart';

import '../widgets/widgets.dart';

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
                padding: const EdgeInsets.symmetric(vertical: 10),
                color: Colors.white,
                child: TaskButton(
                  label: 'Create Task',
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.newTask);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
