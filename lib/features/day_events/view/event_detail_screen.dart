import 'dart:io';
import 'package:flutter/material.dart';

import 'package:keym_calendar/features/day_events/widgets/update_delete_bottom_sheet.dart';
import 'package:keym_calendar/helpers/date_formater.dart';
import 'package:keym_calendar/repositories/calendar/models/event.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateTimeHelper.formatDateTimeOnlyDate(event.dateTime);
    final formattedTime = DateTimeHelper.formatDateTimeOnlyTime(event.dateTime);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  showUpdateDeleteBottomSheet(
                      context: context, event: event, isDetailScreenEdit: true);
                },
                icon: const Icon(Icons.edit_note),
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DateTimeRow(
                      formattedDateTime: formattedDate, icon: Icons.date_range),
                  const SizedBox(height: 7),
                  DateTimeRow(
                      formattedDateTime: formattedTime, icon: Icons.timer),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      event.description,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            if (event.photoPath != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    fit: BoxFit.cover,
                    File(event.photoPath!),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DateTimeRow extends StatelessWidget {
  const DateTimeRow({
    super.key,
    required this.formattedDateTime,
    required this.icon,
  });

  final String formattedDateTime;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        Text(
          formattedDateTime,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
