import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:untitled/utils/color_utils.dart';
import 'package:untitled/utils/style.dart';
import '../../../../components/date_picker.dart';
import '../../../../components/dialog/dialog.dart';
import '../../../../components/long_button.dart';
import '../../../../components/long_button_disable.dart';
import '../../../../components/request/date_picker_field.dart';
import '../../../../utils/localizations.dart';
import '../success_page.dart';

class requestWFH extends StatefulWidget {
  const requestWFH({Key? key}) : super(key: key);

  @override
  State<requestWFH> createState() => _requestWFHState();
}

class DateSelectionBox {
  String id;
  DateTime? selectedDate;
  DateSelectionBox({required this.id, this.selectedDate});
}

class _requestWFHState extends State<requestWFH> {
  List<DateSelectionBox> dateSelectionBoxes = [];
  List<String> dateIDs = [];
  List<DateTime> selectedDates = [];

  final _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false; // Initialize as false

  void _clearTextFields() {
    for (var box in dateSelectionBoxes) {
      box.selectedDate = null;
    }
  }

  ///logic add new requestWFH
  Future<void> _addNewRequestWFH() async {
    List<DateTime> selectedDates = [];

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        for (var dateBox in dateSelectionBoxes) {
          if (dateBox.selectedDate != null) {
            String id = DateTime.now().microsecondsSinceEpoch.toString();
            dateIDs.add(id);
            DocumentReference newRequestRef = await FirebaseFirestore.instance
                .collection('request_wfh')
                .doc(id);
            String wfhId = newRequestRef.id;
            await newRequestRef.set({
              'userID': user.uid,
              'requestID': wfhId,
              'selectDate': dateBox.selectedDate,
              'createDate': DateTime.now(),
              'approveBy': '',
              'approveDate': '',
              'approveStatus': 'waiting',
              'date': DateFormat('d/M/y').format(dateBox.selectedDate!),
            });

            selectedDates.add(dateBox.selectedDate!);
          }
        }
      } else {
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessPage(
            icon: 'assets/images/icon_tag_leave/wfh_tag.png',
            requestType: 'Work From Home',
            selectedDates: selectedDates,
          ),
        ),
      );

      dateSelectionBoxes.clear();
      dateIDs.clear();
      dateSelectionBoxes.add(
        DateSelectionBox(id: DateTime.now().microsecondsSinceEpoch.toString()),
      );
      _clearTextFields();
      _isButtonEnabled = false;
      setState(() {});
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }


  }

  @override
  void initState() {
    super.initState();
    // Initially, add one box for date selection
    dateSelectionBoxes.add(
        DateSelectionBox(id: DateTime.now().microsecondsSinceEpoch.toString()));
  }

  Future<List<DocumentSnapshot>> getWFHDatesByStatus(String status, String userID) async {
    CollectionReference requestWFHCollection =
    FirebaseFirestore.instance.collection('request_wfh');

    QuerySnapshot snapshot = await requestWFHCollection
        .where('approveStatus', isEqualTo: status)
        .where('userID', isEqualTo: userID) // Add this line to filter by userID
        .get();
    return snapshot.docs;
  }


  Future<void> _selectDate(int index) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle case where the user is not signed in.
      return;
    }

    // Call getWFHDatesByStatus to retrieve disabled dates for 'approved' status
    List<DocumentSnapshot> approvedDatesSnapshots =
    await getWFHDatesByStatus('approved', user.uid);

    // Call getWFHDatesByStatus to retrieve disabled dates for 'waiting' status
    List<DocumentSnapshot> waitingDatesSnapshots =
    await getWFHDatesByStatus('waiting', user.uid);

    // Convert both approvedDatesSnapshots and waitingDatesSnapshots to a set of DateTime objects
    List<String> disabledDates = [];

    final DateFormat dateFormat = DateFormat('d/M/yyyy');

    for (var snapshot in approvedDatesSnapshots) {
      final Timestamp timestamp = snapshot['selectDate'];
      final DateTime date = timestamp.toDate();
      disabledDates.add(dateFormat.format(date));
    }

    for (var snapshot in waitingDatesSnapshots) {
      final Timestamp timestamp = snapshot['selectDate'];
      final DateTime date = timestamp.toDate();
      disabledDates.add(dateFormat.format(date));
    }


    // Use the custom date picker widget from components/date_picker.dart
    final DateTime? picked = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DatePicker(
          // Use the custom date picker widget
          initialDate: dateSelectionBoxes[index].selectedDate,
          disableDate: disabledDates,
        );
      },
    );

    if (picked != null) {
      // Check if the selected date already exists in selectedDates
      if (selectedDates.contains(picked)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ConfirmDialog(
              type: 'error',
              message: MyLocalizations.translate("text_ErrorSameDate"),
              onConfirm: () {
              },
            );
          },
        );
      } else {
        // Update the selected date in the current box and add it to selectedDates
        setState(() {
          dateSelectionBoxes[index].selectedDate = picked;
          selectedDates.add(picked);
          _updateButtonState();
        });
      }
    }
  }

  void _addDateSelectionBox() {
    // Check if there's already a box with no date
    bool hasEmptyBox =
        dateSelectionBoxes.any((box) => box.selectedDate == null);

    if (!hasEmptyBox) {
      setState(() {
        dateSelectionBoxes.add(DateSelectionBox(
            id: DateTime.now().microsecondsSinceEpoch.toString()));
      });
    }
  }

  void _updateButtonState() {
    bool isEnabled = dateSelectionBoxes.any((box) => box.selectedDate != null) || selectedDates.isNotEmpty;
    print("_isButtonEnabled: $isEnabled");
    setState(() {
      _isButtonEnabled = isEnabled;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            MyLocalizations.translate("appbar_WFH"),
            style: appBar,
          ),
          backgroundColor: white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView( // Scroll within this container
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        for (int index = 0; index < dateSelectionBoxes.length; index++)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () => _selectDate(index),
                                child: AbsorbPointer(
                                  child: SelectDateFormField(
                                    controller: TextEditingController(
                                      text: dateSelectionBoxes[index].selectedDate != null
                                          ? DateFormat('dd/MM/yyyy').format(
                                          dateSelectionBoxes[index].selectedDate!)
                                          : '',
                                    ),
                                    title: MyLocalizations.translate("text_SelectDate"),
                                    hint: MyLocalizations.translate("hint_SelectDate"),
                                    validate: _validateDueDateField,
                                  ),
                                ),
                              ),
                              if (index == dateSelectionBoxes.length - 1)
                                GestureDetector(
                                  onTap: () => _addDateSelectionBox(),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: SvgPicture.asset(
                                          'assets/svg/request/add_calendar.svg', // Replace with the actual path to your SVG asset
                                          width: 24,
                                          height: 24,
                                        ),
                                        onPressed: _addDateSelectionBox,
                                      ),
                                      Text(MyLocalizations.translate("button_AddMoreWFH"), style: orangeItalic2),
                                    ],
                                  ),
                                )
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16), // Adjust the spacing as needed
              child: Container(
                child: _isButtonEnabled
                    ? LongButton(
                  title: MyLocalizations.translate("button_SendRequest"),
                  ontap: () {
                    if (_formKey.currentState!.validate()) {
                      _addNewRequestWFH();
                    }
                  },
                )
                    : LongButtonDisable(
                  title: MyLocalizations.translate("button_SendRequest"),
                  textColor: Colors.white,
                  disabledColor: Color(0xFFD8D8D8),
                ),
              ),
            ),
          ],
        ),
    );
  }

  String? _validateDueDateField(String? value) {
    if (selectedDates.isEmpty) {
      return 'Please select at least one date';
    }
    return null;
  }
}

void main() {
  runApp(const MaterialApp(
    home: requestWFH(),
  ));
}
