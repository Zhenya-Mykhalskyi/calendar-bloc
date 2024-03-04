import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:keym_calendar/features/day_events/bloc/day_events_bloc.dart';
import 'package:keym_calendar/features/day_events/widgets/event_card.dart';

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
    super.initState();
    _dayEventsBloc = BlocProvider.of<DayEventsBloc>(context);
    _dayEventsBloc.add(LoadEventsForDay(selectedDay: widget.selectedDate));
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
            return state.events.isNotEmpty
                ? ListView.builder(
                    itemBuilder: (context, index) =>
                        EventCard(event: state.events[index]),
                    itemCount: state.events.length,
                  )
                : Center(
                    child:
                        Text('You have no events for ${widget.selectedDate}'),
                  );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
