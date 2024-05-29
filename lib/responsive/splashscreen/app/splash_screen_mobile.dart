import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/responsive/app/home/home_screen.dart';
import 'package:untitled/utils/color_utils.dart';

import '../../app/main/main_page.dart';
import '../../app/setting/setting_screen.dart';
import '../../signin/signin_screen.dart';

class AppSplashScreenMobile extends StatefulWidget {
  const AppSplashScreenMobile({Key? key}) : super(key: key);

  @override
  State<AppSplashScreenMobile> createState() => _SplashScreenMobileState();
}

class _SplashScreenMobileState extends State<AppSplashScreenMobile> {
  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences? _prefs;
  var genie = 'assets/svg/splash_screen/genie.svg';
  @override
  Widget build(BuildContext context) {
    // return StreamBuilder<User?>(
    //     stream: FirebaseAuth.instance.authStateChanges(),
    //     builder: (BuildContext context, AsyncSnapshot snapshot) {
    //       if (snapshot.hasError) {
    //         return Text(snapshot.error.toString());
    //       }
    //       if (snapshot.connectionState == ConnectionState.active) {
    //         if (snapshot.data == null) {
    //           return const SignInPage();
    //         } else {
    //           // return HomeScreenPage(
    //           //     uid: FirebaseAuth.instance.currentUser!.uid);
    //           return const SettingPage();
    //         }
    //       }
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     });
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [backgroundLow, backgroundHigh],
        )),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                genie,
                width: 160,
                height: 160,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _initSharedPreferences() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _prefs = prefs;
        Timer(const Duration(seconds: 2), () {
          _checkIfAlreadySignedIn();
        });
      });
    });
  }

  void _checkIfAlreadySignedIn() {
    final String? storedEmail = _prefs?.getString('email');
    final String? storedPassword = _prefs?.getString('password');

    if (storedEmail != null && storedPassword != null) {
      _auth
          .signInWithEmailAndPassword(
        email: storedEmail,
        password: storedPassword,
      )
          .then((userCredential) {
        User? user = userCredential.user;
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreenPage(
                      uid: FirebaseAuth.instance.currentUser!.uid,
                    )),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignInPage()),
          );
        }
      }).catchError((e) {
        // Handle sign-in error
        if (kDebugMode) {
          print("Error: $e");
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInPage()),
        );
      });
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const SignInPage()));
    }
  }
}
