import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/utils/routes.dart';
import '../widgets/widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  String _filter = 'All';

  @override
  void initState() {
    super.initState();
    Provider.of<TaskProvider>(context, listen: false).listenToTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      shadowColor: Colors.black,
      surfaceTintColor: Colors.white,
      title: const Text(
        'My tasks',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: DropdownButton<String>(
            dropdownColor: Colors.white,
            value: _filter,
            items: <String>['All', 'Completed', 'Not Completed']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _filter = newValue!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height - 80,
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                List<TaskModel> filteredTasks =
                    _filterTasks(taskProvider.tasks);
                if (filteredTasks.isEmpty) {
                  return const Center(child: Text('No tasks available'));
                } else {
                  return ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == filteredTasks.length - 1 ? 80 : 0,
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
        ],
      ),
    );
  }

  List<TaskModel> _filterTasks(List<TaskModel> tasks) {
    if (_filter == 'Completed') {
      return tasks.where((task) => task.isCompleted!).toList();
    } else if (_filter == 'Not Completed') {
      return tasks.where((task) => !task.isCompleted!).toList();
    }
    return tasks;
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.blueAccent,
      onPressed: () => Navigator.pushNamed(context, Routes.newTask),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
