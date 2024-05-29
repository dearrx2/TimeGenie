import 'package:flutter/material.dart';
import 'package:untitled/responsive/app/profile/profile_screen_mobile.dart';
import 'package:untitled/responsive/app/profile/profile_screen_web.dart';
import '../../responsive_layout.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: const ProfileScreenMobile(),
        desktopBody: const ProfileScreenWeb(),
      ),
    );
  }
}
