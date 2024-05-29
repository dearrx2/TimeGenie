import 'package:flutter/material.dart';
import 'package:untitled/responsive/app/resetpassword/forgotpassword_screen_web.dart';

import '../../responsive_layout.dart';
import 'forgotpassword_screen_mobile.dart';

class ForgetPage extends StatefulWidget {
  const ForgetPage({Key? key}) : super(key: key);

  @override
  _ForgetPageState createState() => _ForgetPageState();
}

class _ForgetPageState extends State<ForgetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: const ForgotPasswordScreenMobile(),
        desktopBody: const ForgotPasswordScreenWeb(),
      ),
    );
  }
}
