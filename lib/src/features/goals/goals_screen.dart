// lib/src/features/goals/goals_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quit_companion/src/data/models/goal.dart';
import 'package:quit_companion/src/features/goals/add_edit_goal_screen.dart';
import 'package:quit_companion/src/features/goals/goals_provider.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch goals when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GoalsProvider>().fetchGoals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Goals')),
      body: Consumer<GoalsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.goals.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.flag_outlined,
                      size: 80,
                      color: Colors.grey[700],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Goals Yet',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the "+" button to add a new goal and start building a better you.',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: provider.goals.length,
            itemBuilder: (context, index) {
              final goal = provider.goals[index];
              return GoalCard(goal: goal);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const AddEditGoalScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class GoalCard extends StatelessWidget {
  final Goal goal;
  const GoalCard({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<GoalsProvider>();
    final theme = Theme.of(context);
    final completedSubtasks = goal.subtasks.where((s) => s.isCompleted).length;
    final progress = goal.subtasks.isEmpty
        ? (goal.isCompleted ? 1.0 : 0.0)
        : completedSubtasks / goal.subtasks.length;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Icon(
          goal.isCompleted ? Icons.check_circle : Icons.flag,
          color: goal.isCompleted
              ? theme.colorScheme.secondary
              : theme.colorScheme.primary,
          size: 30,
        ),
        title: Text(
          goal.title,
          style: theme.textTheme.titleLarge?.copyWith(
            decoration: goal.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (goal.subtasks.isNotEmpty)
                Text('${(progress * 100).toInt()}% complete'),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: progress,
                borderRadius: BorderRadius.circular(5),
                minHeight: 6,
                backgroundColor: Colors.grey.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: () => provider.deleteGoal(goal.id!),
        ),
        children: goal.subtasks.map((subtask) {
          return CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: theme.colorScheme.secondary,
            title: Text(
              subtask.task,
              style: TextStyle(
                decoration: subtask.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: subtask.isCompleted
                    ? Colors.grey[500]
                    : theme.textTheme.bodyLarge?.color,
              ),
            ),
            value: subtask.isCompleted,
            onChanged: (value) {
              provider.toggleSubtask(goal.id!, subtask);
            },
          );
        }).toList(),
      ),
    );
  }
}
