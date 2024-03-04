import 'package:intl/intl.dart';
import 'package:keym_calendar/helpers/date_formater.dart';

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
    DateTime formattedDateTime =
        DateFormat("yyyy-MM-dd HH:mm").parse(map['dateTime']);
    return Event(
      id: map['id'],
      dateTime: formattedDateTime,
      title: map['title'],
      description: map['description'],
      photoPath: map['photoPath'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    String formattedDateTime = DateTimeHelper.formatDateTime(dateTime);
    return {
      'id': id,
      'dateTime': formattedDateTime,
      'title': title,
      'description': description,
      'photoPath': photoPath ?? '',
    };
  }
}
