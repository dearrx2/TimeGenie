import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../components/long_button.dart';
import '../../components/TextFormField.dart';
import '../../utils/color_utils.dart';
import '../../utils/localizations.dart';
import '../../utils/style.dart';

class ForgotPasswordPageMobile extends StatefulWidget {
  const ForgotPasswordPageMobile({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPageMobile> createState() =>
      _ForgotPasswordMobilePageState();
}

class _ForgotPasswordMobilePageState extends State<ForgotPasswordPageMobile> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  String? _validateEmailField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    final emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          MyLocalizations.translate("appbar_ForgetPassword"),
          style: appBar,
        ),
        leading: GestureDetector(
            child: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onTap: () {
              Navigator.pop(context);
            }),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.14,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [backgroundLow, backgroundHigh],
              )),
            ),
            Container(
              color: backgroundHigh,
              child: Container(
                decoration: const BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(42),
                        topRight: Radius.circular(42))),
                height: MediaQuery.of(context).size.height * 0.81,
                width: MediaQuery.of(context).size.width * 1,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 26),
                    child: Column(
                      children: [
                        Text(
                          MyLocalizations.translate("text_ForgotPassword"),
                          style: header,
                        ),
                        Text(MediaQuery.of(context).size.height.toString()),
                        Padding(
                          padding: const EdgeInsets.only(top: 9.0),
                          child: Text(
                            MyLocalizations.translate("text_ForgotForm"),
                            style: textGery,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: SetTextFormField(
                              title: MyLocalizations.translate("text_Email"),
                              hint: MyLocalizations.translate("hint_Email"),
                              controller: emailController,
                              validate: _validateEmailField),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 21.0),
                          child: LongButton(
                              title: MyLocalizations.translate("button_SendTo"),
                              ontap: verifyEmail),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }

  Future<void> verifyEmail() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password Reset Email Sent'),
        ),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'An error occurred'),
        ),
      );
      Navigator.of(context).pop();
    }
  }
}
