import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../responsive/forgotpassword/forgotPassword.dart';
import '../../utils/color_utils.dart';

class PasswordCard extends StatefulWidget {
  final String icon;
  final String text;
  const PasswordCard({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  State<PasswordCard> createState() => _PasswordCardState();
}

class _PasswordCardState extends State<PasswordCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
      child: Column(children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ForgotPasswordPage()),
            );
          },
          child: Container(
            height: 88,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: veryGrey,
                  blurRadius: 2.0,
                  spreadRadius: 2.0,
                  offset: Offset(2.0, 2.0),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  SvgPicture.asset(
                    widget.icon,
                    width: 32,
                    height: 32,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: SizedBox(
                      width: 260,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.text,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
