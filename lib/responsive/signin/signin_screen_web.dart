import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/components/long_button.dart';
import 'package:untitled/components/signin/password_field.dart';
import 'package:untitled/utils/style.dart';
import '../../components/TextFormField.dart';
import '../../utils/color_utils.dart';
import '../../utils/localizations.dart';
import '../app/main/main_page.dart';
import '../forgotpassword/forgotPassword.dart';
import '../signup/signup_screen.dart';

class SignInScreenWeb extends StatefulWidget {
  const SignInScreenWeb({Key? key}) : super(key: key);

  @override
  State<SignInScreenWeb> createState() => _SignInScreenWebState();
}

class _SignInScreenWebState extends State<SignInScreenWeb> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late SharedPreferences _prefs;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
    removeGoogleLogin();
    _passwordVisible = false;
  }

  Future<void> removeGoogleLogin() async {
    await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.1,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [backgroundLow, backgroundHigh],
                      )),
                ),
                MediaQuery.of(context).size.height < 641
                    ? Container(
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
                              MyLocalizations.translate("text_WelcomeBack"),
                              style: header,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 9.0),
                              child: Text(
                                MyLocalizations.translate("text_WelcomeForm"),
                                style: textGery,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 1,
                                height:
                                MediaQuery.of(context).size.height * 0.34,
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      SetTextFormField(
                                        title: MyLocalizations.translate(
                                            "text_Email"),
                                        hint: MyLocalizations.translate(
                                            "hint_Email"),
                                        controller: _emailTextController,
                                        validate: _validateEmailField,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.01),
                                        child: SetPasswordFormField(
                                            title: MyLocalizations.translate(
                                                "text_Password"),
                                            hint: MyLocalizations.translate(
                                                "hint_Password"),
                                            checker: _passwordVisible,
                                            controller:
                                            _passwordTextController,
                                            validate: _validatePasswordField),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      MyLocalizations.translate(
                                          "text_SignUpForm"),
                                      style:
                                      const TextStyle(color: Colors.grey),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                            const SignUpPage(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        MyLocalizations.translate(
                                            "text_SignUp"),
                                        style: const TextStyle(
                                          color: orange,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          decoration:
                                          TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  child: Text(
                                    MyLocalizations.translate(
                                        "text_ForgotPassword"),
                                    style: const TextStyle(
                                      decoration: TextDecoration.none,
                                      color: grey,
                                    ),
                                  ),
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const ForgotPasswordPage()),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            LongButton(
                                title: MyLocalizations.translate(
                                    "button_SignIn"),
                                ontap: _submitForm),
                            const SizedBox(
                              height: 16,
                            ),
                            Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: GestureDetector(
                                  onTap: () async {
                                    await signInWithGoogle();
                                  },
                                  child: const Image(
                                    image: AssetImage(
                                        "assets/images/google.png"),
                                    width: 60,
                                    height: 48,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                    : Container(
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
                              MyLocalizations.translate("text_WelcomeBack"),
                              style: header,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 9.0),
                              child: Text(
                                MyLocalizations.translate("text_WelcomeForm"),
                                style: textGery,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 25.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 1,
                                height:
                                MediaQuery.of(context).size.height * 0.27,
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      SetTextFormField(
                                        title: MyLocalizations.translate(
                                            "text_Email"),
                                        hint: MyLocalizations.translate(
                                            "hint_Email"),
                                        controller: _emailTextController,
                                        validate: _validateEmailField,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.01),
                                        child: SetPasswordFormField(
                                            title: MyLocalizations.translate(
                                                "text_Password"),
                                            hint: MyLocalizations.translate(
                                                "hint_Password"),
                                            checker: _passwordVisible,
                                            controller:
                                            _passwordTextController,
                                            validate: _validatePasswordField),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  child: Text(
                                    MyLocalizations.translate("text_ForgotPassword"),
                                    style: const TextStyle(
                                      decoration: TextDecoration.none,
                                      color: grey,
                                    ),
                                  ),
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const ForgotPasswordPage()),
                                  ),
                                ),
                              ],
                            ),
                            LongButton(
                                title: MyLocalizations.translate(
                                    "button_SignIn"),
                                ontap: _submitForm),
                            Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    MyLocalizations.translate(
                                        "text_SignUpForm"),
                                    style:
                                    const TextStyle(color: Colors.grey),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                          const SignUpPage(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      MyLocalizations.translate(
                                          "text_SignUp"),
                                      style: const TextStyle(
                                        color: orange,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 1,
                              color: primaryTextColor,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: white,
                                ),
                                onPressed: () async {
                                  await signInWithGoogle();
                                },
                                child: const Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(
                                        image: AssetImage("assets/images/google.png"),
                                        width: 60,
                                        height: 48,
                                      ),
                                      SizedBox(width: 10), // Add this line if you want some space between the image and the text
                                      Text(
                                        "Sign in with Google",
                                        style: TextStyle(color: black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final UserCredential authResult =
      await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = authResult.user;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();
      final userEmail = userDoc.data()?['email'];

      if (userEmail != null) {
        if (mounted) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeScreenPage(
                    uid: "",
                  )));
        }
      } else {
        if (mounted) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SignUpPage()));
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  void _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _checkIfAlreadySignedIn();
  }

  void _checkIfAlreadySignedIn() {
    final String? storedEmail = _prefs.getString('email');
    final String? storedPassword = _prefs.getString('password');

    if (storedEmail != null && storedPassword != null) {
      _auth
          .signInWithEmailAndPassword(
        email: storedEmail,
        password: storedPassword,
      )
          .then((userCredential) {
        User? user = userCredential.user;
        if (user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreenPage(
                    uid: FirebaseAuth.instance.currentUser!.uid)),
          );
        }
      }).catchError((e) {
        // Handle sign-in error.
        if (kDebugMode) {
          print("Error: $e");
        }
      });
    }
  }

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

  String? _validatePasswordField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    return null;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailTextController.text;
      String password = _passwordTextController.text;

      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        User? user = userCredential.user;
        if (user != null) {
          // Save user's login credentials securely in local storage
          await _prefs.setString('email', email);
          await _prefs.setString('password', password);
          await _prefs.setBool('checkNotification', true);

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreenPage(
                    uid: FirebaseAuth.instance.currentUser!.uid)),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign-in failed. Please try again.')),
        );
      }
    }
  }
}
