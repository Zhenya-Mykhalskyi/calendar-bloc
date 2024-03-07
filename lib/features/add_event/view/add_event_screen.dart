import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:keym_calendar/features/calendar/bloc/calendar_bloc.dart';
import 'package:keym_calendar/features/day_events/bloc/day_events_bloc.dart';
import 'package:keym_calendar/features/add_event/widgets/date_time_picker.dart';
import 'package:keym_calendar/features/add_event/widgets/image_picker.dart';
import 'package:keym_calendar/repositories/calendar/models/event.dart';
import 'package:keym_calendar/features/add_event/widgets/custom_text_form_field.dart';

class AddEventScreen extends StatefulWidget {
  final Event? event;
  final bool? isDetailScreenEdit;

  const AddEventScreen({Key? key, this.event, this.isDetailScreenEdit})
      : super(key: key);

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _eventFormKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  String? _currentImagePath;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _titleController.text = widget.event!.title;
      _descriptionController.text = widget.event!.description;
      _selectedDate = widget.event!.dateTime;
      _currentImagePath = widget.event!.photoPath;
    }
  }

  void _handleImagePicked(File? image) {
    _pickedImage = image;
  }

  void _handleDateTimePicked(DateTime? dateTime) {
    setState(() {
      _selectedDate = dateTime!;
    });
  }

  void _saveEvent(BuildContext context) {
    if (_eventFormKey.currentState!.validate()) {
      final event = Event(
        id: widget.event?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dateTime: _selectedDate,
        photoPath:
            _pickedImage != null ? _pickedImage!.path : _currentImagePath,
      );

      if (widget.event == null) {
        BlocProvider.of<CalendarBloc>(context).add(AddEvent(event));
      } else {
        BlocProvider.of<CalendarBloc>(context).add(UpdateEvent(event));
        BlocProvider.of<DayEventsBloc>(context)
            .add(LoadEventsForDay(selectedDay: event.dateTime));
      }
      if (widget.isDetailScreenEdit == true) {
        Navigator.of(context).pop();
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.event == null ? 'Add Event' : 'Update Event'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: () => _saveEvent(context),
              child: const Text('Save'),
            ),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _eventFormKey,
            child: Column(
              children: [
                PickImage(
                  onImagePicked: _handleImagePicked,
                  currentImagePath: _currentImagePath,
                ),
                CustomTextFormField(
                  controller: _titleController,
                  maxLength: 70,
                  labelText: 'Event Title',
                ),
                CustomTextFormField(
                  controller: _descriptionController,
                  maxLength: 400,
                  labelText: 'Event Description',
                  isDescription: true,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DateTimePicker(
                        isTimePicker: false,
                        onDatePicked: _handleDateTimePicked,
                        currentDateTime: _selectedDate,
                      ),
                      DateTimePicker(
                        isTimePicker: true,
                        onDatePicked: _handleDateTimePicked,
                        currentDateTime: _selectedDate,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
