import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:image/image.dart' as img;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/components/setting/success_page.dart';
import 'package:untitled/responsive/app/setting/setting_screen_mobile.dart';
import 'package:untitled/utils/localizations.dart';
import '../../../components/loading_animation.dart';
import '../../../components/long_button.dart';
import '../../../components/setting/text_form_field_read.dart';
import '../../../components/signup/bottomsheet_button.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/snackbar.dart';
import '../../../utils/style.dart';

class ProfileScreenMobile extends StatefulWidget {
  const ProfileScreenMobile({Key? key}) : super(key: key);

  @override
  State<ProfileScreenMobile> createState() => _ProfileScreenMobileState();
}

class _ProfileScreenMobileState extends State<ProfileScreenMobile> {
  var currentUser = {};
  bool isLoading = false;
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
      _emailTextController.text = currentUser['email'];
      _phoneTextController.text = currentUser['phone'];
      _imageController = currentUser['image'];
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

  String _imageController = '';
  File? media;
  late TextEditingController _emailTextController = TextEditingController();
  late TextEditingController _phoneTextController = TextEditingController();
  final String emptyProfie = 'assets/svg/signup/signup.svg';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    if (value == null || value.isEmpty) {
      return 'Please enter an phone number';
    }
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
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
                  image = null;
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

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(MyLocalizations.translate("text_alertProfile")),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                MyLocalizations.translate("button_Cancel"),
                style: const TextStyle(
                    color: redAlert, fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingMobile()));
              },
              child: Text(
                MyLocalizations.translate("button_Accept"),
                style: const TextStyle(
                    color: blueAlert,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        );
      },
    );
  }

  File? image;
  // Future pickImage(ImageSource source) async {
  //   ImagePicker imagePicker = ImagePicker();
  //   XFile? file = await imagePicker.pickImage(source: source);
  //   if (kDebugMode) {
  //     print('${file?.path}');
  //   }
  //
  //   if (file == null) return;
  //   String getRandomString(int length) {
  //     const characters =
  //         '+-*=?AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789';
  //     Random random = Random();
  //     return String.fromCharCodes(Iterable.generate(length,
  //         (_) => characters.codeUnitAt(random.nextInt(characters.length))));
  //   }
  //
  //   Reference referenceRoot = FirebaseStorage.instance.ref();
  //   Reference referenceDirImages = referenceRoot.child('profile');
  //   Reference referenceImageToUpload =
  //       referenceDirImages.child(getRandomString(40));
  //   try {
  //     await referenceImageToUpload.putFile(File(file.path));
  //     _imageController = await referenceImageToUpload.getDownloadURL();
  //   } catch (error) {}
  //
  //   setState(() {
  //     media = File(file.path);
  //   });
  //   try {} catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('An error occurred when scanning text'),
  //       ),
  //     );
  //   }
  // }

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
      _imageController = await referenceImageToUpload.getDownloadURL();
    } catch (error) {}

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

  void _update() async {
    String image = _imageController.toString();
    String email = _emailTextController.text;
    String phone = _phoneTextController.text;
    if (_formKey.currentState!.validate()) {
      final docUser = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      if (_emailTextController.text == "") {
        email = currentUser['email'];
      }
      if (_phoneTextController.text == "") {
        phone = currentUser['phone'];
      }
      docUser.update({'image': image, 'email': email, 'phone': phone});
      setState(() {
        currentUser['image'] = image;
        currentUser['email'] = email;
        currentUser['phone'] = phone;
        _emailTextController.text = "";
        _phoneTextController.text = "";
      });
    }
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const SuccessPageSetting()));
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingAnimation()
        : SafeArea(
            child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                MyLocalizations.translate("appbar_EditProfile"),
                style: appBar,
              ),
              leading: GestureDetector(
                  child: const Icon(Icons.arrow_back_ios, color: Colors.black),
                  onTap: () {
                    _showAlertDialog(context);
                  }),
            ),
            body: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: _selectPhoto,
                    child: ClipOval(
                      child: media != null
                          ? Image.file(
                              media!,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            )
                          // ? ColorFiltered(
                          //     colorFilter: const ColorFilter.matrix(<double>[
                          //       0.393,
                          //       0.769,
                          //       0.189,
                          //       0,
                          //       0,
                          //       0.349,
                          //       0.686,
                          //       0.168,
                          //       0,
                          //       0,
                          //       0.272,
                          //       0.534,
                          //       0.131,
                          //       0,
                          //       0,
                          //       0,
                          //       0,
                          //       0,
                          //       1,
                          //       0,
                          //     ]),
                          //     child: Image.file(
                          //       media!,
                          //       width: 120,
                          //       height: 120,
                          //       fit: BoxFit.cover,
                          //     ),
                          //   )
                          // ? ColorFiltered(
                          //     colorFilter: const ColorFilter.mode(
                          //       Colors.grey,
                          //       BlendMode.saturation,
                          //     ),
                          //     child: Image.file(
                          //       media!,
                          //       width: 120,
                          //       height: 120,
                          //       fit: BoxFit.cover,
                          //     ),
                          //   )
                          // ? ImageFiltered(
                          //     imageFilter:
                          //         ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                          //     child: Image.file(media!),
                          //   )
                          : currentUser['image'].toString() != ""
                              ? Image.network(
                                  currentUser['image'].toString(),
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.fitWidth,
                                )
                              : SvgPicture.asset(
                                  emptyProfie,
                                  width: 120,
                                  height: 120,
                                ),
                    ),
                  ),
                  Text(
                    MyLocalizations.translate("text_Edit"),
                    style: text,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        child: Column(
                          children: [
                            ShowField(
                                title: MyLocalizations.translate("text_Name"),
                                hint: currentUser['name']),
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
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
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
                                          hintText: currentUser['email'],
                                          hintStyle: const TextStyle(
                                            fontSize: 14,
                                          ),
                                          errorStyle: const TextStyle(
                                            fontSize: 12,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide:
                                                const BorderSide(color: grey),
                                          ),
                                          suffixIcon: const Icon(Icons.edit)),
                                      validator: _validateEmailField,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
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
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
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
                                          hintText: currentUser['phone'],
                                          hintStyle: const TextStyle(
                                            fontSize: 14,
                                          ),
                                          errorStyle: const TextStyle(
                                            fontSize: 12,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide:
                                                const BorderSide(color: grey),
                                          ),
                                          suffixIcon: const Icon(Icons.edit)),
                                      validator: _validatePhoneField,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ShowField(
                                title: MyLocalizations.translate(
                                    "text_EmployeeCode"),
                                hint: currentUser['employeeCode']),
                            // LongButton(
                            //     title: MyLocalizations.translate("button_Save"),
                            //     ontap: _update)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 27, vertical: 30),
                    child: LongButton(
                        title: MyLocalizations.translate("button_Save"),
                        ontap: _update),
                  )
                ],
              ),
            ),
          ));
  }
}
