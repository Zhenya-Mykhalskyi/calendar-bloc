import 'package:flutter/material.dart';

import 'package:keym_calendar/features/day_events/view/event_detail_screen.dart';
import 'package:keym_calendar/helpers/date_formater.dart';
import 'package:keym_calendar/repositories/calendar/models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final formattedDateTime = DateTimeHelper.formatDateTime(event.dateTime);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(
              event: event,
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          leading: event.photoPath == ''
              ? const Placeholder()
              : Hero(
                  tag: event.id,
                  child: Image.asset(
                    event.photoPath!,
                  ),
                ),
          title: Text(event.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event.description),
              Text(formattedDateTime),
            ],
          ),
        ),
      ),
    );
  }
}
