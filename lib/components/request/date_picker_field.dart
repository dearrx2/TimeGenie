import 'package:flutter/material.dart';
import '../../utils/color_utils.dart';

class SelectDateFormField extends StatefulWidget {
  final String title;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validate;

  const SelectDateFormField({
    Key? key,
    required this.title,
    required this.hint,
    required this.controller,
    required this.validate,
  }) : super(key: key);

  @override
  State<SelectDateFormField> createState() => _SelectDateFormFieldState();
}

class _SelectDateFormFieldState extends State<SelectDateFormField> {

  @override
  void initState() {
    super.initState();
  }

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
                widget.title,
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
                errorStyle: const TextStyle(
                  fontSize: 12,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today, color: orange,),
                  onPressed: () {},
                ),
              ),
              controller: widget.controller,
              validator: widget.validate,
              style: const TextStyle(
                 // Font style for input text
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
