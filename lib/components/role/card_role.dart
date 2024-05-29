import 'package:flutter/material.dart';

class CardRole extends StatelessWidget {
  final String imagePath;
  final Function()? onTap;
  const CardRole({super.key, required this.imagePath, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Image.asset(
            imagePath,
            height: MediaQuery.of(context).size.height * 0.24,
            width: MediaQuery.of(context).size.width * 0.24,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
