import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:keym_calendar/features/day_events/bloc/day_events_bloc.dart';
import 'package:keym_calendar/features/day_events/widgets/event_card.dart';
import 'package:keym_calendar/repositories/calendar/abstarct_calendar_repository.dart';

class DayEventsScreen extends StatefulWidget {
  final DateTime? selectedDate;
  const DayEventsScreen({super.key, this.selectedDate});

  @override
  State<DayEventsScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<DayEventsScreen> {
  final _dayEventsBloc = DayEventsBloc(
    GetIt.I<AbstractCalendarRepository>(),
  );

  @override
  void initState() {
    log(widget.selectedDate!.toIso8601String());
    _dayEventsBloc.add(LoadEventsForDay(selectedDay: widget.selectedDate));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('evet list '),
      ),
      body: BlocBuilder<DayEventsBloc, DayEventsState>(
        bloc: _dayEventsBloc,
        builder: (context, state) {
          if (state is DayEventsLoaded) {
            return ListView.builder(
              itemBuilder: (context, index) =>
                  EventCard(event: state.events[index]),
              itemCount: state.events.length,
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
