import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    this.isDescription,
    required this.maxLength,
    required this.labelText,
  });

  final TextEditingController controller;
  final bool? isDescription;
  final int maxLength;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return isDescription == true
              ? 'Please enter a description'
              : 'Please enter a title';
        }
        if (value.length > maxLength) {
          return isDescription == true
              ? 'Description should not exceed 400 characters'
              : 'Title should not exceed 70 characters';
        }
        return null;
      },
      keyboardType:
          isDescription == true ? TextInputType.multiline : TextInputType.text,
      maxLines: isDescription == true ? null : 1,
      maxLength: maxLength,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: labelText,
        counterText: null,
      ),
    );
  }
}
