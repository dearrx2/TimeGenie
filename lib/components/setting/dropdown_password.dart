import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../utils/color_utils.dart';
import '../TextFormField.dart';
import '../long_button.dart';

class DropDownPasswordCard extends StatefulWidget {
  final String icon;
  final String text;
  final bool checker;
  const DropDownPasswordCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.checker,
  }) : super(key: key);

  @override
  State<DropDownPasswordCard> createState() => _DropDownPasswordCardState();
}

class _DropDownPasswordCardState extends State<DropDownPasswordCard> {
  late bool check;
  final TextEditingController _oldPasswordTextController =
      TextEditingController();
  final TextEditingController _newPasswordTextController =
      TextEditingController();
  final TextEditingController _confirmPasswordTextController =
      TextEditingController();
  @override
  void initState() {
    super.initState();
    check = widget.checker;
  }

  void toggleVisibility() {
    setState(() {
      check = !check;
    });
  }

  var newPassword = "123456";
  void _update() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.updatePassword(newPassword);
      } catch (e) {
        if (kDebugMode) {
          print('Error $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
        onTap: toggleVisibility,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 0.9,
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
                        IconButton(
                          onPressed: toggleVisibility,
                          icon: Icon(
                            check
                                ? Icons.keyboard_arrow_up_outlined
                                : Icons.keyboard_arrow_down_outlined,
                            size: 32,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Visibility(
        visible: check,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12.0),
              bottomRight: Radius.circular(12.0),
            ),
            color: white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 2.0,
                spreadRadius: 2.0,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                SetTextFormField(
                    title: "Old password",
                    hint: "Old password",
                    controller: _oldPasswordTextController,
                    validate: null),
                SetTextFormField(
                    title: "Phone Number",
                    hint: "Create password",
                    controller: _newPasswordTextController,
                    validate: null),
                SetTextFormField(
                    title: "Phone Number",
                    hint: "Create password",
                    controller: _confirmPasswordTextController,
                    validate: null),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: LongButton(title: "Save", ontap: _update))
              ],
            ),
          ),
        ),
      )
    ]);
  }
}
