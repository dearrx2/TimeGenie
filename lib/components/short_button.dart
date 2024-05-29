import 'package:flutter/material.dart';
import '../utils/color_utils.dart';

class ShortButton extends StatelessWidget {
  final String titleLeft;
  final String titleRight;
  final Function()? ontapLeft;
  final Function()? ontapRight;

  const ShortButton({
    Key? key,
    required this.titleLeft,
    required this.titleRight,
    required this.ontapLeft,
    required this.ontapRight,
  }) : super(key: key); // Use super constructor to pass key

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width ,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.40,
              height: 48,
              child: ElevatedButton(
                  onPressed: ontapLeft,
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color>((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.orangeAccent;
                        }
                        return white;
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: orange)))),
                  child: Text(
                    titleLeft,
                    style: const TextStyle(color: orange, fontSize: 14),
                  )),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              height: 48,
              child: ElevatedButton(
                  onPressed: ontapRight,
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color>((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.orange;
                        }
                        return orange;
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: orange)))),
                  child: Text(
                    titleRight,
                    style: const TextStyle(color: white, fontSize: 14),
                  )),
            ),
          ],
        ));
  }
}
