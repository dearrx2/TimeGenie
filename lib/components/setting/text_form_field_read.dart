import 'package:flutter/material.dart';

import '../../utils/color_utils.dart';

class ShowField extends StatelessWidget {
  final String title;
  final String hint;

  const ShowField({
    Key? key,
    required this.title,
    required this.hint,
  }) : super(key: key); // Use super constructor to pass key

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
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
          TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
