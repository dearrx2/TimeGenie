import 'package:flutter/material.dart';
import '../utils/color_utils.dart';

class CheckInButton extends StatelessWidget {
  final String title;
  final Function()? ontap;
  final Color backgroundColor; // Add backgroundColor argument

  const CheckInButton({
    Key? key,
    required this.title,
    required this.ontap,
    required this.backgroundColor, // Add backgroundColor as a required argument
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 50,
      child: ElevatedButton(
        onPressed: ontap,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            return isCheckInEnabled() ? backgroundColor : const Color(0xFFD8D8D8);
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Replace this method with your actual implementation of isCheckInEnabled()
  bool isCheckInEnabled() {
    // Return true or false based on your conditions to enable/disable the button
    return true;
  }
}
