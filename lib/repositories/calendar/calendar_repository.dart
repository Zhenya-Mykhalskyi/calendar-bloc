import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:keym_calendar/helpers/date_formater.dart';
import 'models/event.dart';

class CalendarRepository {
  // For web, use in-memory storage
  final List<Event> _events = [];
  bool _initialized = false;

  bool get isDatabaseInitialized => _initialized;

  Future<void> open() async {
    // For web, just mark as initialized
    await Future.delayed(Duration(milliseconds: 100));
    _initialized = true;
  }

  Future<List<Event>> getAllEvents() async {
    if (!isDatabaseInitialized) {
      throw StateError('Repository is not initialized');
    }
    return List.from(_events);
  }

  Future<List<Event>> getEventsForDay({required DateTime dateTime}) async {
    final startOfDay = DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0);
    final endOfDay = DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59);
    
    return _events.where((event) {
      return event.dateTime.isAfter(startOfDay.subtract(Duration(seconds: 1))) &&
             event.dateTime.isBefore(endOfDay.add(Duration(seconds: 1)));
    }).toList();
  }

  Future<void> insertEvent(Event event) async {
    _events.add(event);
  }

  Future<void> updateEvent(Event event) async {
    final index = _events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _events[index] = event;
    }
  }

  Future<void> deleteEvent(String id) async {
    _events.removeWhere((e) => e.id == id);
  }

  Future<void> deleteDB() async {
    _events.clear();
  }
}
