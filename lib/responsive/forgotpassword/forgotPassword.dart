import 'package:flutter/material.dart';
import '../responsive_layout.dart';
import 'forgotPassword_mobile.dart';
import 'forgotPassword_web.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: const ForgotPasswordPageMobile(),
        desktopBody: const ForgotPasswordWebPage(),
      ),
    );
  }
}
