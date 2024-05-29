import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../responsive/app/home/home_screen.dart';

class AppBar2 extends StatefulWidget {
  const AppBar2({Key? key}) : super(key: key);

  @override
  State<AppBar2> createState() => _AppBar2ScreenState();
}

class _AppBar2ScreenState extends State<AppBar2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              child: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onTap: () {
                Navigator.pop(context);
              }),
          title: const Text("Right icon"),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                if (kDebugMode) {
                  print("Right icon tapped!");
                }
              },
            ),
          ],
        ),
        body: Center(
            child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                },
                child: const Text("next"))));
  }
}
