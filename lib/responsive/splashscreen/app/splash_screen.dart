import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/responsive/splashscreen/app/splash_screen_mobile.dart';
import 'package:untitled/responsive/splashscreen/app/splash_screen_web.dart';

import '../../responsive_layout.dart';
import '../../signup/signup_screen_mobile.dart';
import '../signup/splash_screen_mobile.dart';

class AppSplashPage extends StatefulWidget {
  const AppSplashPage({Key? key}) : super(key: key);

  @override
  _AppSplashPageState createState() => _AppSplashPageState();
}

class _AppSplashPageState extends State<AppSplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: const AppSplashScreenMobile(),
        desktopBody: const AppSplashWebScreen(),
      ),
    );
  }
}
