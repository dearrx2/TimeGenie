import 'package:flutter/material.dart';

class LongButton extends StatelessWidget {
  final String title;
  final Function()? ontap;

  const LongButton({
    Key? key,
    required this.title,
    required this.ontap,
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
            return isCheckInEnabled() ? const Color(0xFFFF9300) : const Color(0xFFD8D8D8); //orange-white
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

  bool isCheckInEnabled() {
    return true;
  }
}
