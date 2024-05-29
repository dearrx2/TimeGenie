import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/components/setting/forgot_password.dart';
import 'package:untitled/components/setting/switch_card_darkmode.dart';
import 'package:untitled/components/setting/switch_card_language.dart';
import 'package:untitled/utils/color_utils.dart';

import '../../../components/setting/dropdown_profile.dart';
import '../../../responsive/signin/signin_screen.dart';
import '../../../utils/localizations.dart';
import '../../../utils/snackbar.dart';
import '../main/main_page.dart';

class SettingWeb extends StatefulWidget {
  const SettingWeb({Key? key}) : super(key: key);

  @override
  State<SettingWeb> createState() => _SettingMobileScreenState();
}

class _SettingMobileScreenState extends State<SettingWeb> {
  var currentUser = {};
  bool isLoading = false;
  bool light = false;
  bool thai = false;
  bool isVisibleProfile = false;
  bool isVisibleResetPassword = false;
  final String profile = 'assets/svg/setting/profile.svg';
  final String resetPassword = 'assets/svg/setting/reset_password.svg';
  final String language = 'assets/svg/setting/language.svg';
  final String darkmode = 'assets/svg/setting/darkmode.svg';
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var currentSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      currentUser = currentSnap.data()!;
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  void toggleVisibility() {
    setState(() {
      isVisibleProfile = !isVisibleProfile;
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()),
    );
    SharedPreferences.getInstance().then((prefs) {
      setState(() async {
        prefs.remove('email');
        prefs.remove('password');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                MyLocalizations.translate("appbar_Setting"),
                style:
                    const TextStyle(color: black, fontWeight: FontWeight.bold),
              ),
              leading: GestureDetector(
                child: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreenPage(
                              uid: FirebaseAuth.instance.currentUser!.uid)));
                },
              ),
              backgroundColor: cream,
              elevation: 0,
            ),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [cream, cream50, white],
                  stops: [0.1, 0.5, 0.95],
                ),
              ),
              child: ListView(
                children: <Widget>[
                  DropDownProfileCard(
                    icon: profile,
                    text:
                        MyLocalizations.translate("button_ProfileInformation"),
                    checker: thai,
                    uid: FirebaseAuth.instance.currentUser!.uid,
                  ),
                  PasswordCard(
                    icon: resetPassword,
                    text: MyLocalizations.translate("button_ResetPassword"),
                  ),
                  ToggleCardLanguage(
                    icon: language,
                    text: MyLocalizations.translate("text_Language"),
                  ),
                  ToggleCardDarkMode(
                      icon: darkmode,
                      text: MyLocalizations.translate("button_DarkMode"),
                      checker: light),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: TextButton(
                        onPressed: _logout,
                        child: const Text(
                          'Sign out',
                          style: TextStyle(color: red),
                        )),
                  )
                ],
              ),
            ),
          );
  }
}
