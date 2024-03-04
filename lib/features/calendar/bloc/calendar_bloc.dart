import 'dart:async';
import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:keym_calendar/repositories/calendar/calendar_repository.dart';
import 'package:keym_calendar/repositories/calendar/models/event.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc(this._calendarRepository) : super(CalendarInitial()) {
    on<LoadCalendar>(_load);
    on<AddEvent>(_addEvent);
  }

  final CalendarRepository _calendarRepository;

  void _load(LoadCalendar event, Emitter<CalendarState> emit) async {
    if (!_calendarRepository.isDatabaseInitialized) {
      emit(CalendarLoading());
      try {
        await _calendarRepository.open();
      } catch (e) {
        log(e.toString());
        return;
      }
    }

    try {
      final events = await _calendarRepository.getAllEvents();
      emit(CalendarLoaded(events: events));
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _addEvent(AddEvent event, Emitter<CalendarState> emit) async {
    if (!_calendarRepository.isDatabaseInitialized) {
      emit(CalendarLoading());
      try {
        await _calendarRepository.open();
      } catch (e) {
        log(e.toString());
        return;
      }
    }

    try {
      await _calendarRepository.insertEvent(event.event);
      final currentState = state;
      if (currentState is CalendarLoaded) {
        final updatedEvents = List.of(currentState.events)..add(event.event);
        emit(CalendarLoaded(events: updatedEvents));
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
