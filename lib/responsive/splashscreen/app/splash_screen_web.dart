import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/responsive/app/main/main_page.dart';
import '../../signin/signin_screen.dart';

class AppSplashWebScreen extends StatefulWidget {
  const AppSplashWebScreen({Key? key}) : super(key: key);

  @override
  State<AppSplashWebScreen> createState() => _SplashScreenWebState();
}

class _SplashScreenWebState extends State<AppSplashWebScreen> {
  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences? _prefs;

  void _initSharedPreferences() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _prefs = prefs;
        Timer(const Duration(seconds: 1), () {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg_image.png"))),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/logoCheckIn.png"),
            ],
          ),
        ),
      ),
    );
  }
}
