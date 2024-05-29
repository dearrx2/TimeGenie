import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/responsive/app/main/main_page_web.dart';

import '../../responsive_layout.dart';
import 'main_page_mobile.dart';

class HomeScreenPage extends StatefulWidget {
  final String uid;
  const HomeScreenPage({Key? key, required this.uid}) : super(key: key);

  @override
  _HomeScreenPageState createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody:
            HomeScreenMobile(uid: FirebaseAuth.instance.currentUser!.uid),
        desktopBody: HomeScreenWeb(uid: FirebaseAuth.instance.currentUser!.uid),
      ),
    );
  }
}
