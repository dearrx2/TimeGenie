import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../components/long_button.dart';
import '../../components/TextFormField.dart';
import '../../utils/localizations.dart';

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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
            child: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onTap: () {
              Navigator.pop(context);
            },
          )),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/bg_image.png"),
                  fit: BoxFit.fitWidth)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.25),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Text(
                        MyLocalizations.translate("text_ForgotPassword"),
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              MyLocalizations.translate("text_ForgotForm"),
                              style: const TextStyle(
                                  fontSize: 16, letterSpacing: 0),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: SetTextFormField(
                            title: MyLocalizations.translate("text_Email"),
                            hint: MyLocalizations.translate("hint_Email"),
                            controller: emailController,
                            validate: _validateEmailField),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: LongButton(
                            title: MyLocalizations.translate("button_Next"),
                            ontap: verifyEmail),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
