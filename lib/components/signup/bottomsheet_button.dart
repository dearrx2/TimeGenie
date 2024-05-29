import 'package:flutter/material.dart';
import '../../utils/color_utils.dart';

class BottomSheetButton extends StatelessWidget {
  final String title;
  final Color colorText;
  final Function() ontap;

  const BottomSheetButton({
    Key? key,
    required this.title,
    required this.colorText,
    required this.ontap,
  }) : super(key: key); // Use super constructor to pass key

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.06,
            child: Center(
              child: Text(
                title,
                style: TextStyle(color: colorText,
                    fontSize: 16,
                fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (title != "Cancel" && title != "ยกเลิก" ) const Divider(color: grey), // Conditional Divider
        ],
      ),
    );
  }
}






