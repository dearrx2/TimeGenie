import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:untitled/utils/localizations.dart';

import '../../../components/TextFormField.dart';
import '../../../components/long_button.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/style.dart';

class ForgotPasswordScreenMobile extends StatefulWidget {
  const ForgotPasswordScreenMobile({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreenMobile> createState() =>
      _ForgotPasswordScreenMobileState();
}

class _ForgotPasswordScreenMobileState
    extends State<ForgotPasswordScreenMobile> {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(MyLocalizations.translate("appbar_ResetPassword"),
            style: appBar),
        leading: GestureDetector(
            child: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onTap: () {
              Navigator.pop(context);
            }),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  MyLocalizations.translate("text_ResetTitle"),
                  style: header,
                ),
                Text(
                  MyLocalizations.translate("text_ResetHint1"),
                  style: textGery,
                ),
                Text(
                  MyLocalizations.translate("text_ResetHint2"),
                  style: textGery,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 48),
            child: SetTextFormField(
                title: MyLocalizations.translate("text_Email"),
                hint: MyLocalizations.translate("hint_Email"),
                controller: emailController,
                validate: _validateEmailField),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 31.0),
            child: LongButton(
                title: MyLocalizations.translate("button_SendTo"),
                ontap: verifyEmail),
          ),
        ],
      ),
    ));
  }
}
