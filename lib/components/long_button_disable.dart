import 'package:flutter/material.dart';

class LongButtonDisable extends StatelessWidget {
  final String title;
  final Color textColor;
  final Color disabledColor;
  final void Function()? onTap;

  const LongButtonDisable({
    required this.title,
    required this.textColor,
    required this.disabledColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: disabledColor,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
