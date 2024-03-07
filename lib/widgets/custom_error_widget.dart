import 'package:flutter/material.dart';

import 'package:keym_calendar/theme/app_colors.dart';

class CustomErrorWidget extends StatelessWidget {
  final String errorMessage;
  final void Function()? onPressed;

  const CustomErrorWidget(
      {super.key, required this.errorMessage, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Error occurred:',
            style: TextStyle(color: AppColors.errorColor),
          ),
          Text(
            errorMessage,
            style: const TextStyle(color: AppColors.errorColor),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: onPressed,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
