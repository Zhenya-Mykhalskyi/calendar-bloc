import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:keym_calendar/features/calendar/bloc/calendar_bloc.dart';
import 'package:keym_calendar/features/calendar/widgets/add_event_button.dart';
import 'package:keym_calendar/features/day_events/view/day_events_screen.dart';
import 'package:keym_calendar/repositories/calendar/abstarct_calendar_repository.dart';

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
    final CalendarFormat calendarFormat =
        MediaQuery.of(context).orientation == Orientation.landscape
            ? CalendarFormat.twoWeeks
            : CalendarFormat.month;
    DateTime focusedDay = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Calendar'),
        actions: const [
          AddEventButton(),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocBuilder<CalendarBloc, CalendarState>(
            bloc: _calendarBloc,
            builder: (context, state) {
              if (state is CalendarLoaded) {
                return TableCalendar(
                  calendarFormat: calendarFormat,
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  rowHeight: 55,
                  daysOfWeekHeight: 35,
                  onDaySelected: (selectedDay, focusedDay) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DayEventsScreen(
                          selectedDate: selectedDay,
                        ),
                      ),
                    );
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              eventsCount > 3 ? 3 : eventsCount, (index) {
                            return Padding(
                              padding:
                                  EdgeInsets.only(right: index < 2 ? 2 : 0),
                              child: const Icon(
                                Icons.circle,
                                size: 10,
                                color: Color.fromARGB(255, 110, 73, 139),
                              ),
                            );
                          }),
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
        ),
      ),
    );
  }
}
