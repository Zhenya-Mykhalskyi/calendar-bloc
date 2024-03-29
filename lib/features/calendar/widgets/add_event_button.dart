import 'package:flutter/material.dart';
import 'package:keym_calendar/features/add_event/view/add_event_screen.dart';

class AddEventButton extends StatelessWidget {
  const AddEventButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const AddEventScreen(),
        ));
      },
    );
  }
}
