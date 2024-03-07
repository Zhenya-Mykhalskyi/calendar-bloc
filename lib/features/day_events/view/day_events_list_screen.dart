import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:keym_calendar/features/day_events/bloc/day_events_bloc.dart';
import 'package:keym_calendar/features/day_events/widgets/event_card.dart';
import 'package:keym_calendar/helpers/date_formater.dart';
import 'package:keym_calendar/repositories/calendar/models/event.dart';
import 'package:keym_calendar/widgets/custom_error_widget.dart';

class DayEventsListScreen extends StatefulWidget {
  final DateTime? selectedDate;
  const DayEventsListScreen({super.key, this.selectedDate});

  @override
  State<DayEventsListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<DayEventsListScreen> {
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
        centerTitle: true,
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
                        'You have no events for ${DateTimeHelper.formatDateTimeOnlyDate(widget.selectedDate!)}'),
                  );
          } else if (state is DayEventsLoadingError) {
            return CustomErrorWidget(
              errorMessage: state.message,
              onPressed: () {
                _dayEventsBloc
                    .add(LoadEventsForDay(selectedDay: widget.selectedDate));
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
