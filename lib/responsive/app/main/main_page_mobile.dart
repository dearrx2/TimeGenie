import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../utils/localizations.dart';
import '../../../utils/snackbar.dart';
import '../calendar/calendar_screen.dart';
import '../home/home_screen.dart';
import '../todo/todo_screen.dart';

class HomeScreenMobile extends StatefulWidget {
  // final User user;
  final String uid;

  const HomeScreenMobile({Key? key, required this.uid}) : super(key: key);

  @override
  State<HomeScreenMobile> createState() => _HomeScreenMobileState();
}

class _HomeScreenMobileState extends State<HomeScreenMobile> {
  var currentUser = {};
  DateTime currentTime = DateTime.now();
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

  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const TodoPage(),
    const CalendarPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: MyLocalizations.translate("button_Home"),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.list_alt_outlined),
              label: MyLocalizations.translate("button_Todo"),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_month_outlined),
              label: MyLocalizations.translate("button_Calendar"),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
    );
  }
}
