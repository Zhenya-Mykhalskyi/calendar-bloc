import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:keym_calendar/features/calendar/bloc/calendar_bloc.dart';
import 'package:keym_calendar/features/calendar/view/calendar_screen.dart';
import 'package:keym_calendar/features/day_events/bloc/day_events_bloc.dart';
import 'package:keym_calendar/repositories/calendar/calendar_repository.dart';
import 'package:keym_calendar/theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CalendarBloc>(
          create: (context) => CalendarBloc(CalendarRepository()),
        ),
        BlocProvider<DayEventsBloc>(
          create: (context) => DayEventsBloc(CalendarRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Calendar',
        theme: MyThemes.darkTheme,
        home: const CalendarScreen(),
      ),
    );
  }
}
