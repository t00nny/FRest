class Reason {
  final int? id;
  final String statement;

  Reason({this.id, required this.statement});

  Map<String, dynamic> toMap() {
    return {'id': id, 'statement': statement};
  }

  factory Reason.fromMap(Map<String, dynamic> map) {
    return Reason(id: map['id'], statement: map['statement']);
  }
}
