part of 'calendar_bloc.dart';

abstract class CalendarState extends Equatable {}

class CalendarInitial extends CalendarState {
  @override
  List<Object> get props => [];
}

class CalendarLoading extends CalendarState {
  @override
  List<Object> get props => [];
}

class CalendarLoaded extends CalendarState {
  final List<Event> events;

  CalendarLoaded({required this.events});

  @override
  List<Object?> get props => [events];
}

class CalendarLoadingError extends CalendarState {
  final String message;

  CalendarLoadingError({required this.message});

  @override
  List<Object?> get props => [message];
}
