import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/widgets/task_button.dart';
import '../providers/task_provider.dart';

class NewTask extends StatefulWidget {
  const NewTask({super.key});

  @override
  NewTaskState createState() => NewTaskState();
}

class NewTaskState extends State<NewTask> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _createTask();
      Navigator.pop(context);
    }
  }

  /// Create a task in the realtime database
  void _createTask() {
    Provider.of<TaskProvider>(context, listen: false).addTask(
      TaskModel(
        isPendingToCreate: false,
        isPendingToUpdate: false,
        createdAt: DateTime.now(),
        name: _titleController.text,
        description: _descriptionController.text,
        isCompleted: false,
      ),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Create task',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 16.0),
                    _buildTitleField(),
                    const SizedBox(height: 16.0),
                    _buildDescriptionField(),
                    const SizedBox(height: 16.0),
                    const Spacer(),
                    TaskButton(onPressed: _submitForm, label: 'Create task'),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Title',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a title';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        alignLabelWithHint: true,
        labelText: 'Description',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
    );
  }
}
