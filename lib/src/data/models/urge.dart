class Urge {
  final int? id;
  final DateTime timestamp;
  final int intensity;
  final String? trigger;
  final String resolution;
  final String? notes;

  Urge({
    this.id,
    required this.timestamp,
    required this.intensity,
    this.trigger,
    required this.resolution,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'intensity': intensity,
      'trigger': trigger,
      'resolution': resolution,
      'notes': notes,
    };
  }

  factory Urge.fromMap(Map<String, dynamic> map) {
    return Urge(
      id: map['id'],
      timestamp: DateTime.parse(map['timestamp']),
      intensity: map['intensity'],
      trigger: map['trigger'],
      resolution: map['resolution'],
      notes: map['notes'],
    );
  }
}
