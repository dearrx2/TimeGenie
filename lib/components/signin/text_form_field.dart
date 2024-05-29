import 'package:flutter/material.dart';

import '../../utils/color_utils.dart';

class SetTextFormField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validate;

  const SetTextFormField({
    Key? key,
    required this.title,
    required this.hint,
    required this.controller,
    required this.validate,
  }) : super(key: key); // Use super constructor to pass key

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              hintText: hint, // Use the hint parameter
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: grey),
              ),
            ),
            validator: validate,
          ),
        ),
      ],
    );
  }
}
