part of 'day_events_bloc.dart';

abstract class DayEventsState extends Equatable {
  const DayEventsState();
}

final class DayEventsInitial extends DayEventsState {
  @override
  List<Object?> get props => [];
}

final class DayEventsLoading extends DayEventsState {
  @override
  List<Object> get props => [];
}

final class DayEventsLoaded extends DayEventsState {
  final List<Event> events;

  const DayEventsLoaded({required this.events});

  @override
  List<Object?> get props => [events];
}

class DayEventsLoadingError extends DayEventsState {
  final String message;

  const DayEventsLoadingError({required this.message});

  @override
  List<Object?> get props => [message];
}
