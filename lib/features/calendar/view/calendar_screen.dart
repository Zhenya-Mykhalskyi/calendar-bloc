import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:keym_calendar/features/calendar/bloc/calendar_bloc.dart';
import 'package:keym_calendar/repositories/calendar/abstarct_calendar_repository.dart';
import 'package:keym_calendar/repositories/calendar/models/event.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final _calendarBloc = CalendarBloc(
    GetIt.I<AbstractCalendarRepository>(),
  );

  @override
  void initState() {
    _calendarBloc.add(const LoadCalendar());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime focusedDay = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/addEventScreen');
            },
          )
        ],
      ),
      body: BlocBuilder<CalendarBloc, CalendarState>(
        bloc: _calendarBloc,
        builder: (context, state) {
          if (state is CalendarLoaded) {
            return TableCalendar(
              onDaySelected: (selectedDay, focusedDay) {
                Navigator.of(context).pushNamed('/eventListScreen');
                // BlocProvider.of<CalendarBloc>(context).add(
                //   LoadEventsForDay(
                //     selectedDay,
                //   ),
                // );
              },
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: focusedDay,
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  final eventsCount = state.events
                      .where((event) =>
                          event.dateTime.year == date.year &&
                          event.dateTime.month == date.month &&
                          event.dateTime.day == date.day)
                      .length;

                  return Positioned(
                    bottom: 1,
                    child: Text(
                      '$eventsCount',
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget buildEventList(List<Event> events) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        Event event = events[index];
        return ListTile(
          title: Text(event.title),
          subtitle: Text(event.description),
        );
      },
    );
  }
}
