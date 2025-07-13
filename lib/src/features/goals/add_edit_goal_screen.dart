// lib/src/features/goals/add_edit_goal_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quit_companion/src/data/models/goal.dart';
import 'package:quit_companion/src/features/goals/goals_provider.dart';

class AddEditGoalScreen extends StatefulWidget {
  final Goal? goal;
  const AddEditGoalScreen({super.key, this.goal});

  @override
  State<AddEditGoalScreen> createState() => _AddEditGoalScreenState();
}

class _AddEditGoalScreenState extends State<AddEditGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  final List<TextEditingController> _subtaskControllers = [];
  final TextEditingController _newSubtaskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.goal?.title);
    _descriptionController = TextEditingController(
      text: widget.goal?.description,
    );
    if (widget.goal?.subtasks != null) {
      for (var subtask in widget.goal!.subtasks) {
        _subtaskControllers.add(TextEditingController(text: subtask.task));
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _newSubtaskController.dispose();
    for (var controller in _subtaskControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addSubtask() {
    if (_newSubtaskController.text.isNotEmpty) {
      setState(() {
        _subtaskControllers.add(
          TextEditingController(text: _newSubtaskController.text),
        );
        _newSubtaskController.clear();
      });
    }
  }

  void _saveGoal() {
    if (_formKey.currentState!.validate()) {
      final newGoal = Goal(
        id: widget.goal?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        subtasks: _subtaskControllers
            .map((c) => Subtask(goalId: 0, task: c.text))
            .toList(),
      );
      // For now, we only support adding goals.
      context.read<GoalsProvider>().addGoal(newGoal);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.goal == null ? 'Add New Goal' : 'Edit Goal'),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _saveGoal),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Goal Title',
                hintText: 'e.g., "Read one book this month"',
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Title cannot be empty' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
              ),
            ),
            const SizedBox(height: 24),
            Text('Subtasks', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ..._buildSubtaskList(),
            _buildAddSubtaskField(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSubtaskList() {
    return _subtaskControllers.map((controller) {
      final index = _subtaskControllers.indexOf(controller);
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(hintText: 'Subtask ${index + 1}'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () {
                setState(() {
                  _subtaskControllers.removeAt(index);
                });
              },
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildAddSubtaskField() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _newSubtaskController,
            decoration: const InputDecoration(hintText: 'Add a new subtask...'),
            onFieldSubmitted: (_) => _addSubtask(),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.add_circle,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: _addSubtask,
        ),
      ],
    );
  }
}
