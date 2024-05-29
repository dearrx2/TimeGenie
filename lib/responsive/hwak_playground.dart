import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/utils/color_utils.dart';
import 'dart:async'; // Import the dart:async library for Timer

class Hwak extends StatefulWidget {
  const Hwak({Key? key}) : super(key: key);

  @override
  State<Hwak> createState() => _NotiPageMobileState();
}

class _NotiPageMobileState extends State<Hwak> {
  DateTime currentTime = DateTime.now();

  // Set up a Timer that updates the time every second
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      _timeCounter();
    });
  }

  void _timeCounter() {
    setState(() {
      currentTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat.Hm().format(currentTime);
    // String formattedTime = DateFormat('HH:mm:ss').format(currentTime);
    return Container(
      color: white,
      child: Column(
        children: [
          Text("$formattedTime"),
        ],
      ),
    );
  }
}
