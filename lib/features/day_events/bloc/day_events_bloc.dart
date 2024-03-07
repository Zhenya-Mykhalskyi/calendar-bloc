import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:keym_calendar/repositories/calendar/calendar_repository.dart';
import 'package:keym_calendar/repositories/calendar/models/event.dart';

part 'day_events_event.dart';
part 'day_events_state.dart';

class DayEventsBloc extends Bloc<DayEventsEvent, DayEventsState> {
  DayEventsBloc(this._calendarRepository) : super(DayEventsInitial()) {
    on<LoadEventsForDay>(_load);
  }

  final CalendarRepository _calendarRepository;

  Future<void> _load(
    LoadEventsForDay event,
    Emitter<DayEventsState> emit,
  ) async {
    try {
      if (!_calendarRepository.isDatabaseInitialized) {
        await _calendarRepository.open();
      }
      final events = await _calendarRepository.getEventsForDay(
          dateTime: event.selectedDay!);
      emit(DayEventsLoaded(events: events));
    } catch (e) {
      emit(DayEventsLoadingError(message: e.toString()));
    }
  }
}
