import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:keym_calendar/features/add_event/view/add_event_screen.dart';
import 'package:keym_calendar/features/calendar/bloc/calendar_bloc.dart';
import 'package:keym_calendar/features/day_events/bloc/day_events_bloc.dart';
import 'package:keym_calendar/features/day_events/view/event_detail_screen.dart';
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
        showUpdateDeleteBottomSheet(context);
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

  Future<dynamic> showUpdateDeleteBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEventScreen(
                        event: event,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Deletion'),
                        content: const Text(
                            'Are you sure you want to delete this event?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              BlocProvider.of<CalendarBloc>(context)
                                  .add(DeleteEvent(event));
                              BlocProvider.of<DayEventsBloc>(context).add(
                                  LoadEventsForDay(
                                      selectedDay: event.dateTime));
                              Navigator.of(context).pop();
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
