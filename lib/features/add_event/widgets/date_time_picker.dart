// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:keym_calendar/helpers/date_formater.dart';

class DatePicker extends StatefulWidget {
  final void Function(DateTime? dateTime) onDatePicked;
  const DatePicker({super.key, required this.onDatePicked});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );
      if (pickedTime != null) {
        final DateTime pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        _selectedDate = pickedDateTime;
        widget.onDatePicked(_selectedDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _selectDate(context),
      child: Row(
        children: [
          const Icon(Icons.timer),
          const SizedBox(width: 10),
          Text(
            'Selected Date: ${DateTimeHelper.formatDateTime(_selectedDate)}',
          ),
        ],
      ),
    );
  }
}
