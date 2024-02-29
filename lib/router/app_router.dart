import 'package:flutter/material.dart';
import 'package:keym_calendar/features/calendar/view/add_event_screen.dart';
import 'package:keym_calendar/features/calendar/view/calendar_screen.dart';
import 'package:keym_calendar/features/calendar/view/event_list_screen.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const CalendarScreen());
      case '/addEventScreen':
        return MaterialPageRoute(builder: (_) => const AddEventScreen());
      case '/eventListScreen':
        return MaterialPageRoute(builder: (_) => const EventListScreen());
      default:
        return MaterialPageRoute(builder: (_) => const CalendarScreen());
    }
  }
}
