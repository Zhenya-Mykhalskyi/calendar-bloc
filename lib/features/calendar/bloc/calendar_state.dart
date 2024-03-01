part of 'calendar_bloc.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();
}

class CalendarInitial extends CalendarState {
  @override
  List<Object?> get props => [];
}

class CalendarLoading extends CalendarState {
  @override
  List<Object> get props => [];
}

class CalendarLoaded extends CalendarState {
  final List<Event> events;

  const CalendarLoaded({required this.events});

  @override
  List<Object> get props => [events];
}
