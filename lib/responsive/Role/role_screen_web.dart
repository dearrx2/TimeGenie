import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:untitled/components/role/card_role.dart';
import 'package:untitled/responsive/splashscreen/signup/splash_screen_web.dart';
import '../../components/short_button.dart';
import '../../utils/localizations.dart';

class SelectRoleWeb extends StatefulWidget {
  final String image;
  final String name;
  final String email;
  final String phone;
  final String code;
  final String password;

  const SelectRoleWeb({
    Key? key,
    required this.image,
    required this.name,
    required this.email,
    required this.phone,
    required this.code,
    required this.password,
  }) : super(key: key);

  @override
  State<SelectRoleWeb> createState() => _SelectRoleWebState();
}

class _SelectRoleWebState extends State<SelectRoleWeb> {
  late String role = "...";
  late String staff = "assets/images/role/staff.png";
  late String senior = "assets/images/role/senior.png";
  late String manager = "assets/images/role/manager.png";

  Future<void> _createAccount() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.email,
        password: widget.password,
      );
      final userId = userCredential.user!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'image': widget.image,
        'userID': userId,
        'name': widget.name,
        'email': widget.email,
        'phone': widget.phone,
        'employeeCode': widget.code,
        'role': role,
      });

      // Navigate to the HomeScreen after successful registration
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                FinishSignUpWeb(uid: FirebaseAuth.instance.currentUser!.uid)),
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg_image.png"),
              fit: BoxFit.fill)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            MyLocalizations.translate("text_YouAre") + role,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CardRole(
                          imagePath: staff,
                          onTap: () {
                            setState(() {
                              role = MyLocalizations.translate("text_Staff");
                              if (staff == "assets/images/role/staff.png") {
                                staff = "assets/images/role/staff_choose.png";
                                manager = "assets/images/role/manager.png";
                                senior = "assets/images/role/senior.png";
                              } else {
                                staff = "assets/images/role/staff.png";
                                role = "...";
                              }
                            });
                          }),
                      CardRole(
                          imagePath: senior,
                          onTap: () {
                            setState(() {
                              role = MyLocalizations.translate("text_Senior");
                              if (senior == "assets/images/role/senior.png") {
                                senior = "assets/images/role/senior_choose.png";
                                staff = "assets/images/role/staff.png";
                                manager = "assets/images/role/manager.png";
                              } else {
                                senior = "assets/images/role/senior.png";
                                role = "...";
                              }
                            });
                          }),
                      CardRole(
                          imagePath: manager,
                          onTap: () {
                            setState(() {
                              role = MyLocalizations.translate("text_Manager");
                              if (manager == "assets/images/role/manager.png") {
                                manager =
                                    "assets/images/role/manager_choose.png";
                                staff = "assets/images/role/staff.png";
                                senior = "assets/images/role/senior.png";
                              } else {
                                manager = "assets/images/role/manager.png";
                                role = "...";
                              }
                            });
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // const SizedBox(
          //   height: 300,
          // ),
          SizedBox(
            child: Column(
              children: [
                ShortButton(
                    titleLeft: MyLocalizations.translate("button_Cancel"),
                    titleRight:
                        MyLocalizations.translate("button_CreateAccount"),
                    ontapLeft: () {
                      Navigator.pop(context);
                    },
                    // ontapRight: _createAccount)
                    ontapRight: _createAccount),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
