part of 'calendar_bloc.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();
}

class LoadCalendar extends CalendarEvent {
  final Completer? completer;
  const LoadCalendar({
    this.completer,
  });

  @override
  List<Object> get props => [];
}

class LoadEventsForDay extends CalendarEvent {
  final DateTime selectedDay;

  const LoadEventsForDay(this.selectedDay);

  @override
  List<Object?> get props => [selectedDay];
}