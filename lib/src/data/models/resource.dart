class Resource {
  final int? id;
  final String instruction;

  Resource({this.id, required this.instruction});

  Map<String, dynamic> toMap() {
    return {'id': id, 'instruction': instruction};
  }

  factory Resource.fromMap(Map<String, dynamic> map) {
    return Resource(id: map['id'], instruction: map['instruction']);
  }
}
