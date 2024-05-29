import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/components/long_button.dart';
import 'package:untitled/components/setting/text_form_field_read.dart';
import '../../utils/color_utils.dart';
import '../../utils/localizations.dart';
import '../../utils/snackbar.dart';
import '../TextFormField.dart';
import '../signup/bottomsheet_button.dart';

class DropDownProfileCard extends StatefulWidget {
  final String icon;
  final String text;
  final bool checker;
  final String uid;
  const DropDownProfileCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.checker,
    required this.uid,
  }) : super(key: key);

  @override
  State<DropDownProfileCard> createState() => _DropDownProfileCardState();
}

class _DropDownProfileCardState extends State<DropDownProfileCard> {
  late bool check;
  bool isLoading = false;
  var currentUser = {};
  String _imageidcardController = '';
  File? media;
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  final String emptyProfie = 'assets/svg/empty_file.svg';
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

  File? image;
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
    } catch (error) {}

    setState(() {
      media = File(file.path);
    });
    try {
      final file = media;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred when scanning text'),
        ),
      );
    }
  }

  void _update() async {
    String image = _imageidcardController.toString();
    String email = _emailTextController.text;
    String phone = _phoneTextController.text;
    if (_formKey.currentState!.validate()) {
      final docUser =
          FirebaseFirestore.instance.collection('users').doc(widget.uid);
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
  }

  @override
  void initState() {
    super.initState();
    check = widget.checker;
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
      check = !check;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: toggleVisibility,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.11,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            topRight: Radius.circular(12.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: veryGrey,
                              blurRadius: 2.0,
                              spreadRadius: 2.0,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Form(
                            key: _formKey,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  widget.icon,
                                  width: 32,
                                  height: 32,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: SizedBox(
                                    width: 260,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          widget.text,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        IconButton(
                                          onPressed: toggleVisibility,
                                          icon: Icon(
                                            check
                                                ? Icons
                                                    .keyboard_arrow_up_outlined
                                                : Icons
                                                    .keyboard_arrow_down_outlined,
                                            size: 32,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: check,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12.0),
                            bottomRight: Radius.circular(12.0),
                          ),
                          color: white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2.0,
                              spreadRadius: 2.0,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: _selectPhoto,
                                child: ClipOval(
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundColor: transparent,
                                    child: media != null
                                        ? Image.file(
                                            media!,
                                            width: 160,
                                            height: 160,
                                            fit: BoxFit.cover,
                                          )
                                        : currentUser['image'].toString() != ""
                                            ? Image.network(
                                                currentUser['image'].toString(),
                                                width: 160,
                                                height: 160,
                                                fit: BoxFit.cover,
                                              )
                                            : SvgPicture.asset(
                                                emptyProfie,
                                                width: 160,
                                                height: 160,
                                              ),
                                    // child: currentUser['image'].toString() != ""
                                    //     ? Image.network(
                                    //         currentUser['image'].toString(),
                                    //         width: 160,
                                    //         height: 160,
                                    //         fit: BoxFit.cover,
                                    //       )
                                    //     : SvgPicture.asset(
                                    //         emptyProfie,
                                    //         width: 160,
                                    //         height: 160,
                                    //       ),
                                  ),
                                ),
                              ),
                              ShowField(
                                  title: MyLocalizations.translate("text_Name"),
                                  hint: currentUser['name']),
                              ShowField(
                                  title: MyLocalizations.translate(
                                      "text_EmployeeCode"),
                                  hint: currentUser['employeeCode']),
                              SetTextFormField(
                                  title:
                                      MyLocalizations.translate("text_Email"),
                                  hint: currentUser['email'],
                                  controller: _emailTextController,
                                  validate: _validateEmailField),
                              SetTextFormField(
                                  title:
                                      MyLocalizations.translate("text_Phone"),
                                  hint: currentUser['phone'],
                                  controller: _phoneTextController,
                                  validate: _validatePhoneField),
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: LongButton(
                                      title: MyLocalizations.translate(
                                          "button_Save"),
                                      ontap: _update))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
