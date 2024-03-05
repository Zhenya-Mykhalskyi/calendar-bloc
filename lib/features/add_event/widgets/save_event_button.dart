import 'package:flutter/material.dart';

class SaveEventButton extends StatelessWidget {
  final Function onSave;

  const SaveEventButton({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onSave();
        Navigator.of(context).pop();
      },
      child: const Text('Save'),
    );
  }
}
