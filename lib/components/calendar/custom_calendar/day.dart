import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/responsive/app/calendar/leave_set/leave_range.dart';
import 'package:untitled/utils/color_utils.dart';

import '../../../responsive/app/approval/approval_screen_mobile.dart';
import '../../../responsive/app/calendar/leave_set/wfh.dart';
import '../../../responsive/app/calendar/model/user.dart';
import 'model.dart';
import '../../../utils/localizations.dart';
import '../../../utils/style.dart';
import '../../../responsive/app/calendar/leave_set/leave_model.dart';

class DayCalendar2 extends StatefulWidget {
  final day;
  final List<LeaveModel>? listLeaves;
  const DayCalendar2({Key? key, required this.day, required this.listLeaves})
      : super(key: key);

  @override
  State<DayCalendar2> createState() => _DayCalendarState();
}

class _DayCalendarState extends State<DayCalendar2> {
  List<UserImage> userImages = [];
  List<DateModel> calendarDates = [];
  List<Event> listEvent = [];
  late Widget calendar;
  var currentYear = 0;
  var currentMonth = 0;
  bool loadData = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  int getActualMaximumWeekOfMonth(DateTime date) {
    int totalDaysInMonth =
        DateTime(date.year, date.month + 1, 0).day; // output 31
    int firstWeekdayOfMonth =
        DateTime(date.year, date.month, 1).weekday; // output 2 + วันอังคาร
    int remainingDays = totalDaysInMonth - (8 - firstWeekdayOfMonth);
    int actualMaximumWeek = 1 + (remainingDays / 7).ceil(); // .ceil() ปัดขึ้น.5
    return actualMaximumWeek; // ได้ 5 สัปดา
  }

  List<DateModel> getWeekDates(DateTime date) {
    int dayOfWeek = date.weekday; // output 1
    DateTime startOfWeek = date.subtract(Duration(days: dayOfWeek - 1));

    List<DateTime> weekDates = [];

    List<DateModel> weekDates2 = [];

    for (var i = 0; i < DateTime.daysPerWeek; i++) {
      weekDates.add(startOfWeek.add(Duration(days: i)));

      var dateTime = startOfWeek.add(Duration(days: i));
      var isCurrentMonth = false;
      var isCurrentDate = false;
      var isCurrentWeekend = false;
      var today = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
      if (dateTime.month == date.month && dateTime.year == date.year) {
        isCurrentMonth = true;
      }
      if (DateFormat("d/M/y").format(DateTime.now()) == today) {
        isCurrentDate = true;
      }
      if (dateTime.weekday == DateTime.saturday ||
          dateTime.weekday == DateTime.sunday) {
        isCurrentWeekend = true;
      }

      var dateModel = DateModel(
        dateString: "${dateTime.day}/${dateTime.month}/${dateTime.year}",
        date: dateTime,
        isCurrentMonth: isCurrentMonth,
        isCurrentDate: isCurrentDate,
        isCurrentWeekend: isCurrentWeekend,
        listEvents: [],
      );
      weekDates2.add(dateModel);
    }
    return weekDates2;
  }

  List<DateModel> getAllDateInCalendar(int year, int month) {
    var listDateInCalendar = <DateModel>[];
    var date = DateTime(year, month, 1);
    var maxWeekInCalendar = getActualMaximumWeekOfMonth(date);
    for (int i = 0; i < maxWeekInCalendar; i++) {
      listDateInCalendar.addAll(getWeekDates(date));
      date = date.add(const Duration(days: 7));
    }
    return listDateInCalendar;
  }

  Future<void> setBusiness(List<DateModel> listDateModel) async {
    await FirebaseFirestore.instance
        .collection("request_business")
        .get()
        .then((querySnapshot) async {
      for (var document in querySnapshot.docs) {
        var documentData = document.data();
        var userID = documentData['userID'];
        var date = documentData['date'];
        var status = documentData['approveStatus'];
        var startDate = documentData['startDate'].toDate();
        var endDate = documentData['endDate'].toDate();

        Duration difference = endDate.difference(startDate);
        var count = difference.inDays + 1;
        if (count == 0) {
          var useImagesFilter = userImages.where((element) =>
              element.userID == userID && element.imageUrl.isNotEmpty);
          var nameFilter = userImages.where(
              (element) => element.userID == userID && element.name.isNotEmpty);
          if (useImagesFilter.isNotEmpty) {
            var imageUrl = useImagesFilter.first.imageUrl;
            var username = nameFilter.first.name;
            listEvent.add(Event(
                userId: userID,
                dateString: date,
                type: "business",
                status: status,
                startDate: startDate,
                endDate: endDate,
                name: username,
                image: imageUrl));
          } else {
            var userDoc = await FirebaseFirestore.instance
                .collection("users")
                .doc(userID)
                .get();
            if (userDoc.exists) {
              var userData = userDoc.data();
              var userString = userData?["userID"];
              var userImage = userData?['image'];
              var userName = userData?['name'];
              userImages.add(UserImage(
                  userID: userString, imageUrl: userImage, name: userName));
              listEvent.add(Event(
                  userId: userID,
                  dateString: date,
                  type: "business",
                  status: status,
                  startDate: startDate,
                  endDate: endDate,
                  image: userImage,
                  name: userName));
            }
          }
        } else {
          while (startDate.isBefore(endDate) ||
              startDate.isAtSameMomentAs(endDate)) {
            var date2 = DateFormat('d/M/yyyy').format(startDate);
            final DateFormat dateFormat = DateFormat("d/M/yyyy");
            final DateTime date = dateFormat.parse(date2);
            if (date.weekday == DateTime.saturday ||
                date.weekday == DateTime.sunday) {
              startDate = startDate.add(const Duration(days: 1));
            } else {
              var useImagesFilter = userImages.where((element) =>
                  element.userID == userID && element.imageUrl.isNotEmpty);
              var nameFilter = userImages.where((element) =>
                  element.userID == userID && element.name.isNotEmpty);
              if (useImagesFilter.isNotEmpty) {
                var imageUrl = useImagesFilter.first.imageUrl;
                var username = nameFilter.first.name;
                listEvent.add(Event(
                    userId: userID,
                    dateString: date2,
                    type: "business",
                    status: status,
                    startDate: startDate,
                    endDate: endDate,
                    name: username,
                    image: imageUrl));
              } else {
                var userDoc = await FirebaseFirestore.instance
                    .collection("users")
                    .doc(userID)
                    .get();
                if (userDoc.exists) {
                  var userData = userDoc.data();
                  var userString = userData?["userID"];
                  var userImage = userData?['image'];
                  var userName = userData?['name'];

                  userImages.add(UserImage(
                      userID: userString, imageUrl: userImage, name: userName));
                  listEvent.add(Event(
                      userId: userID,
                      dateString: date2,
                      type: "business",
                      status: status,
                      startDate: startDate,
                      endDate: endDate,
                      name: userName,
                      image: userImage));
                }
              }
              startDate = startDate.add(const Duration(days: 1));
            }
          }
        }
      }
      for (int i = 0; i < calendarDates.length; i++) {
        var listEventsFilter = listEvent
            .where(
                (element) => element.dateString == calendarDates[i].dateString)
            .toList();
        calendarDates[i].listEvents = listEventsFilter;
      }
      setAnnual(calendarDates);
    });
  }

  Future<void> setAnnual(List<DateModel> listDateModel) async {
    await FirebaseFirestore.instance
        .collection("request_annual")
        .get()
        .then((querySnapshot) async {
      for (var document in querySnapshot.docs) {
        var documentData = document.data();
        var userID = documentData['userID'];
        var date = documentData['date'];
        var status = documentData['approveStatus'];
        var startDate = documentData['startDate'].toDate();
        var endDate = documentData['endDate'].toDate();

        Duration difference = endDate.difference(startDate);
        var count = difference.inDays + 1;
        if (count == 0) {
          var useImagesFilter = userImages.where((element) =>
              element.userID == userID && element.imageUrl.isNotEmpty);
          var nameFilter = userImages.where(
              (element) => element.userID == userID && element.name.isNotEmpty);
          if (useImagesFilter.isNotEmpty) {
            var imageUrl = useImagesFilter.first.imageUrl;
            var username = nameFilter.first.name;
            listEvent.add(Event(
                userId: userID,
                dateString: date,
                type: "annual",
                status: status,
                startDate: startDate,
                endDate: endDate,
                name: username,
                image: imageUrl));
          } else {
            var userDoc = await FirebaseFirestore.instance
                .collection("users")
                .doc(userID)
                .get();
            if (userDoc.exists) {
              var userData = userDoc.data();
              var userString = userData?["userID"];
              var userImage = userData?['image'];
              var username = userData?['name'];
              userImages.add(UserImage(
                  userID: userString, imageUrl: userImage, name: username));
              listEvent.add(Event(
                  userId: userID,
                  dateString: date,
                  type: "annual",
                  status: status,
                  startDate: startDate,
                  endDate: endDate,
                  name: username,
                  image: userImage));
            }
          }
        } else {
          while (startDate.isBefore(endDate) ||
              startDate.isAtSameMomentAs(endDate)) {
            var date2 = DateFormat('d/M/yyyy').format(startDate);
            final DateFormat dateFormat = DateFormat("d/M/yyyy");
            final DateTime date = dateFormat.parse(date2);
            if (date.weekday == DateTime.saturday ||
                date.weekday == DateTime.sunday) {
              startDate = startDate.add(const Duration(days: 1));
            } else {
              var useImagesFilter = userImages.where((element) =>
                  element.userID == userID && element.imageUrl.isNotEmpty);
              var nameFilter = userImages.where((element) =>
                  element.userID == userID && element.name.isNotEmpty);
              if (useImagesFilter.isNotEmpty) {
                var imageUrl = useImagesFilter.first.imageUrl;
                var username = nameFilter.first.name;
                listEvent.add(Event(
                    userId: userID,
                    dateString: date2,
                    type: "annual",
                    status: status,
                    startDate: startDate,
                    endDate: endDate,
                    name: username,
                    image: imageUrl));
              } else {
                var userDoc = await FirebaseFirestore.instance
                    .collection("users")
                    .doc(userID)
                    .get();
                if (userDoc.exists) {
                  var userData = userDoc.data();
                  var userString = userData?["userID"];
                  var userImage = userData?['image'];
                  var username = userData?['name'];
                  userImages.add(UserImage(
                      userID: userString, imageUrl: userImage, name: username));
                  listEvent.add(Event(
                      userId: userID,
                      dateString: date2,
                      type: "annual",
                      status: status,
                      startDate: startDate,
                      endDate: endDate,
                      name: username,
                      image: userImage));
                }
              }
              startDate = startDate.add(const Duration(days: 1));
            }
          }

          for (int i = 0; i < calendarDates.length; i++) {
            var listEventsFilter = listEvent
                .where((element) =>
                    element.dateString == calendarDates[i].dateString)
                .toList();
            calendarDates[i].listEvents = listEventsFilter;
          }
        }
      }
    });
    setSick(calendarDates);
  }

  Future<void> setSick(List<DateModel> listDateModel) async {
    await FirebaseFirestore.instance
        .collection("request_sick")
        .get()
        .then((querySnapshot) async {
      for (var document in querySnapshot.docs) {
        var documentData = document.data();
        var userID = documentData['userID'];
        var date = documentData['date'];
        var status = documentData['approveStatus'];
        var startDate = documentData['startDate'].toDate();
        var endDate = documentData['endDate'].toDate();

        Duration difference = endDate.difference(startDate);
        var count = difference.inDays + 1;
        if (count == 0) {
          var useImagesFilter = userImages.where((element) =>
              element.userID == userID && element.imageUrl.isNotEmpty);
          var nameFilter = userImages.where(
              (element) => element.userID == userID && element.name.isNotEmpty);
          if (useImagesFilter.isNotEmpty) {
            var imageUrl = useImagesFilter.first.imageUrl;
            var username = nameFilter.first.name;
            listEvent.add(Event(
                userId: userID,
                dateString: date,
                type: "sick",
                status: status,
                startDate: startDate,
                name: username,
                endDate: endDate,
                image: imageUrl));
          } else {
            var userDoc = await FirebaseFirestore.instance
                .collection("users")
                .doc(userID)
                .get();
            if (userDoc.exists) {
              var userData = userDoc.data();
              var userString = userData?["userID"];
              var userImage = userData?['image'];
              var username = userData?['name'];
              userImages.add(UserImage(
                  userID: userString, imageUrl: userImage, name: username));
              listEvent.add(Event(
                  userId: userID,
                  dateString: date,
                  type: "sick",
                  status: status,
                  name: username,
                  startDate: startDate,
                  endDate: endDate,
                  image: userImage));
            }
          }
        } else {
          while (startDate.isBefore(endDate) ||
              startDate.isAtSameMomentAs(endDate)) {
            var date2 = DateFormat('d/M/yyyy').format(startDate);
            final DateFormat dateFormat = DateFormat("d/M/yyyy");
            final DateTime date = dateFormat.parse(date2);
            if (date.weekday == DateTime.saturday ||
                date.weekday == DateTime.sunday) {
              startDate = startDate.add(const Duration(days: 1));
            } else {
              var useImagesFilter = userImages.where((element) =>
                  element.userID == userID && element.imageUrl.isNotEmpty);
              var nameFilter = userImages.where((element) =>
                  element.userID == userID && element.name.isNotEmpty);
              if (useImagesFilter.isNotEmpty) {
                var imageUrl = useImagesFilter.first.imageUrl;
                var username = nameFilter.first.name;
                listEvent.add(Event(
                    userId: userID,
                    name: username,
                    dateString: date2,
                    type: "sick",
                    status: status,
                    startDate: startDate,
                    endDate: endDate,
                    image: imageUrl));
              } else {
                var userDoc = await FirebaseFirestore.instance
                    .collection("users")
                    .doc(userID)
                    .get();
                if (userDoc.exists) {
                  var userData = userDoc.data();
                  var userString = userData?["userID"];
                  var userImage = userData?['image'];
                  var username = userData?['name'];
                  userImages.add(UserImage(
                      userID: userString, imageUrl: userImage, name: username));
                  listEvent.add(Event(
                      userId: userID,
                      name: username,
                      dateString: date2,
                      type: "sick",
                      status: status,
                      startDate: startDate,
                      endDate: endDate,
                      image: userImage));
                }
              }
              startDate = startDate.add(const Duration(days: 1));
            }
          }

          for (int i = 0; i < calendarDates.length; i++) {
            var listEventsFilter = listEvent
                .where((element) =>
                    element.dateString == calendarDates[i].dateString)
                .toList();
            calendarDates[i].listEvents = listEventsFilter;
          }
        }
      }
    });
    setWFH(calendarDates);
  }

  Future<void> setWFH(List<DateModel> listDateModel) async {
    await FirebaseFirestore.instance
        .collection("request_wfh")
        .get()
        .then((querySnapshot) async {
      for (var document in querySnapshot.docs) {
        var documentData = document.data();
        var userID = documentData['userID'];
        var date = documentData['date'];
        var status = documentData['approveStatus'];
        var startDate = documentData['selectDate'].toDate();
        var endDate = documentData['selectDate'].toDate();
        var useImagesFilter = userImages.where((element) =>
            element.userID == userID && element.imageUrl.isNotEmpty);
        var nameFilter = userImages.where((element) =>
            element.userID == userID && element.imageUrl.isNotEmpty);
        if (useImagesFilter.isNotEmpty) {
          var imageUrl = useImagesFilter.first.imageUrl;
          var username = nameFilter.first.name;
          listEvent.add(Event(
              userId: userID,
              dateString: date,
              name: username,
              type: "wfh",
              status: status,
              startDate: startDate,
              endDate: endDate,
              image: imageUrl));
        } else {
          var userDoc = await FirebaseFirestore.instance
              .collection("users")
              .doc(userID)
              .get();
          if (userDoc.exists) {
            var userData = userDoc.data();
            var userString = userData?["userID"];
            var userImage = userData?['image'];
            var username = userData?['name'];
            userImages.add(UserImage(
                userID: userString, imageUrl: userImage, name: username));
            listEvent.add(Event(
                userId: userID,
                dateString: date,
                type: "wfh",
                name: username,
                status: status,
                startDate: startDate,
                endDate: endDate,
                image: userImage));
          }
        }
      }
      for (int i = 0; i < calendarDates.length; i++) {
        var listEventsFilter = listEvent
            .where(
                (element) => element.dateString == calendarDates[i].dateString)
            .toList();
        calendarDates[i].listEvents = listEventsFilter;
      }
      setState(() {
        loadData = true;
        calendar = setCalendar();
      });
    });
  }

  GridView setCalendar() {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
        ),
        itemCount: calendarDates.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () => _showEachDay(context, index),
              child: GridTile(
                  child: Container(
                      decoration: BoxDecoration(
                        color: calendarDates[index].isCurrentDate
                            ? backgroundLow
                            : white,
                        border: Border.all(color: calendarBorder),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 48,
                              height: 48,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Text(
                                      DateFormat("d")
                                          .format(calendarDates[index].date),
                                      style: calendarDates[index]
                                              .isCurrentWeekend
                                          ? calendarDates[index].isCurrentMonth
                                              ? calendarDayOfWeekRed
                                              : calendarDayOfWeek
                                          : calendarDates[index].isCurrentMonth
                                              ? calendarDayOfDay
                                              : calendarDayOfWeek),
                                  calendarDates[index]
                                              .listEvents
                                              .where((element) =>
                                                  element.type == "business" ||
                                                  element.type == "sick" ||
                                                  element.type == "annual")
                                              .where((element) =>
                                                  element.status == "approved")
                                              .where((element) =>
                                                  element.dateString ==
                                                  calendarDates[index]
                                                      .dateString)
                                              .isEmpty &&
                                          calendarDates[index]
                                              .listEvents
                                              .where((element) =>
                                                  element.type == "wfh")
                                              .where((element) =>
                                                  element.status == "approved")
                                              .where((element) =>
                                                  element.dateString ==
                                                  calendarDates[index]
                                                      .dateString)
                                              .isEmpty
                                      ? Container()
                                      : SizedBox(
                                          width: 80,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                width: 10,
                                                height: 10,
                                                color: leaveBGColor,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  calendarDates[index]
                                                      .listEvents
                                                      .where((element) =>
                                                          element.type ==
                                                              "business" ||
                                                          element.type ==
                                                              "sick" ||
                                                          element.type ==
                                                              "annual")
                                                      .where((element) =>
                                                          element.status ==
                                                          "approved")
                                                      .where((element) =>
                                                          element.dateString ==
                                                          calendarDates[index]
                                                              .dateString)
                                                      .length
                                                      .toString(),
                                                  style: calendarLeave,
                                                ),
                                              ),
                                              Container(
                                                width: 10,
                                                height: 10,
                                                color: wfhBGColor,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  calendarDates[index]
                                                      .listEvents
                                                      .where((element) =>
                                                          element.type == "wfh")
                                                      .where((element) =>
                                                          element.status ==
                                                          "approved")
                                                      .where((element) =>
                                                          element.dateString ==
                                                          calendarDates[index]
                                                              .dateString)
                                                      .length
                                                      .toString(),
                                                  style: calendarWfh,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                ],
                              ),
                            )
                          ]))));
        });
  }

  Future _showEachDay(BuildContext context, int index) {
    var day = calendarDates[index];
    List<LeaveModel>? listLeaves = widget.listLeaves ?? [];
    listLeaves = listLeaves
        .where((element) =>
            element.status == "approved" && element.date == day.dateString)
        .toList();
    return showModalBottomSheet(
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
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: const BoxDecoration(
                    color: bg,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 16),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                MyLocalizations.formatDateDay(day.date),
                                style: headerCard,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    MyLocalizations.translate("text_Leave"),
                                    style: text,
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Text(
                                          '${listEvent.where((element) => element.dateString == calendarDates[index].dateString && element.status == "approved" && element.type != "wfh").length} ${MyLocalizations.translate("text_People")}'))
                                ],
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.13,
                                    child: LeaveRange(
                                        listEvent: listEvent,
                                        day: calendarDates[index].dateString),
                                  )
                                  // Text('a'))
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      MyLocalizations.translate("text_WFH"),
                                      style: text,
                                    ),
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: Text(
                                            '${listEvent.where((element) => element.dateString == calendarDates[index].dateString && element.status == "approved" && element.type == "wfh").length} ${MyLocalizations.translate("text_People")}'))
                                  ],
                                )
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.13,
                                  child: WFHRange(
                                      listEvent: listEvent,
                                      day: calendarDates[index].dateString),
                                )
                                // Text('a'))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var getYear = widget.day.year; // clear
    var getMonth = widget.day.month; // clear

    if (currentYear != getYear || currentMonth != getMonth) {
      calendarDates = getAllDateInCalendar(getYear, getMonth);
      listEvent = [];
      loadData = false;
      currentYear = getYear;
      currentMonth = getMonth;
      setBusiness(calendarDates);
    }
    calendar = setCalendar();
    return loadData ? calendar : const LoadingAnimation();
  }
}
