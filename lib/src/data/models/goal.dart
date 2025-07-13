// lib/src/data/models/goal.dart

class Subtask {
  final int? id;
  final int goalId;
  final String task;
  bool isCompleted;

  Subtask({
    this.id,
    required this.goalId,
    required this.task,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'goalId': goalId,
      'task': task,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Subtask.fromMap(Map<String, dynamic> map) {
    return Subtask(
      id: map['id'],
      goalId: map['goalId'],
      task: map['task'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}

class Goal {
  int? id; // CORRECTED: Made non-final
  final String title;
  final String? description;
  bool isCompleted;
  List<Subtask> subtasks;

  Goal({
    this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.subtasks = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
