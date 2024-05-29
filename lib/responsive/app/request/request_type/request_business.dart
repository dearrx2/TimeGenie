import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import '../../../../components/TextFormField.dart';
import '../../../../components/date_picker.dart';
import '../../../../components/long_button.dart';
import '../../../../components/long_button_disable.dart';
import '../../../../components/request/date_picker_field.dart';
import '../../../../components/signup/bottomsheet_button.dart';
import '../../../../utils/color_utils.dart';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'dart:io';

import '../../../../utils/localizations.dart';
import '../../../../utils/style.dart';
import '../success_page.dart';

class DateSelectionBox {
  String id;
  DateTime? startDate;
  DateTime? endDate;

  DateSelectionBox({required this.id, this.startDate, this.endDate});
}

class requestBusiness extends StatefulWidget {
  const requestBusiness({Key? key}) : super(key: key);

  @override
  State<requestBusiness> createState() => _requestBusinessState();
}

class _requestBusinessState extends State<requestBusiness> {
  final _formKey = GlobalKey<FormState>();
  String _imageRequestController = '';
  final _reasonController = TextEditingController();
  DateSelectionBox startDateBox = DateSelectionBox(id: 'startDate');
  DateSelectionBox endDateBox = DateSelectionBox(id: 'endDate');
  File? media;
  bool _isButtonEnabled = false; // Initialize as false

  Future<List<DocumentSnapshot>> getBusinessDatesByStatus(String status, String userID) async {
    CollectionReference requestBusinessCollection =
        FirebaseFirestore.instance.collection('request_business');

    QuerySnapshot snapshot = await requestBusinessCollection
        .where('approveStatus', isEqualTo: status)
        .where('userID', isEqualTo: userID) // Add this line to filter by userID
        .get();
    return snapshot.docs;
  }

  Future<void> _selectDateRange(bool isStartDate) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle case where the user is not signed in.
      return;
    }
    // Call getBusinessDatesByStatus to retrieve disabled dates for 'approved' and 'waiting' statuses
    List<DocumentSnapshot> approvedDatesSnapshots =
        await getBusinessDatesByStatus('approved', user.uid);
    List<DocumentSnapshot> waitingDatesSnapshots =
        await getBusinessDatesByStatus('waiting', user.uid);

    // Convert approvedDatesSnapshots and waitingDatesSnapshots to a set of DateTime objects
    List<String> disabledDates = [];

    for (var snapshot in approvedDatesSnapshots) {
      DateTime startDate = snapshot['startDate'].toDate();
      DateTime endDate = snapshot['endDate'].toDate();

      // Generate a range of dates from startDate to endDate and add them to the list
      while (
          startDate.isBefore(endDate) || startDate.isAtSameMomentAs(endDate)) {
        disabledDates.add(DateFormat('d/M/y').format(startDate));
        startDate = startDate.add(Duration(days: 1));
      }
    }

    for (var snapshot in waitingDatesSnapshots) {
      DateTime startDate = snapshot['startDate'].toDate();
      DateTime endDate = snapshot['endDate'].toDate();

      // Generate a range of dates from startDate to endDate and add them to the list
      while (
          startDate.isBefore(endDate) || startDate.isAtSameMomentAs(endDate)) {
        disabledDates.add(DateFormat('d/M/y').format(startDate));
        startDate = startDate.add(Duration(days: 1));
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RangeDatePickerDialog(
          initialStartDate: startDateBox.startDate,
          initialEndDate: endDateBox.endDate,
          disableDate: disabledDates,
          isSickLeaveRequest: false,
          onSelected: (startDate, endDate) {
            setState(() {
              startDateBox.startDate = startDate;
              endDateBox.endDate = endDate;
            });
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Add listeners to the text controllers
    _reasonController.addListener(_updateButtonState);
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
        return SafeArea(
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                BottomSheetButton(
                  title: MyLocalizations.translate("text_OpenCamera"),
                  colorText: black,
                  ontap: () {
                    pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                ),
                BottomSheetButton(
                  title: MyLocalizations.translate("text_SelectPhoto"),
                  colorText: black,
                  ontap: () {
                    pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                ),
                BottomSheetButton(
                  title: MyLocalizations.translate("text_Cancel"),
                  colorText: red,
                  ontap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> pickImage(ImageSource source) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);

    if (file == null) return;

    String getRandomString(int length) {
      const characters =
          '+-*=?AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789';
      Random random = Random();
      return String.fromCharCodes(Iterable.generate(length,
              (_) => characters.codeUnitAt(random.nextInt(characters.length))));
    }

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('request_sick');
    Reference referenceImageToUpload =
    referenceDirImages.child(getRandomString(40));

    bool isModalOpen = false; // Flag to track if modal is open

    try {
      UploadTask uploadTask = referenceImageToUpload.putFile(File(file.path));

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = (snapshot.bytesTransferred / snapshot.totalBytes);

        if (!isModalOpen) {
          isModalOpen = true;
          showDialog(
            context: context,
            barrierDismissible: false, // Prevent dismissal
            builder: (context) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // LinearProgressIndicator(
                    //   value: progress,
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Lottie.asset(
                        'assets/animation/dancing_loading.json',
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          // Update the progress bar and status text within the existing modal sheet
          Navigator.pop(context);
          showDialog(
            context: context,
            barrierDismissible: false, // Prevent dismissal
            builder: (context) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // LinearProgressIndicator(
                    //   value: progress,
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Lottie.asset(
                        'assets/animation/dancing_loading.json',
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }

        if (progress == 1.0) {
          // Upload is complete, dismiss the modal bottom sheet
          Navigator.pop(context);
          isModalOpen = false;
        }
      });

      await uploadTask.whenComplete(() async {
        _imageRequestController = await referenceImageToUpload.getDownloadURL();
      });
    } catch (error) {
      // Handle error
      print(error.toString());
    }

    setState(() {
      media = File(file.path);
    });
  }

  String? _validateStartDateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a start date';
    }
    return null;
  }

  String? _validateEndDateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select an end date';
    }
    return null;
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _formKey.currentState != null &&
          startDateBox.startDate != null &&
          endDateBox.endDate != null &&
          media != null &&
          _reasonController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    _updateButtonState(); // Update button state
    return Scaffold(
        appBar: AppBar(
          title: Text(
            MyLocalizations.translate("text_BusinessLeave"),
            style: appBar,
          ),
          backgroundColor: white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => _selectDateRange(true),
                    child: AbsorbPointer(
                      child: SelectDateFormField(
                        controller: TextEditingController(
                          text: startDateBox.startDate != null
                              ? DateFormat('dd/MM/yyyy')
                                  .format(startDateBox.startDate!)
                              : '',
                        ),
                        title: MyLocalizations.translate("text_StartDate"),
                        hint: MyLocalizations.translate("hint_SelectDate"),
                        validate: _validateStartDateField,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _selectDateRange(false),
                    child: AbsorbPointer(
                      child: SelectDateFormField(
                        controller: TextEditingController(
                          text: endDateBox.endDate != null
                              ? DateFormat('dd/MM/yyyy')
                                  .format(endDateBox.endDate!)
                              : '',
                        ),
                        title: MyLocalizations.translate("text_EndDate"),
                        hint: MyLocalizations.translate("hint_SelectDate"),
                        validate: _validateEndDateField,
                      ),
                    ),
                  ),
                  SetTextFormField(
                    title: MyLocalizations.translate("text_Reason"),
                    hint: MyLocalizations.translate("hint_Reason"),
                    controller: _reasonController,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a reason';
                      }
                      if (value.length > 400) {
                        return 'Reason cannot exceed 400 characters';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          MyLocalizations.translate("text_UploadImage"),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (media ==
                            null) // Show the button only when media is null
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: GestureDetector(
                              onTap: () => _selectPhoto(),
                              child: DottedBorder(
                                color: Colors.orange,
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(10),
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.upload,
                                      color: orange,
                                    ), // Display upload icon
                                    const SizedBox(width: 8.0),
                                    Text(
                                      MyLocalizations.translate(
                                          "text_UploadImage"),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: orange,
                                      ),
                                    ), // Display "Upload image" hint text
                                  ],
                                ),
                              ),
                            ),
                          ),
                        if (media != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          child: Container(
                                            width: double.infinity,
                                            height: 300.0,
                                            child: Image.file(
                                              media!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    // height: 30.0, // Adjust the height as needed
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 8),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          media!.path.split('/').last.length >
                                                  30
                                              ? '${media!.path
                                                      .split('/')
                                                      .last
                                                      .substring(0, 27)}...'
                                              : media!.path.split('/').last,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontStyle: FontStyle.italic,
                                              color: blue),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            // Handle the deletion of the selected image
                                            setState(() {
                                              media = null;
                                            });
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                            child: const Icon(
                                                Icons.delete_outline_rounded,
                                                color: red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
          child: _isButtonEnabled
              ? LongButton(
                  title: MyLocalizations.translate("button_SendRequest"),
                  ontap: () async {
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      if (_formKey.currentState!.validate() &&
                          startDateBox.startDate != null &&
                          endDateBox.endDate != null) {
                        // Handle the selected date range
                        print('Start Date: ${startDateBox.startDate}');
                        print('End Date: ${endDateBox.endDate}');

                        DocumentReference newRequestRef =
                            await FirebaseFirestore.instance
                                .collection('request_business')
                                .doc();
                        String businessId =
                            newRequestRef.id; // Get the generated taskID
                        await newRequestRef.set({
                          'image': _imageRequestController,
                          'userID': user.uid,
                          'requestID': businessId,
                          'startDate': startDateBox.startDate,
                          'endDate': endDateBox.endDate,
                          'reason': _reasonController.text,
                          'createDate': DateTime.now(),
                          'approveBy': '',
                          'approveDate': '',
                          'approveStatus': 'waiting',
                          'date': DateFormat('d/M/y')
                              .format(startDateBox.startDate!),
                        });

                        // Navigate to the SuccessPage
                        DateTime startDate = startDateBox.startDate ?? DateTime.now(); // Use DateTime.now() as a default value if it's null
                        DateTime endDate = endDateBox.endDate ?? DateTime.now(); // Use DateTime.now() as a default value if it's null

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SuccessPageRange(
                              icon: 'assets/images/icon_tag_leave/business_tag.png',
                              requestType: 'Business Leave',
                              startDate: startDate,
                              endDate: endDate,
                            ),
                          ),
                        );

                        // Retrieve the reason from the TextFormField
                        final reason = _reasonController.text;
                        print('Reason: $reason');

                        // Clear the text field and reset date selection boxes
                        _reasonController.clear();
                        setState(() {
                          startDateBox.startDate = null;
                          endDateBox.endDate = null;
                          media = null;
                        });
                      }
                    }
                  },
                )
              : LongButtonDisable(
                  title: MyLocalizations.translate("button_SendRequest"),
                  textColor: Colors.white,
                  disabledColor: Color(0xFFD8D8D8),
                ),
        ),
    );
  }
}

void main() {
  debugPaintSizeEnabled = true; // Enable visual debugging
  runApp(const MaterialApp(
    home: requestBusiness(),
  ));
}
