class JournalEntry {
  final int? id;
  final DateTime timestamp;
  final String content;
  final String? mood;
  final String? template;

  JournalEntry({
    this.id,
    required this.timestamp,
    required this.content,
    this.mood,
    this.template,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'content': content,
      'mood': mood,
      'template': template,
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'],
      timestamp: DateTime.parse(map['timestamp']),
      content: map['content'],
      mood: map['mood'],
      template: map['template'],
    );
  }
}
