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
    on<LoadCalendar>(_loadEvents);
    on<AddEvent>(_addEvent);
    on<DeleteEvent>(_deleteEvent);
    on<UpdateEvent>(_updateEvent);
  }

  final CalendarRepository _calendarRepository;

  void _loadEvents(LoadCalendar event, Emitter<CalendarState> emit) async {
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
      emit(CalendarLoadingError(message: e.toString()));
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

  Future<void> _updateEvent(
      UpdateEvent event, Emitter<CalendarState> emit) async {
    try {
      await _calendarRepository.updateEvent(event.event);
      final currentState = state;
      if (currentState is CalendarLoaded) {
        final updatedEvents = List.of(currentState.events);
        final index = updatedEvents.indexWhere((e) => e.id == event.event.id);
        if (index != -1) {
          updatedEvents[index] = event.event;
          emit(CalendarLoaded(events: updatedEvents));
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _deleteEvent(
      DeleteEvent event, Emitter<CalendarState> emit) async {
    try {
      await _calendarRepository.deleteEvent(event.event.id);
      final currentState = state;
      if (currentState is CalendarLoaded) {
        final updatedEvents = List.of(currentState.events)
          ..removeWhere((e) => e.id == event.event.id);
        emit(CalendarLoaded(events: updatedEvents));

        log(updatedEvents.toString());
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
