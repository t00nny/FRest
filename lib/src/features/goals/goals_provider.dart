// lib/src/features/goals/goals_provider.dart

import 'package:flutter/material.dart';
import 'package:quit_companion/src/data/models/goal.dart';
import 'package:quit_companion/src/data/repositories/goal_repository.dart';

class GoalsProvider extends ChangeNotifier {
  final GoalRepository _goalRepository;

  GoalsProvider(this._goalRepository) {
    fetchGoals();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Goal> _goals = [];
  List<Goal> get goals => _goals;

  Future<void> fetchGoals() async {
    _isLoading = true;
    notifyListeners();
    _goals = await _goalRepository.getAllGoals();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addGoal(Goal goal) async {
    await _goalRepository.addGoal(goal);
    await fetchGoals(); // Refetch to get the new goal with its ID
  }

  Future<void> toggleSubtask(int goalId, Subtask subtask) async {
    subtask.isCompleted = !subtask.isCompleted;
    await _goalRepository.updateSubtask(subtask);

    // Check if all subtasks are completed to update the parent goal
    final goal = _goals.firstWhere((g) => g.id == goalId);
    final allSubtasksCompleted = goal.subtasks.every((s) => s.isCompleted);
    if (goal.isCompleted != allSubtasksCompleted) {
      goal.isCompleted = allSubtasksCompleted;
      await _goalRepository.updateGoal(goal);
    }

    notifyListeners();
  }

  Future<void> deleteGoal(int goalId) async {
    await _goalRepository.deleteGoal(goalId);
    _goals.removeWhere((goal) => goal.id == goalId);
    notifyListeners();
  }
}
