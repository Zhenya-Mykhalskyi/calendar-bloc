part of 'calendar_bloc.dart';

abstract class CalendarEvent extends Equatable {}

class LoadCalendar extends CalendarEvent {
  @override
  List<Object?> get props => [];
}

class AddEvent extends CalendarEvent {
  final Event event;

  AddEvent(this.event);

  @override
  List<Object> get props => [event];
}

class DeleteEvent extends CalendarEvent {
  final Event event;

  DeleteEvent(this.event);

  @override
  List<Object> get props => [event];
}

class UpdateEvent extends CalendarEvent {
  final Event event;

  UpdateEvent(this.event);

  @override
  List<Object> get props => [event];
}
