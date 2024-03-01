import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keym_calendar/repositories/calendar/abstarct_calendar_repository.dart';
import 'package:keym_calendar/repositories/calendar/models/event.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc(this._calendarRepository) : super(CalendarInitial()) {
    on<LoadCalendar>(_load);
  }
  final AbstractCalendarRepository _calendarRepository;

  Future<void> _load(
    LoadCalendar event,
    Emitter<CalendarState> emit,
  ) async {
    try {
      if (!_calendarRepository.isDatabaseInitialized) {
        await _calendarRepository.open();
      }
      final events = await _calendarRepository.getAllEvents();
      emit(CalendarLoaded(events: events));
      log(events[2].dateTime.toIso8601String());
    } catch (e) {
      log(e.toString());
    }
  }
}
