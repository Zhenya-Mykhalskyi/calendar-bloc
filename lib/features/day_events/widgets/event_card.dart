import 'package:flutter/material.dart';

import 'package:keym_calendar/features/day_events/view/event_detail_screen.dart';
import 'package:keym_calendar/features/day_events/widgets/update_delete_bottom_sheet.dart';
import 'package:keym_calendar/helpers/date_formater.dart';
import 'package:keym_calendar/repositories/calendar/models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final eventTime = DateTimeHelper.formatDateTimeOnlyTime(event.dateTime);
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
      onLongPress: () {
        showUpdateDeleteBottomSheet(context: context, event: event);
      },
      child: Card(
        child: ListTile(
          leading: Text(
            eventTime,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor),
          ),
          title: Text(
            event.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            event.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
