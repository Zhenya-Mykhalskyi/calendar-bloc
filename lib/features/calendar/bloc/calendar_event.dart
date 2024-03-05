part of 'calendar_bloc.dart';

abstract class CalendarEvent extends Equatable {}

class LoadCalendar extends CalendarEvent {
  LoadCalendar({this.completer});
  final Completer? completer;

  @override
  List<Object?> get props => [completer];
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
