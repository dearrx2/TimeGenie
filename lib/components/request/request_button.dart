import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled/utils/color_utils.dart';

class RequestButton extends StatelessWidget {
  final String label;
  final String icon;
  final VoidCallback onPressed;
  final Color bgButton;
  final TextStyle textStyle;

  const RequestButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.bgButton,
    required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgButton,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.40,
        height: MediaQuery.of(context).size.height * 0.19,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: 70.0,
              height: 70.0,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}

