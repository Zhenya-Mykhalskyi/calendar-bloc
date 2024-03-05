import 'package:flutter/material.dart';

class SaveEventButton extends StatelessWidget {
  final Function onSave;
  final bool? isDetailScreenEdit;

  const SaveEventButton(
      {super.key, required this.onSave, this.isDetailScreenEdit});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onSave();
        if (isDetailScreenEdit == true) {
          Navigator.of(context).pop();
        }
        Navigator.of(context).pop();
      },
      child: const Text('Save'),
    );
  }
}
