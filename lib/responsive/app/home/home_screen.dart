import 'package:flutter/material.dart';
import 'package:untitled/responsive/app/home/home_screen_mobile.dart';

import '../../responsive_layout.dart';
import 'home_screen_web.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody:  const HomePageMobile(),
        desktopBody: const HomePageWeb(),
      ),
    );
  }
}
