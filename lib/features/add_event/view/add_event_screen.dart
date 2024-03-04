import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:image_picker/image_picker.dart';

import 'package:keym_calendar/features/calendar/bloc/calendar_bloc.dart';
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

  final ImagePicker _picker = ImagePicker();
  String? _imagePath;

  Future<void> _getImageFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _getImageFromCamera() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Event'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_imagePath != null)
              Image.asset(_imagePath!)
            else
              ElevatedButton(
                onPressed: _getImageFromGallery,
                child: const Text('Add Image from Gallery'),
              ),
            ElevatedButton(
              onPressed: _getImageFromCamera,
              child: const Text('Take a Picture'),
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Event Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Event Description'),
            ),
            TextButton(
              onPressed: () => _selectDate(context),
              child: Text(
                  'Selected Date: ${_selectedDate.toLocal()}'.split(' ')[0]),
            ),
            ElevatedButton(
              onPressed: () {
                final id = DateTime.now().millisecondsSinceEpoch.toString();
                final event = Event(
                    id: id,
                    title: _titleController.text,
                    description: _descriptionController.text,
                    dateTime: _selectedDate,
                    photoPath: _imagePath);
                context.read<CalendarBloc>().add(AddEvent(event));
                Navigator.of(context).pop();
              },
              child: const Text('Save Event'),
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
