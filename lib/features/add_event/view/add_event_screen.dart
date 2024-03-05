import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:keym_calendar/features/calendar/bloc/calendar_bloc.dart';
import 'package:keym_calendar/features/day_events/bloc/day_events_bloc.dart';
import 'package:keym_calendar/features/add_event/widgets/date_time_picker.dart';
import 'package:keym_calendar/features/add_event/widgets/image_picker.dart';
import 'package:keym_calendar/features/add_event/widgets/save_event_button.dart';
import 'package:keym_calendar/repositories/calendar/models/event.dart';

class AddEventScreen extends StatefulWidget {
  final Event? event;
  final bool? isDetailScreenEdit;

  const AddEventScreen({Key? key, this.event, this.isDetailScreenEdit})
      : super(key: key);

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _cirrentImagePath;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _titleController.text = widget.event!.title;
      _descriptionController.text = widget.event!.description;
      _selectedDate = widget.event!.dateTime;
      _cirrentImagePath = widget.event!.photoPath;
    }
  }

  void _handleImagePicked(File? image) {
    _pickedImage = image;
  }

  void _handleDatePicked(DateTime? dateTime) {
    setState(() {
      _selectedDate = dateTime!;
    });
  }

  void _saveEvent(BuildContext context) {
    final event = Event(
      id: widget.event?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      description: _descriptionController.text,
      dateTime: _selectedDate,
      photoPath: _pickedImage != null ? _pickedImage!.path : _cirrentImagePath,
    );

    if (widget.event == null) {
      BlocProvider.of<CalendarBloc>(context).add(AddEvent(event));
    } else {
      BlocProvider.of<CalendarBloc>(context).add(UpdateEvent(event));
      BlocProvider.of<DayEventsBloc>(context)
          .add(LoadEventsForDay(selectedDay: event.dateTime));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event == null ? 'Add Event' : 'Update Event'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SaveEventButton(
              onSave: () => _saveEvent(context),
              isDetailScreenEdit: widget.isDetailScreenEdit,
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
              onImagePicked: _handleImagePicked,
              currentImagePath: _cirrentImagePath,
            ),
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
                currentDateTime: _selectedDate,
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
