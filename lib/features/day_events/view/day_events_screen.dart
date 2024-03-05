import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:keym_calendar/features/day_events/bloc/day_events_bloc.dart';
import 'package:keym_calendar/features/day_events/widgets/event_card.dart';
import 'package:keym_calendar/repositories/calendar/models/event.dart';

class DayEventsScreen extends StatefulWidget {
  final DateTime? selectedDate;
  const DayEventsScreen({super.key, this.selectedDate});

  @override
  State<DayEventsScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<DayEventsScreen> {
  late DayEventsBloc _dayEventsBloc;

  @override
  void initState() {
    _dayEventsBloc = BlocProvider.of<DayEventsBloc>(context);
    _dayEventsBloc.add(LoadEventsForDay(selectedDay: widget.selectedDate));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events list'),
      ),
      body: BlocBuilder<DayEventsBloc, DayEventsState>(
        bloc: _dayEventsBloc,
        builder: (context, state) {
          if (state is DayEventsLoaded) {
            List<Event> sortedEvents = state.events.toList()
              ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
            return sortedEvents.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(5),
                    child: ListView.builder(
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: EventCard(event: sortedEvents[index]),
                      ),
                      itemCount: sortedEvents.length,
                    ),
                  )
                : Center(
                    child: Text(
                        'You have no events for ${widget.selectedDate?.toString().split(' ')[0]}'),
                  );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
