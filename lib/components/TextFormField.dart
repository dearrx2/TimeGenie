import 'package:flutter/material.dart';
import '../utils/color_utils.dart';

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
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: TextFormField(
              maxLines: null,
              textInputAction: TextInputAction.newline,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              controller: controller,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                hintText: hint,
                hintStyle: const TextStyle(
                  fontSize: 14,
                ),
                errorStyle: const TextStyle(
                  fontSize: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: grey),
                ),
              ),
              validator: validate,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
