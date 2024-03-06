import 'package:flutter/material.dart';

import 'package:keym_calendar/helpers/date_formater.dart';

class DatePicker extends StatefulWidget {
  final void Function(DateTime? dateTime) onDatePicked;
  final bool isTimePicker;
  final DateTime? currentDateTime;

  const DatePicker({
    Key? key,
    required this.onDatePicked,
    required this.currentDateTime,
    required this.isTimePicker,
  }) : super(key: key);

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.currentDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final DateTime newDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        widget.currentDateTime?.hour ?? 0,
        widget.currentDateTime?.minute ?? 0,
      );

      setState(() {
        _selectedDate = newDateTime;
      });
      widget.onDatePicked(_selectedDate);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay.fromDateTime(widget.currentDateTime ?? DateTime.now()),
    );

    if (pickedTime != null) {
      final DateTime newDateTime = DateTime(
        widget.currentDateTime!.year,
        widget.currentDateTime!.month,
        widget.currentDateTime!.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      setState(() {
        _selectedDate = newDateTime;
      });
      widget.onDatePicked(_selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () =>
          widget.isTimePicker ? _selectTime(context) : _selectDate(context),
      child: Row(
        children: [
          Icon(widget.isTimePicker ? Icons.timer : Icons.calendar_today),
          const SizedBox(width: 10),
          Text(
            widget.isTimePicker
                ? DateTimeHelper.formatDateTimeOnlyTime(
                    widget.currentDateTime ?? _selectedDate)
                : DateTimeHelper.formatDateTimeOnlyDate(
                    widget.currentDateTime ?? _selectedDate),
          ),
        ],
      ),
    );
  }
}
