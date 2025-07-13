import 'package:quit_companion/src/data/database_helper.dart';
import 'package:quit_companion/src/data/models/goal.dart';

class GoalRepository {
  final DatabaseHelper dbHelper;

  GoalRepository({required this.dbHelper});

  Future<Goal> addGoal(Goal goal) async {
    final goalId = await dbHelper.insert(
      DatabaseHelper.tableGoals,
      goal.toMap(),
    );
    for (var subtask in goal.subtasks) {
      await dbHelper.insert(
        DatabaseHelper.tableGoalSubtasks,
        Subtask(goalId: goalId, task: subtask.task).toMap(),
      );
    }
    return goal..id = goalId;
  }

  Future<List<Goal>> getAllGoals() async {
    final goalMaps = await dbHelper.queryAllRows(
      DatabaseHelper.tableGoals,
      orderBy: 'id DESC',
    );
    List<Goal> goals = [];
    for (var goalMap in goalMaps) {
      final goal = Goal.fromMap(goalMap);
      final subtaskMaps = await dbHelper.database.then(
        (db) => db.query(
          DatabaseHelper.tableGoalSubtasks,
          where: 'goalId = ?',
          whereArgs: [goal.id],
        ),
      );
      goal.subtasks = subtaskMaps.map((map) => Subtask.fromMap(map)).toList();
      goals.add(goal);
    }
    return goals;
  }

  Future<int> updateGoal(Goal goal) async {
    return await dbHelper.update(
      DatabaseHelper.tableGoals,
      goal.toMap(),
      'id',
      goal.id,
    );
  }

  Future<int> updateSubtask(Subtask subtask) async {
    return await dbHelper.update(
      DatabaseHelper.tableGoalSubtasks,
      subtask.toMap(),
      'id',
      subtask.id,
    );
  }

  Future<int> deleteGoal(int id) async {
    return await dbHelper.delete(DatabaseHelper.tableGoals, 'id', id);
  }
}
