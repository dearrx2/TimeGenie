import 'package:flutter/material.dart';

import '../../utils/color_utils.dart';

class SetPasswordFormField extends StatefulWidget {
  final String title;
  final String hint;
  final bool checker;
  final TextEditingController controller;
  final String? Function(String?)? validate;

  const SetPasswordFormField({
    Key? key,
    required this.title,
    required this.hint,
    required this.checker,
    required this.controller,
    required this.validate,
  }) : super(key: key);

  @override
  State<SetPasswordFormField> createState() => _SetPasswordFormFieldState();
}

class _SetPasswordFormFieldState extends State<SetPasswordFormField> {
  late bool check;

  @override
  void initState() {
    super.initState();
    check = widget.checker;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: grey),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              hintText: widget.hint,
              hintStyle: const TextStyle(
                fontSize: 14,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  check ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    check = !check; // Update the local variable 'check'
                  });
                },
              ),
            ),
            controller: widget.controller,
            obscureText: !check, // Use the updated 'check' variable
            validator: widget.validate,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
