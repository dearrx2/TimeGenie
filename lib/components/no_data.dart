import 'package:flutter/material.dart';

class noData extends StatelessWidget {
  final String text;

  const noData({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0), // Add bottom padding
          child: Image.asset(
            'assets/images/no_data/no_data.png',
            width: 150,
            height: 125,
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}

