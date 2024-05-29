import 'package:flutter/material.dart';
import 'package:untitled/responsive/app/calendar/calendar_screen_mobile.dart';
import '../../responsive_layout.dart';
import 'calendar_screen_web.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: const CalendarPageMobile(),
        desktopBody: const CalendarPageWeb(),
      ),
    );
  }
}

// class _CalendarPageState extends State<CalendarPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ResponsiveLayout(
//         mobileBody: const CalendarPageMobile(),
//         desktopBody: const CalendarPageWeb(),
//       ),
//     );
//   }
// }
