import 'package:intl/intl.dart';

class Event {
  static DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");

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
    String formattedDateTime = dateFormat.format(dateTime);
    return {
      'id': id,
      'dateTime': formattedDateTime,
      'title': title,
      'description': description,
      'photoPath': photoPath ?? '',
    };
  }
}
