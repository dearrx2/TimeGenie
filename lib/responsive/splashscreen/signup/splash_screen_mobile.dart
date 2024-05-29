import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../app/main/main_page.dart';

class FinishSignUpMobile extends StatefulWidget {
  final String uid;
  const FinishSignUpMobile({Key? key, required this.uid}) : super(key: key);

  @override
  State<FinishSignUpMobile> createState() => _FinishSignUpScreenMobileState();
}

class _FinishSignUpScreenMobileState extends State<FinishSignUpMobile> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomeScreenPage(uid: FirebaseAuth.instance.currentUser!.uid)));
    });
  }

  @override
  Widget build(BuildContext context) {
    const String logo = 'assets/svg/finish_signup.svg';
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg_image.png"),
                fit: BoxFit.cover)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                logo,
                width: 240,
                height: 240,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
