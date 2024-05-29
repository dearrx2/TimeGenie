import 'package:flutter/material.dart';
import 'package:untitled/components/appbar/appbar_right_icon.dart';
import 'package:untitled/utils/color_utils.dart';

class AppBar1 extends StatefulWidget {
  const AppBar1({Key? key}) : super(key: key);

  @override
  State<AppBar1> createState() => _AppBar1ScreenState();
}

class _AppBar1ScreenState extends State<AppBar1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Transparent",
            style: TextStyle(color: black, fontWeight: FontWeight.bold),
          ),
          leading: GestureDetector(
              child: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onTap: () {
                Navigator.pop(context);
              }),
        ),
        body: Center(
            child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AppBar2()),
                  );
                },
                child: Text("next"))));
  }
}
