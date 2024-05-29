import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/responsive/app/calendar/showData.class.dart';
import 'package:untitled/responsive/app/calendar/showDataLeave.dart';
import 'package:untitled/utils/style.dart';
import '../../../components/calendar/custom_calendar/main.dart';
import '../../../components/request/request_button.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/localizations.dart';
import '../../../utils/snackbar.dart';
import '../request/request_type/request_annual.dart';
import '../request/request_type/request_business.dart';
import '../request/request_type/request_sick.dart';
import '../request/request_type/request_wfh.dart';
import 'leave_set/leave_model.dart';

class CalendarPageWeb extends StatefulWidget {
  const CalendarPageWeb({Key? key}) : super(key: key);

  @override
  State<CalendarPageWeb> createState() => _CalendarPageMobileState();
}

class _CalendarPageMobileState extends State<CalendarPageWeb> {
  final _appbarTitleNotifier = ValueNotifier<String>('');
  final _monthNameNotifier = ValueNotifier<String>('');
  bool isLoading = false;
  var currentUser = {};
  List<LeaveModel> listLeaves = [];
  late ShowDataLeave showDataLeave = ShowDataLeave(
    listLeaves: listLeaves,
  );

  // void _createAnnual() {
  //   FirebaseFirestore.instance
  //       .collection("request_annual")
  //       .get()
  //       .then((querySnapshot) {
  //     for (var document in querySnapshot.docs) {
  //       var documentData = document.data();
  //       var userID = documentData['userID'] ?? "";
  //       var date = documentData['date'] ?? "";
  //       var status = documentData['approveStatus'] ?? "";
  //       listLeaves.add(LeaveModel(userID, date, status, "annual"));
  //     }
  //     _createBusiness();
  //   });
  // }
  //
  // void _createBusiness() {
  //   FirebaseFirestore.instance
  //       .collection("request_business")
  //       .get()
  //       .then((querySnapshot) {
  //     for (var document in querySnapshot.docs) {
  //       var documentData = document.data();
  //
  //       var userID = documentData['userID'];
  //       var date = documentData['date'];
  //       var status = documentData['approveStatus'];
  //       listLeaves.add(LeaveModel(userID, date, status, "business"));
  //     }
  //     _createSick();
  //   });
  // }
  //
  // void _createSick() {
  //   FirebaseFirestore.instance
  //       .collection("request_sick")
  //       .get()
  //       .then((querySnapshot) {
  //     for (var document in querySnapshot.docs) {
  //       var documentData = document.data();
  //       var userID = documentData['userID'];
  //       var date = documentData['date'];
  //       var status = documentData['approveStatus'];
  //       listLeaves.add(LeaveModel(userID, date, status, "sick"));
  //     }
  //
  //     setState(() {
  //       showDataLeave = ShowDataLeave(
  //         listLeaves: listLeaves,
  //       );
  //     });
  //   });
  // }

  @override
  void initState() {
    loadData();
    // _createAnnual();
    super.initState();
  }

  loadData() async {
    var prefs = await SharedPreferences.getInstance();
    final String selectedLanguage = prefs.getString('language') ?? "th";
    Intl.defaultLocale = selectedLanguage;
    await initializeDateFormatting();
  }

  @override
  void dispose() {
    _appbarTitleNotifier.dispose();
    _monthNameNotifier.dispose();
    super.dispose();
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

  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('myCollection');

  Future<int> getCount() async {
    QuerySnapshot querySnapshot = await _collection.get();
    return querySnapshot.size;
  }

  ///Request Bottom Sheet
  void _selectRequest() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32.0),
        ),
      ),
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32.0),
            topRight: Radius.circular(32.0),
          ),
          child: SafeArea(
            child: Container(
              // Wrap the body with a Container for the background
              decoration: const BoxDecoration(
                color: bg,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RequestButton(
                          label: 'WFH',
                          icon: 'assets/svg/request/wfh.svg',
                          bgButton: wfh,
                          textStyle: iconText,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const requestWFH(),
                              ),
                            );
                          },
                        ),
                        RequestButton(
                          label: 'Business Leave',
                          icon: 'assets/svg/request/business.svg',
                          bgButton: business,
                          textStyle: iconText,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const requestBusiness(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RequestButton(
                          label: 'Sick Leave',
                          icon: 'assets/svg/request/sick.svg',
                          bgButton: sick,
                          textStyle: iconText,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const requestSick(),
                              ),
                            );
                          },
                        ),
                        RequestButton(
                          label: 'Annual Leave',
                          icon: 'assets/svg/request/annual.svg',
                          bgButton: annual,
                          textStyle: iconText,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const requestAnnual(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          MyLocalizations.translate("appbar_Calendar"),
          style: const TextStyle(color: black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 0.46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     IconButton(
                    //       icon: const Icon(
                    //         Icons.arrow_back_ios,
                    //         color: black,
                    //       ),
                    //       onPressed: () {
                    //         _changeCalendarPage(showNext: false);
                    //       },
                    //     ),
                    //     ValueListenableBuilder(
                    //       valueListenable: _monthNameNotifier,
                    //       builder: (ctx, value, child) => Text(
                    //         value,
                    //         style: const TextStyle(
                    //             fontSize: 16,
                    //             color: violet,
                    //             fontWeight: FontWeight.w600),
                    //       ),
                    //     ),
                    //     IconButton(
                    //       icon: const Icon(
                    //         Icons.arrow_forward_ios,
                    //         color: black,
                    //       ),
                    //       onPressed: () {
                    //         _changeCalendarPage(showNext: true);
                    //       },
                    //     ),
                    //   ],
                    // ),

                    /// Calendar view.
                    // Expanded(child: calendar),
                    Expanded(
                        child: CalendarCustom(
                      listLeaves: listLeaves,
                    ))
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 14, right: 20),
            child: Row(
              children: [
                Text(
                  // "${DateFormat('d MMMM y').format(DateTime.now())} วันนี้",
                  "${MyLocalizations.formatDateDay(DateTime.now())} ${MyLocalizations.translate("text_Today")}",
                  style: headerCard,
                ),
              ],
            ),
          ),
          Expanded(
            child: showDataLeave,
          ),
          const Expanded(child: ShowData()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _selectRequest();
        },
        backgroundColor: white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: const BorderSide(color: orange)),
        child: const Icon(
          Icons.add,
          size: 30,
          color: orange,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
