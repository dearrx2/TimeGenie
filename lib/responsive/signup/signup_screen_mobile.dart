import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/components/signup/bottomsheet_button.dart';
import 'package:untitled/responsive/signin/signin_screen.dart';
import '../../utils/color_utils.dart';
import '../../utils/localizations.dart';
import '../../utils/style.dart';
import '../Role/role_screen.dart';

class SignUpScreenMobile extends StatefulWidget {
  const SignUpScreenMobile({Key? key}) : super(key: key);

  @override
  State<SignUpScreenMobile> createState() => _SignUpScreenMobileState();
}

class _SignUpScreenMobileState extends State<SignUpScreenMobile> {
  String _imageidcardController = '';
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();
  final TextEditingController _employeeCodeTextController =
      TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmPasswordTextController =
      TextEditingController();
  bool _showPassword = false;
  bool _showPasswordCheck = false;
  void _toggleShowPassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _toggleShowPasswordCheck() {
    setState(() {
      _showPasswordCheck = !_showPasswordCheck;
    });
  }

  final String emptyProfie = 'assets/svg/signup/signup.svg';
  File? media;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  @override
  void initState() {
    super.initState();
    _nameTextController.addListener(_updateButtonState);
    _emailTextController.addListener(_updateButtonState);
    _phoneTextController.addListener(_updateButtonState);
    _employeeCodeTextController.addListener(_updateButtonState);
    _passwordTextController.addListener(_updateButtonState);
    _confirmPasswordTextController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _nameTextController.text.isNotEmpty &&
          _emailTextController.text.isNotEmpty &&
          _phoneTextController.text.isNotEmpty &&
          _employeeCodeTextController.text.isNotEmpty &&
          _passwordTextController.text.isNotEmpty &&
          _confirmPasswordTextController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nameTextController.dispose();
    _emailTextController.dispose();
    _phoneTextController.dispose();
    _employeeCodeTextController.dispose();
    _passwordTextController.dispose();
    _confirmPasswordTextController.dispose();
  }

  String? _validateNameField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an name';
    }
    final RegExp nameRegExp = RegExp('[a-zA-Z]');
    if (!nameRegExp.hasMatch(value)) {
      return 'Enter a valid name';
    }
    return null;
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

  String? _validatePhoneField(String? value) {
    String pattern = r'^(?:(?:\+?0[6-9])|0[6-9])[0-9]{8,10}$';
    if (value == null || value.isEmpty) {
      return 'Please enter an phone number';
    }
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  String? _validateCodeField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an code';
    }
    if (value.length != 7) {
      return "Employee code must be of 7 digit";
    }
    return null;
  }

  String? _validatePasswordField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an password';
    }
    if (value.length < 8 || value.length > 16) {
      return "Please enter an password between 8-16";
    }
    if (value != _confirmPasswordTextController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('Alert'),
          content: const Text('Delete your profile picture'),
          actions: [
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                setState(() {
                  media = null;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _selectPhoto() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.36,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              BottomSheetButton(
                title: "Open camera",
                colorText: black,
                ontap: () => pickImage(ImageSource.camera),
              ),
              BottomSheetButton(
                title: "Select photo",
                colorText: black,
                ontap: () => pickImage(ImageSource.gallery),
              ),
              BottomSheetButton(
                title: "Delete profile picture",
                colorText: black,
                ontap: () {
                  Navigator.pop(context);
                  // showAlertDialog(context);
                  _showAlert(context);
                },
              ),
              BottomSheetButton(
                title: "Cancel",
                colorText: red,
                ontap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future pickImage(ImageSource source) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (kDebugMode) {
      print('${file?.path}');
    }

    if (file == null) return;
    String getRandomString(int length) {
      const characters =
          '+-*=?AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789';
      Random random = Random();
      return String.fromCharCodes(Iterable.generate(length,
          (_) => characters.codeUnitAt(random.nextInt(characters.length))));
    }

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('profile');
    Reference referenceImageToUpload =
        referenceDirImages.child(getRandomString(40));
    try {
      await referenceImageToUpload.putFile(File(file.path));
      _imageidcardController = await referenceImageToUpload.getDownloadURL();
    } catch (error) {
      //Some error occurred
    }

    setState(() {
      media = File(file.path);
    });
    try {} catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred when scanning text'),
        ),
      );
    }
  }

  void nextStep() {
    if (_formKey.currentState!.validate()) {
      String image = _imageidcardController.toString();
      String name = _nameTextController.text;
      String email = _emailTextController.text;
      String phone = _phoneTextController.text;
      String password = _passwordTextController.text;
      String code = _employeeCodeTextController.text;

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectRole(
                image: image,
                name: name,
                email: email,
                phone: phone,
                code: code,
                password: password)),
      );
    }
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          MyLocalizations.translate("text_SignUp"),
          style: appBar,
        ),
        leading: GestureDetector(
            child: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onTap: () {
              removeGoogleLogin();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const SignInPage()));
            }),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.15,
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
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: _selectPhoto,
                              child: ClipOval(
                                child: CircleAvatar(
                                  radius: 45,
                                  backgroundColor: transparent,
                                  child: media != null
                                      ? ClipOval(
                                          child: Image.file(
                                            media!,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : SvgPicture.asset(
                                          emptyProfie,
                                          width: 80,
                                          height: 80,
                                        ),
                                ),
                              ),
                            ),
                            const Text("Edit"),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        MyLocalizations.translate("text_Name"),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: TextFormField(
                                      maxLines: null,
                                      textInputAction: TextInputAction.newline,
                                      onTapOutside: (event) {
                                        FocusScope.of(context).unfocus();
                                      },
                                      controller: _nameTextController,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 8),
                                        hintText: MyLocalizations.translate(
                                            "hint_Name"),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide:
                                              const BorderSide(color: grey),
                                        ),
                                      ),
                                      validator: _validateNameField,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        MyLocalizations.translate("text_Email"),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: TextFormField(
                                      maxLines: null,
                                      textInputAction: TextInputAction.newline,
                                      onTapOutside: (event) {
                                        FocusScope.of(context).unfocus();
                                      },
                                      controller: _emailTextController,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 8),
                                        hintText: MyLocalizations.translate(
                                            "hint_Email"),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide:
                                              const BorderSide(color: grey),
                                        ),
                                      ),
                                      validator: _validateEmailField,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        MyLocalizations.translate("text_Phone"),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: TextFormField(
                                      maxLines: null,
                                      textInputAction: TextInputAction.newline,
                                      onTapOutside: (event) {
                                        FocusScope.of(context).unfocus();
                                      },
                                      controller: _phoneTextController,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 8),
                                        hintText: MyLocalizations.translate(
                                            "hint_Phone"),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide:
                                              const BorderSide(color: grey),
                                        ),
                                      ),
                                      validator: _validatePhoneField,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        MyLocalizations.translate(
                                            "text_EmployeeCode"),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: TextFormField(
                                      maxLines: null,
                                      textInputAction: TextInputAction.newline,
                                      onTapOutside: (event) {
                                        FocusScope.of(context).unfocus();
                                      },
                                      controller: _employeeCodeTextController,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 8),
                                        hintText: MyLocalizations.translate(
                                            "hint_EmployeeCode"),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide:
                                              const BorderSide(color: grey),
                                        ),
                                      ),
                                      validator: _validateCodeField,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        MyLocalizations.translate(
                                            "text_Password"),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: TextFormField(
                                      maxLines: 1,
                                      textInputAction: TextInputAction.newline,
                                      onTapOutside: (event) {
                                        FocusScope.of(context).unfocus();
                                      },
                                      controller: _passwordTextController,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal: 8,
                                        ),
                                        hintText: MyLocalizations.translate(
                                            "hint_Password"),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide:
                                              const BorderSide(color: grey),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _showPassword
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                          ),
                                          onPressed: _toggleShowPassword,
                                        ),
                                      ),
                                      validator: _validatePasswordField,
                                      obscureText: !_showPassword,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    MyLocalizations.translate(
                                        "text_PasswordCon"),
                                    style: textHint,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        MyLocalizations.translate(
                                            "text_ConfirmPassword"),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: TextFormField(
                                      maxLines: 1,
                                      textInputAction: TextInputAction.newline,
                                      onTapOutside: (event) {
                                        FocusScope.of(context).unfocus();
                                      },
                                      controller:
                                          _confirmPasswordTextController,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 8),
                                        hintText: MyLocalizations.translate(
                                            "hint_ConfirmPassword"),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide:
                                              const BorderSide(color: grey),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _showPasswordCheck
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                          ),
                                          onPressed: _toggleShowPasswordCheck,
                                        ),
                                      ),
                                      validator: _validatePasswordField,
                                      obscureText: !_showPasswordCheck,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    MyLocalizations.translate(
                                        "text_PasswordCheck"),
                                    style: textHint,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _isButtonEnabled ? nextStep : null,
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>((states) {
                                      return _isButtonEnabled
                                          ? const Color(0xFFFF9300)
                                          : const Color(0xFFD8D8D8);
                                    }),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    MyLocalizations.translate("button_Next"),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
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
}
