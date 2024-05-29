import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/responsive/app/setting/setting_screen.dart';
import 'package:untitled/responsive/signin/signin_screen.dart';

class testTy extends StatefulWidget {
  const testTy({Key? key}) : super(key: key);

  @override
  State<testTy> createState() => _testTyState();
}

class _testTyState extends State<testTy> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data == null) {
              return const SignInPage();
            } else {
              // return HomeScreenPage(
              //     uid: FirebaseAuth.instance.currentUser!.uid);
              return const SettingPage();
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
