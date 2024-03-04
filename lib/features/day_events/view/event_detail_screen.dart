import 'package:flutter/material.dart';

import 'package:keym_calendar/helpers/date_formater.dart';
import 'package:keym_calendar/repositories/calendar/models/event.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDateTime = DateTimeHelper.formatDateTime(event.dateTime);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(tag: event.id, child: Image.asset(event.photoPath!)),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  event.description,
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  'Date: $formattedDateTime',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
