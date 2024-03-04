class Event {
  final String id;
  final DateTime dateTime;
  final String title;
  final String description;
  final String? photoPath;

  Event({
    required this.id,
    required this.dateTime,
    required this.title,
    required this.description,
    this.photoPath,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      dateTime: DateTime.parse(map['dateTime']),
      title: map['title'],
      description: map['description'],
      photoPath: map['photoPath'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'title': title,
      'description': description,
      'photoPath': photoPath ?? '',
    };
  }
}
