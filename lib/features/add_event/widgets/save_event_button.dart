import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:keym_calendar/features/calendar/bloc/calendar_bloc.dart';
import 'package:keym_calendar/repositories/calendar/models/event.dart';

class SaveEventButton extends StatelessWidget {
  final Event event;
  const SaveEventButton({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<CalendarBloc>().add(AddEvent(event));
        Navigator.of(context).pop();
      },
      child: const Text('Save'),
    );
  }
}
