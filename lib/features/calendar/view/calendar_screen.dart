import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:keym_calendar/theme/app_colors.dart';
import 'package:keym_calendar/features/calendar/bloc/calendar_bloc.dart';
import 'package:keym_calendar/features/calendar/widgets/add_event_button.dart';
import 'package:keym_calendar/features/day_events/view/day_events_list_screen.dart';
import 'package:keym_calendar/widgets/custom_error_widget.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late CalendarBloc _calendarBloc;

  @override
  void initState() {
    _calendarBloc = BlocProvider.of<CalendarBloc>(context);
    _calendarBloc.add(LoadCalendar());
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
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TableCalendar(
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                        ),
                        calendarStyle: CalendarStyle(
                          weekendTextStyle:
                              const TextStyle(color: AppColors.whiteColor),
                          outsideTextStyle: TextStyle(
                              color: AppColors.whiteColor.withOpacity(0.4)),
                        ),
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        calendarFormat: calendarFormat,
                        rowHeight: 55,
                        daysOfWeekHeight: 35,
                        onDaySelected: (selectedDay, focusedDay) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DayEventsListScreen(
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
                            var eventsCount = state.events
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
                                  eventsCount > 3 ? 3 : eventsCount,
                                  (index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          right: index < 2 ? 2 : 0),
                                      child: const Icon(Icons.circle,
                                          size: 10,
                                          color: AppColors.primaryColor),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is CalendarLoadingError) {
                return CustomErrorWidget(
                  errorMessage: state.message,
                  onPressed: () {
                    _calendarBloc.add(LoadCalendar());
                  },
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
