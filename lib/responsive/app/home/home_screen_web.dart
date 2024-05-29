import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/components/todo/todocard.dart';
import '../../../components/long_button.dart';
import '../../../components/long_button_disable.dart';
import '../../../components/todo/todocard_manager.dart';
import '../../../utils/snackbar.dart';
import '../approval/approval_screen_mobile.dart';
import '../setting/setting_screen.dart';
import 'checkin_page.dart';
import 'package:badges/badges.dart' as badges;

class HomePageWeb extends StatefulWidget {
  const HomePageWeb({Key? key}) : super(key: key);

  @override
  State<HomePageWeb> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageWeb>
    with TickerProviderStateMixin {
  int currentIndex = 0;
  int newDataLength = 0;
  List<String> backgrounds = [
    'assets/images/background/morning_background.png',
    'assets/images/background/afternoon_background.png',
    'assets/images/background/evening_background.png',
  ];
  List<String> greetings = [
    "Small steps, big dreams. ✨",
    "Challenges build character. 💪",
    "Embrace change, evolve. 🌱",
    "Failure fuels success. 🔥",
    "Kindness ripples far. 🌊",
    "Gratitude, abundance mindset. 🙏",
    "Positivity, the real power. 🌟",
    "Learning, a lifelong journey. 📚",
    "Every day, a fresh canvas. 🎨",
    "Your passion, your purpose. 🔥",
    "Adaptability, the key. 🧩",
    "Innovation sparks progress. 🚀",
    "Confidence, your superpower. 💪",
    "Mindset shapes reality. 🧠",
    "Self-belief, magical force. 🌈",
    "Imagination, limitless potential. 🌌",
    "Happiness, a state of mind. 😄",
    "Success, a series of choices. 🏆",
    "Believe, you will achieve. 🌠",
    "Gratitude, a daily practice. 🙌",
    "Resilience, strength within. 🏋️‍",
    "Love, the ultimate currency. ❤️",
    "Compassion changes the world. 🌍",
    "Acceptance, find inner peace. ☮️",
    "The journey, the destination. 🛤️",
    "Strive for progress, not perfection. 📈",
    "Every moment, a chance. ⏳",
    "Embrace uncertainty, grow. 🌱",
    "The past shapes you, not defines you. 🌄",
    "Wisdom, a lifelong treasure. 📜",
    "Have a good day :)"
  ];

  Random random = Random();
  int randomGreetingIndex = 0;
  DateTime? lastUsedDate;

  bool isLoading = false;
  late var currentUser = {};

  Timer? _timer;
  bool isCheckInEnabled = false;

  late SharedPreferences? _prefs;
  late AnimationController _lottieController;

  get addedItems => null; // Declare AnimationController

  @override
  void initState() {
    // Initialize SharedPreferences

    super.initState();
    getData();
    _initSharedPreferences();
    _updateBackgroundAndGreetings();
    _startTimer();
    _lottieController = AnimationController(
        vsync: this,
        duration: const Duration(
            seconds:
            1)); // Specify the duration here (1 second in this example)
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    _lottieController.dispose(); // Dispose of AnimationController
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 60), (_) {
      setState(() {
        _updateButtonStates();
      });
    });
  }

  void _updateButtonStates() {
    var now = DateTime.now();
    int hour = now.hour;
    int minute = now.minute;

    bool isMorningCheckInEnabled =
        (hour == 8 && minute >= 30) || (hour == 9 && minute <= 30);

    bool isAfternoonCheckInEnabled =
        (hour == 13 && minute >= 0) || (hour == 14 && minute <= 0);

    bool isEveningCheckInEnabled =
        (hour == 18 && minute >= 0) || (hour == 19 && minute <= 30);

    if (currentIndex == 0) {
      setState(() {
        isCheckInEnabled = isMorningCheckInEnabled;
      });
    } else if (currentIndex == 1) {
      setState(() {
        isCheckInEnabled = isAfternoonCheckInEnabled;
      });
    } else if (currentIndex == 2) {
      setState(() {
        isCheckInEnabled = isEveningCheckInEnabled;
      });
    }
  }

  void getData() async {
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

  String getCurrentTime() {
    var now = DateTime.now();
    int hour = now.hour;
    int minute = now.minute;

    if (currentIndex == 0) {
      return 'Morning Check-in 08:30-09:30 am 📸';
    } else if (currentIndex == 1) {
      return 'Afternoon Check-in 13:00-14:00 pm 📸';
    } else if (currentIndex == 2) {
      return 'Evening Check-in 18:00-19:30 pm 📸';
    }

    return DateFormat.jm().format(now);
  }

  void _updateBackgroundAndGreetings() {
    var now = DateTime.now();
    int hour = now.hour;
    int minute = now.minute;
    if ((hour >= 5 && hour < 12) || (hour == 12 && minute <= 0)) {
      setState(() {
        currentIndex = 0;
      });
    } else if ((hour >= 12 && hour < 18) || (hour == 18 && minute <= 0)) {
      setState(() {
        currentIndex = 1;
      });
    } else {
      setState(() {
        currentIndex = 2;
      });
    }
  }

  String getHelloText() {
    if (currentUser.containsKey('name')) {
      String name = currentUser['name'];
      if (name.length > 10) {
        name = '${name.substring(0, 10)}...';
      }
      return 'Hello, $name';
    } else {
      return 'Hello';
    }
  }

  void _checkIn(String timeSlot) {
    String currentDate = DateFormat('yyyy_MM_dd').format(DateTime.now());
    String userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentReference checkinRef = FirebaseFirestore.instance
        .collection('checkins')
        .doc('$userId-$currentDate');
    checkinRef.update({
      timeSlot: DateTime.now().toString(),
      '$timeSlot' + 'Success': true,
    }).then((_) {
      showSnackBar(context, 'Check-in successful for $timeSlot');
      setState(() {
        _updateBackgroundAndGreetings();
      });
    }).catchError((error) {});
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void updateRandomGreetingIndex() {
    DateTime currentDate = DateTime.now();

    if (lastUsedDate == null || !isSameDay(lastUsedDate!, currentDate)) {
      randomGreetingIndex = random.nextInt(greetings.length);
      lastUsedDate = currentDate;

      print('Last used date: $lastUsedDate');
    }
  }

  Stream<QuerySnapshot> _combinedStreams() {
    // Get the user's role
    String userRole = currentUser?['role'] ?? "staff";

    print("userRole in home :" + userRole.toString());
    // Define the streams based on user role
    Stream<QuerySnapshot> userStream;
    if (userRole == "staff" || userRole == "สตาฟ") {
      print("userRole in staff :" + userRole.toString());
      // Staff user: Listen to the specific userID in Firestore for relevant collections
      userStream = Rx.merge([
        FirebaseFirestore.instance
            .collection('request_annual')
            .where('userID', isEqualTo: currentUser['userID'])
            .snapshots(),
        FirebaseFirestore.instance
            .collection('request_business')
            .where('userID', isEqualTo: currentUser['userID'])
            .snapshots(),
        FirebaseFirestore.instance
            .collection('request_sick')
            .where('userID', isEqualTo: currentUser['userID'])
            .snapshots(),
        FirebaseFirestore.instance
            .collection('request_wfh')
            .where('userID', isEqualTo: currentUser['userID'])
            .snapshots(),
      ]);
    } else if (userRole == "manager" || userRole == "เมเนเจอร์") {
      print("userRole in manager :" + userRole.toString());
      // Manager user: Listen to relevant collections with 'waiting' approvedStatus
      userStream = Rx.merge([
        FirebaseFirestore.instance
            .collection('request_annual')
            .where('approveStatus', isEqualTo: "waiting")
            .snapshots(),
        FirebaseFirestore.instance
            .collection('request_business')
            .where('approveStatus', isEqualTo: "waiting")
            .snapshots(),
        FirebaseFirestore.instance
            .collection('request_sick')
            .where('approveStatus', isEqualTo: "waiting")
            .snapshots(),
        FirebaseFirestore.instance
            .collection('request_wfh')
            .where('approveStatus', isEqualTo: "waiting")
            .snapshots(),
      ]);
    } else {
      // Other user: Listen to all collections without checking userID
      print("userRole in other :" + userRole.toString());
      userStream = Rx.merge([
        FirebaseFirestore.instance.collection('request_annual').snapshots(),
        FirebaseFirestore.instance.collection('request_business').snapshots(),
        FirebaseFirestore.instance.collection('request_sick').snapshots(),
        FirebaseFirestore.instance.collection('request_wfh').snapshots(),
      ]);
    }

    // Merge all streams into a single stream using RxDart's merge operator
    return userStream;
  }

  @override
  Widget build(BuildContext context) {
    _updateButtonStates();
    bool shouldShowNotification = false; // Initialize this variable

    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.transparent, // Make the container transparent
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    SizedBox(
                      height: 320,
                      width: double.infinity,
                      child: PageView.builder(
                        itemCount: backgrounds.length,
                        controller: PageController(initialPage: currentIndex),
                        onPageChanged: (index) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(backgrounds[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingPage(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20, right: 16),
                        child: Icon(
                          Icons.settings,
                          color:
                          (currentIndex == 2) ? Colors.white : Colors.black,
                          size: 32,
                        ),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: _combinedStreams(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasData &&
                            snapshot.data!.docs.isNotEmpty) {
                          String userRole = currentUser?['role'] ?? "staff";

                          final addedItems = snapshot.data!.docChanges.where(
                                  (change) =>
                              change.type == DocumentChangeType.added);
                          int addedItemCount = addedItems.length;

                          final modifiedItems = snapshot.data!.docChanges.where(
                                  (change) =>
                              change.type == DocumentChangeType.modified);
                          int modifiedItemCount = modifiedItems.length;

                          print("home modifiedItemCount : " +
                              modifiedItemCount.toString());
                          print("home addedItemCount : " +
                              addedItemCount.toString());

                          if (addedItemCount > 0 &&
                              (userRole == "manager" ||
                                  userRole == "เมเนเจอร์")) {
                            _prefs?.setBool('checkNotification', false);
                            print("set checkNotification false");
                          } else if (modifiedItemCount > 0) {
                            _prefs?.setBool('checkNotification', false);
                            print("set checkNotification false");
                          }
                        } else {
                          print(
                              "NOT snapshot.hasData && snapshot.data!.docs.isNotEmpty");
                        }

                        bool? checkNotification =
                        _prefs?.getBool('checkNotification');

                        // Check if the flag is true and return the notification accordingly
                        if (checkNotification != null) {
                          if (checkNotification == false) {
                            //red
                            _lottieController.reset();
                            _lottieController.forward();
                            print("home show red " +
                                _prefs!
                                    .getBool('checkNotification')
                                    .toString());
                            if(currentUser['role'] == 'manager' || currentUser['role'] == 'เมเนเจอร์') {
                              int addedItems = (snapshot.data?.docs.length) ??0;
                              if (addedItems > 0) {
                                addedItems++;
                              }
                            }
                            return GestureDetector(
                              onTap: () {
                                // Navigate to ApprovalPageMobile when the animation is tapped
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ApprovalPageMobile(),
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16, right: 60),
                                    child: badges.Badge(
                                      badgeContent: Text(addedItems.toString()),
                                      child: Lottie.asset(
                                        'assets/animation/notification2.json',
                                        controller: _lottieController,
                                        width: 40,
                                        height: 40,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 16,
                                    right: 56,
                                    child: badges.Badge(
                                      position:
                                      BadgePosition.topEnd(top: 0, end: 0),
                                      //badgeContent: Text('5', style: TextStyle(color: Colors.white)),
                                      showBadge:
                                      shouldShowNotification, // Set the flag here
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            print("home not red " +
                                _prefs!
                                    .getBool('checkNotification')
                                    .toString());
                            _lottieController.stop();
                            _lottieController.reset();
                            return GestureDetector(
                              //not red
                              onTap: () {
                                // Navigate to ApprovalPageMobile when the animation is tapped
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ApprovalPageMobile(),
                                  ),
                                );
                              },
                              child: Padding(
                                padding:
                                const EdgeInsets.only(top: 15, right: 60),
                                child: Lottie.asset(
                                  'assets/animation/notification2.json',
                                  controller: _lottieController,
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                            );
                          }
                        } else {
                          print("home not red " +
                              _prefs!.getBool('checkNotification').toString());
                          _lottieController.stop();
                          _lottieController.reset();
                          return GestureDetector(
                            //not red
                            onTap: () {
                              // Navigate to ApprovalPageMobile when the animation is tapped
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ApprovalPageMobile(),
                                ),
                              );
                            },
                            child: Padding(
                              padding:
                              const EdgeInsets.only(top: 15, right: 60),
                              child: Lottie.asset(
                                'assets/animation/notification2.json',
                                controller: _lottieController,
                                width: 40,
                                height: 40,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    Positioned(
                      top: 20,
                      left: 16,
                      child: Text(
                        getHelloText(),
                        style: TextStyle(
                          fontSize: 20,
                          color:
                          (currentIndex == 2) ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  greetings[randomGreetingIndex],
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  getCurrentTime(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8C8C8C),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (currentIndex == 0)
                      isCheckInEnabled
                          ? LongButton(
                        ontap: () {
                          _checkIn('morningCheckIn');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => checkin_page(),
                            ),
                          );
                        },
                        title: 'Morning Check-in',
                      )
                          : const LongButtonDisable(
                        title: 'Morning Check-in',
                        textColor: Colors.white,
                        disabledColor: Color(0xFFD8D8D8),
                      ),
                    if (currentIndex == 1)
                      isCheckInEnabled
                          ? LongButton(
                        ontap: () {
                          _checkIn('afternoonCheckIn');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => checkin_page(),
                            ),
                          );
                        },
                        title: 'Afternoon Check-in',
                      )
                          : const LongButtonDisable(
                        title: 'Afternoon Check-in',
                        textColor: Colors.white,
                        disabledColor: Color(0xFFD8D8D8),
                      ),
                    if (currentIndex == 2)
                      isCheckInEnabled
                          ? LongButton(
                        ontap: () {
                          _checkIn('eveningCheckIn');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => checkin_page(),
                            ),
                          );
                        },
                        title: 'Evening Check-in',
                      )
                          : const LongButtonDisable(
                        title: 'Evening Check-in',
                        textColor: Colors.white,
                        disabledColor: Color(0xFFD8D8D8),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, top: 24, bottom: 16),
                    child: Text(
                      'Todo List',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (currentUser['role'] == 'manager' ||
                    currentUser['role'] == 'เมเนเจอร์') ...[
                  if (currentUser['userID'] != null)
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 500,
                        child: TodoCardManager.buildTaskListStream(
                            currentUser['userID'], false),
                      ),
                    ),
                ] else ...[
                  if (currentUser['userID'] != null)
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 500,
                        child: TodoCard.buildTaskListStream(
                            currentUser['userID'], false),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
