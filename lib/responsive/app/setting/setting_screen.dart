import 'package:flutter/material.dart';
import 'package:untitled/responsive/app/setting/setting_screen_mobile.dart';
import 'package:untitled/responsive/app/setting/setting_screen_web.dart';
import '../../responsive_layout.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: const SettingMobile(),
        desktopBody: const SettingWeb(),
      ),
    );
  }
}
