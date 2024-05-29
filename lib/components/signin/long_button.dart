import 'package:flutter/material.dart';

import '../../utils/color_utils.dart';

class LongButton extends StatelessWidget {
  final String title;
  final Function()? ontap;

  const LongButton({
    Key? key,
    required this.title,
    required this.ontap,
  }) : super(key: key); // Use super constructor to pass key

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 50,
        child: ElevatedButton(
            onPressed: ontap,
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return grey;
                  }
                  return orange;
                }),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: orange)))),
            child: Text(
              title,
              style: const TextStyle(color: white, fontSize: 16),
            )));
  }
}
