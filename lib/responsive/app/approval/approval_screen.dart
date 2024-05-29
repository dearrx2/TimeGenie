import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../responsive_layout.dart';
import 'approval_screen_mobile.dart';
import 'approval_screen_web.dart';

class ApprovalPage extends StatefulWidget {
  const ApprovalPage({Key? key}) : super(key: key);

  @override
  _ApprovalPageState createState() => _ApprovalPageState();
}

class _ApprovalPageState extends State<ApprovalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: const ApprovalPageMobile(),
        desktopBody: const ApprovalPageWeb(),
      ),
    );
  }
}