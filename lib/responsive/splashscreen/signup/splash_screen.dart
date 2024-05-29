import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/responsive/splashscreen/signup/splash_screen_mobile.dart';
import 'package:untitled/responsive/splashscreen/signup/splash_screen_web.dart';

import '../../responsive_layout.dart';

class SignUpSplashPage extends StatefulWidget {
  const SignUpSplashPage({Key? key}) : super(key: key);

  @override
  _SignUpSplashPageState createState() => _SignUpSplashPageState();
}

class _SignUpSplashPageState extends State<SignUpSplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody:
            FinishSignUpMobile(uid: FirebaseAuth.instance.currentUser!.uid),
        desktopBody:
            FinishSignUpWeb(uid: FirebaseAuth.instance.currentUser!.uid),
      ),
    );
  }
}
