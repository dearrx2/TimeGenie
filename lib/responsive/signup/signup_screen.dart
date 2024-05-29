import 'package:flutter/material.dart';
import 'package:untitled/responsive/signup/signup_screen_mobile.dart';
import 'package:untitled/responsive/signup/signup_screen_web.dart';

import '../responsive_layout.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: const SignUpScreenMobile(),
        desktopBody: const SignUpScreenWeb(),
      ),
    );
  }
}
