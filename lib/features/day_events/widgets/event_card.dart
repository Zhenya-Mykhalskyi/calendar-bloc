import 'package:flutter/material.dart';
import 'package:keym_calendar/features/day_events/view/event_detail_screen.dart';
import 'package:keym_calendar/repositories/calendar/models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(
              imagePath: event.photoPath ?? '',
              title: event.title,
              description: event.description,
              date: event.dateTime,
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          leading: Image.network(event.photoPath ?? ''),
          title: Text(event.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event.description),
              Text(event.dateTime.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
