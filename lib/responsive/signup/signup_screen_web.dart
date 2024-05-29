import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/components/long_button.dart';
import 'package:untitled/components/signup/bottomsheet_button.dart';

import '../../components/TextFormField.dart';

import '../../responsive/signin/signin_screen.dart';
import '../../utils/color_utils.dart';
import '../../utils/localizations.dart';
import '../Role/role_screen.dart';

class SignUpScreenWeb extends StatefulWidget {
  const SignUpScreenWeb({Key? key}) : super(key: key);

  @override
  State<SignUpScreenWeb> createState() => _SignUpScreeWebnState();
}

class _SignUpScreeWebnState extends State<SignUpScreenWeb> {
  String _imageidcardController = '';
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();
  final TextEditingController _employeeCodeTextController =
      TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmPasswordTextController =
      TextEditingController();

  final String emptyProfie = 'assets/svg/empty_file.svg';
  File? media;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _validateNameField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an name';
    }
    final RegExp nameRegExp = RegExp('[a-zA-Z]');
    if (!nameRegExp.hasMatch(value)) {
      return 'Enter a valid n'
          '.ame';
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
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    if (value == null || value.isEmpty) {
      return 'Please enter an phone number';
    }
    RegExp regExp = RegExp(patttern);
    if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  String? _validateCodeField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an code';
    }
    if (value.length != 6) {
      return "Employee code must be of 6 digit";
    }
    return null;
  }

  String? _validatePasswordField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an password';
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
          height: 256,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            MyLocalizations.translate("text_SignUp"),
            style: const TextStyle(color: black, fontWeight: FontWeight.bold),
          ),
          leading: GestureDetector(
            child: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignInPage()),
              );
            },
          )),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg_image.png"),
                fit: BoxFit.fill)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: MediaQuery.of(context).size.height * 0.11),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: _selectPhoto,
                    child: ClipOval(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: transparent,
                        child: media != null
                            ? ClipOval(
                                child: Image.file(
                                  media!,
                                  width: 160,
                                  height: 160,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : SvgPicture.asset(
                                emptyProfie,
                                width: 160,
                                height: 160,
                              ),
                      ),
                    ),
                  ),
                  SetTextFormField(
                      title: MyLocalizations.translate("text_Name"),
                      hint: MyLocalizations.translate("hint_Name"),
                      controller: _nameTextController,
                      validate: _validateNameField),
                  SetTextFormField(
                      title: MyLocalizations.translate("text_Email"),
                      hint: MyLocalizations.translate("hint_Email"),
                      controller: _emailTextController,
                      validate: _validateEmailField),
                  SetTextFormField(
                      title: MyLocalizations.translate("text_Phone"),
                      hint: MyLocalizations.translate("hint_Phone"),
                      controller: _phoneTextController,
                      validate: _validatePhoneField),
                  SetTextFormField(
                      title: MyLocalizations.translate("text_EmployeeCode"),
                      hint: MyLocalizations.translate("hint_EmployeeCode"),
                      controller: _employeeCodeTextController,
                      validate: _validateCodeField),
                  SetTextFormField(
                      title: MyLocalizations.translate("text_Password"),
                      hint: MyLocalizations.translate("hint_Password"),
                      controller: _passwordTextController,
                      validate: _validatePasswordField),
                  SetTextFormField(
                      title: MyLocalizations.translate("text_ConfirmPassword"),
                      hint: MyLocalizations.translate("hint_ConfirmPassword"),
                      controller: _confirmPasswordTextController,
                      validate: _validatePasswordField),
                  Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: LongButton(
                          title: MyLocalizations.translate("button_Next"),
                          ontap: nextStep))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
