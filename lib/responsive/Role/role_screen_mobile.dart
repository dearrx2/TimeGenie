import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:untitled/components/role/card_role.dart';
import 'package:untitled/responsive/app/main/main_page.dart';
import '../../components/short_button.dart';
import '../../utils/color_utils.dart';
import '../../utils/localizations.dart';
import '../signin/signin_screen.dart';

class SelectRoleMobile extends StatefulWidget {
  final String image;
  final String name;
  final String email;
  final String phone;
  final String code;
  final String password;

  const SelectRoleMobile({
    Key? key,
    required this.image,
    required this.name,
    required this.email,
    required this.phone,
    required this.code,
    required this.password,
  }) : super(key: key);

  @override
  State<SelectRoleMobile> createState() => _SelectRoleMobileState();
}

class _SelectRoleMobileState extends State<SelectRoleMobile> {
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

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) =>
      //           HomeScreenPage(uid: FirebaseAuth.instance.currentUser!.uid)),
      // );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const SignInPage()));
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.14,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [backgroundLow, backgroundHigh],
              )),
            ),
            Container(
              color: backgroundHigh,
              child: Container(
                decoration: const BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(42),
                        topRight: Radius.circular(42))),
                height: MediaQuery.of(context).size.height * 0.81,
                width: MediaQuery.of(context).size.width * 1,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 26),
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              MyLocalizations.translate("text_YouAre") + role,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: SizedBox(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CardRole(
                                            imagePath: staff,
                                            onTap: () {
                                              setState(() {
                                                role =
                                                    MyLocalizations.translate(
                                                        "text_Staff");
                                                if (staff ==
                                                    "assets/images/role/staff.png") {
                                                  staff =
                                                      "assets/images/role/staff_choose.png";
                                                  manager =
                                                      "assets/images/role/manager.png";
                                                  senior =
                                                      "assets/images/role/senior.png";
                                                } else {
                                                  staff =
                                                      "assets/images/role/staff.png";
                                                  role = "...";
                                                }
                                              });
                                            }),
                                        CardRole(
                                            imagePath: senior,
                                            onTap: () {
                                              setState(() {
                                                role =
                                                    MyLocalizations.translate(
                                                        "text_Senior");
                                                if (senior ==
                                                    "assets/images/role/senior.png") {
                                                  senior =
                                                      "assets/images/role/senior_choose.png";
                                                  staff =
                                                      "assets/images/role/staff.png";
                                                  manager =
                                                      "assets/images/role/manager.png";
                                                } else {
                                                  senior =
                                                      "assets/images/role/senior.png";
                                                  role = "...";
                                                }
                                              });
                                            }),
                                        CardRole(
                                            imagePath: manager,
                                            onTap: () {
                                              setState(() {
                                                role =
                                                    MyLocalizations.translate(
                                                        "text_Manager");
                                                if (manager ==
                                                    "assets/images/role/manager.png") {
                                                  manager =
                                                      "assets/images/role/manager_choose.png";
                                                  staff =
                                                      "assets/images/role/staff.png";
                                                  senior =
                                                      "assets/images/role/senior.png";
                                                } else {
                                                  manager =
                                                      "assets/images/role/manager.png";
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
                            SizedBox(
                              child: Column(
                                children: [
                                  ShortButton(
                                      titleLeft: MyLocalizations.translate(
                                          "button_Cancel"),
                                      titleRight: MyLocalizations.translate(
                                          "button_CreateAccount"),
                                      ontapLeft: () {
                                        Navigator.pop(context);
                                      },
                                      ontapRight: _createAccount),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
