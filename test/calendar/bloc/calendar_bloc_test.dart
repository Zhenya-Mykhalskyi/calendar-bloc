import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:keym_calendar/features/calendar/bloc/calendar_bloc.dart';
import 'package:keym_calendar/repositories/calendar/calendar_repository.dart';
import 'package:keym_calendar/repositories/calendar/models/event.dart';

void main() {
  group('CalendarBloc', () {
    late FakeCalendarRepository fakeCalendarRepository;

    setUp(() {
      fakeCalendarRepository = FakeCalendarRepository();
    });

    test('emits CalendarLoaded when LoadCalendar event is added', () async {
      final calendarBloc = CalendarBloc(fakeCalendarRepository);
      final events = [
        Event(
            id: '1',
            title: 'Event 1',
            dateTime: DateTime.now(),
            description: 'Description 1'),
      ];
      fakeCalendarRepository._events = events;

      calendarBloc.add(LoadCalendar());

      await expectLater(
        calendarBloc.stream,
        emits(CalendarLoaded(events: events)),
      ).then((_) => Future.delayed(const Duration(milliseconds: 100)));
    });

    test('emits CalendarLoaded after adding an event', () async {
      final calendarBloc = CalendarBloc(fakeCalendarRepository);
      final currentState = CalendarLoaded(events: [
        Event(
            id: '1',
            title: 'Event 1',
            dateTime: DateTime.now(),
            description: 'Description 1'),
      ]);
      final eventToAdd = Event(
          id: '2',
          title: 'New Event',
          dateTime: DateTime.now(),
          description: 'New Description');

      final expectedEvents = [
        ...currentState.events,
        Event(
            id: '2',
            title: 'New Event',
            dateTime: DateTime.now(),
            description: 'New Description'),
      ];

      calendarBloc.emit(currentState);
      calendarBloc.add(AddEvent(eventToAdd));

      await expectLater(
        calendarBloc.stream,
        emits(
          predicate<CalendarState>((state) {
            if (state is CalendarLoaded) {
              return listEquals(
                  state.events.map((event) => event.toString()).toList(),
                  expectedEvents.map((event) => event.toString()).toList());
            }
            return false;
          }),
        ),
      ).then((_) => Future.delayed(const Duration(milliseconds: 100)));
    });

    test('emits CalendarLoaded after deleting an event', () async {
      final calendarBloc = CalendarBloc(fakeCalendarRepository);
      final currentState = CalendarLoaded(events: [
        Event(
            id: '1',
            title: 'Event 1',
            dateTime: DateTime.now(),
            description: 'Description 1'),
      ]);

      final eventToDelete = currentState.events.first;
      calendarBloc.emit(currentState);
      calendarBloc.add(DeleteEvent(eventToDelete));

      await expectLater(
        calendarBloc.stream,
        emits(
          predicate<CalendarState>((state) {
            if (state is CalendarLoaded) {
              return !state.events.contains(eventToDelete);
            }
            return false;
          }),
        ),
      ).then((_) => Future.delayed(const Duration(milliseconds: 100)));
    });
  });
}

class FakeCalendarRepository implements CalendarRepository {
  List<Event> _events = [];

  @override
  Future<void> deleteEvent(String id) async {
    _events.removeWhere((event) => event.id == id);
  }

  @override
  Future<List<Event>> getAllEvents() async {
    return _events;
  }

  @override
  Future<List<Event>> getEventsForDay({required DateTime dateTime}) async {
    return _events.where((event) => event.dateTime == dateTime).toList();
  }

  @override
  Future<void> insertEvent(Event event) async {
    _events.add(event);
  }

  @override
  bool get isDatabaseInitialized => true;

  @override
  Future<void> open() async {}

  @override
  Future<void> updateEvent(Event event) async {
    final index = _events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _events[index] = event;
    }
  }

  @override
  Future<void> deleteDB() {
    throw UnimplementedError();
  }
}
