import 'dart:convert';

class DailyCheckin {
  final int? id;
  final DateTime date;
  final bool relapsed;
  final int urgeLevel;
  final String mood;
  final List<String> triggers;
  final List<String> positiveActions;
  final int score;

  DailyCheckin({
    this.id,
    required this.date,
    required this.relapsed,
    required this.urgeLevel,
    required this.mood,
    required this.triggers,
    required this.positiveActions,
    required this.score,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String().substring(
        0,
        10,
      ), // Store date as YYYY-MM-DD
      'relapsed': relapsed ? 1 : 0,
      'urgeLevel': urgeLevel,
      'mood': mood,
      'triggers': jsonEncode(triggers),
      'positiveActions': jsonEncode(positiveActions),
      'score': score,
    };
  }

  factory DailyCheckin.fromMap(Map<String, dynamic> map) {
    return DailyCheckin(
      id: map['id'],
      date: DateTime.parse(map['date']),
      relapsed: map['relapsed'] == 1,
      urgeLevel: map['urgeLevel'],
      mood: map['mood'],
      triggers: List<String>.from(jsonDecode(map['triggers'])),
      positiveActions: List<String>.from(jsonDecode(map['positiveActions'])),
      score: map['score'],
    );
  }
}
