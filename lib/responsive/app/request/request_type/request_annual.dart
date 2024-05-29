import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../components/TextFormField.dart';
import '../../../../components/date_picker.dart';
import '../../../../components/long_button.dart';
import '../../../../components/long_button_disable.dart';
import '../../../../components/request/date_picker_field.dart';
import '../../../../utils/color_utils.dart';
import '../../../../utils/localizations.dart';
import '../../../../utils/style.dart';
import '../success_page.dart';

class DateSelectionBox {
  String id;
  DateTime? startDate;
  DateTime? endDate;

  DateSelectionBox({required this.id, this.startDate, this.endDate});
}

class requestAnnual extends StatefulWidget {
  const requestAnnual({Key? key}) : super(key: key);

  @override
  State<requestAnnual> createState() => _requestAnnualState();
}

class _requestAnnualState extends State<requestAnnual> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  DateSelectionBox startDateBox = DateSelectionBox(id: 'startDate');
  DateSelectionBox endDateBox = DateSelectionBox(id: 'endDate');
  bool _isButtonEnabled = false; // Initialize as false

  Future<List<DocumentSnapshot>> getAnnualDatesByStatus(String status, String userID) async {
    CollectionReference requestAnnualCollection =
        FirebaseFirestore.instance.collection('request_annual');

    QuerySnapshot snapshot = await requestAnnualCollection
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
    // Call getAnnualDatesByStatus to retrieve disabled dates for 'approved' and 'waiting' statuses
    List<DocumentSnapshot> approvedDatesSnapshots =
        await getAnnualDatesByStatus('approved', user.uid);
    List<DocumentSnapshot> waitingDatesSnapshots =
        await getAnnualDatesByStatus('waiting', user.uid);

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

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _formKey.currentState != null &&
          startDateBox.startDate != null &&
          endDateBox.endDate != null &&
          _reasonController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    _updateButtonState(); // Update button state
    return Scaffold(
        appBar: AppBar(
          title: Text(
            MyLocalizations.translate("text_AnnualLeave"),
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
                                .collection('request_annual')
                                .doc();
                        String annualId =
                            newRequestRef.id; // Get the generated taskID
                        await newRequestRef.set({
                          'userID': user.uid,
                          'requestID': annualId,
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
                              icon: 'assets/images/icon_tag_leave/annual_tag.png',
                              requestType: 'Annual Leave',
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

String? _validateStartDateField(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please select a start date';
  }
  return null;
}

String? _validateEndDateField(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please select a start date';
  }
  return null;
}

void main() {
  runApp(const MaterialApp(
    home: requestAnnual(),
  ));
}
