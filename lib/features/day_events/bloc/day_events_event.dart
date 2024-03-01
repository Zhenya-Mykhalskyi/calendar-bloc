part of 'day_events_bloc.dart';

abstract class DayEventsEvent extends Equatable {
  const DayEventsEvent();
}

class LoadEventsForDay extends DayEventsEvent {
  final DateTime? selectedDay;
  const LoadEventsForDay({this.selectedDay});

  @override
  List<Object?> get props => [selectedDay];
}
