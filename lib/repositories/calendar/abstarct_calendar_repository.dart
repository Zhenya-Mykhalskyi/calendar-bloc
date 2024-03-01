import 'package:keym_calendar/repositories/calendar/models/event.dart';

abstract class AbstractCalendarRepository {
  Future<void> open();
  Future<void> close();

  Future<List<Event>> getAllEvents();
  Future<List<Event>> getEventsForDay({required DateTime dateTime});
  // Future<int> getEventCountForDay(DateTime dateTime);

  Future<void> insertEvent(Event event);
  Future<void> updateEvent(Event event);
  Future<void> deleteEvent(int id);

  late bool isDatabaseInitialized;
}
