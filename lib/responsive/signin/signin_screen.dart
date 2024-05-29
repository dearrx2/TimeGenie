import 'package:flutter/material.dart';
import 'package:untitled/responsive/signin/signin_screen_mobile.dart';
import 'package:untitled/responsive/signin/signin_screen_web.dart';

import '../responsive_layout.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: const SignInScreenMobile(),
        desktopBody: const SignInScreenWeb(),
      ),
    );
  }
}
