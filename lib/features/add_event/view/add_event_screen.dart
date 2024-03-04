import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:keym_calendar/features/add_event/widgets/date_time_picker.dart';
import 'package:keym_calendar/features/add_event/widgets/pick_image.dart';
import 'package:keym_calendar/features/add_event/widgets/save_event_button.dart';
import 'package:keym_calendar/repositories/calendar/models/event.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({Key? key}) : super(key: key);

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _imagePath;

  void _handleImagePicked(String? imagePath) {
    setState(() {
      _imagePath = imagePath;
    });
  }

  void _handleDatePicked(DateTime? dateTime) {
    setState(() {
      _selectedDate = dateTime!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Event'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SaveEventButton(
              event: Event(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: _titleController.text,
                  description: _descriptionController.text,
                  dateTime: _selectedDate,
                  photoPath: _imagePath),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PickImage(
                onImagePicked: _handleImagePicked, currentImagePath: null),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Event Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Event Description'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: DatePicker(
                onDatePicked: _handleDatePicked,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                String databasesPath = await getDatabasesPath();
                String path = join(databasesPath, 'calendar_database.db');
                await deleteDatabase(path);
              },
              child: const Text('delete DB'),
            ),
          ],
        ),
      ),
    );
  }
}
