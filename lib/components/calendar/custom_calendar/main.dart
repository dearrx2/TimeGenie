import 'package:flutter/material.dart';
import 'package:untitled/components/calendar/custom_calendar/day.dart';
import '../../../responsive/app/calendar/leave_set/leave_model.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/localizations.dart';
import '../../../utils/style.dart';
import 'day_of_weelk.dart';

class CalendarCustom extends StatefulWidget {
  final List<LeaveModel>? listLeaves;
  const CalendarCustom({Key? key, required this.listLeaves}) : super(key: key);

  @override
  State<CalendarCustom> createState() => _CalendarCustomState();
}

class _CalendarCustomState extends State<CalendarCustom> {
  var currentDate = DateTime.now();
  var currentYear = DateTime.now().year;

  String getMonthName(DateTime dateTime) {
    return MyLocalizations.formatDate(dateTime);
  }

  void _goToPreviousMonth() {
    setState(() {
      currentDate =
          DateTime(currentDate.year, currentDate.month - 1, currentDate.day);
    });
  }

  void _goToNextMonth() {
    setState(() {
      currentDate =
          DateTime(currentDate.year, currentDate.month + 1, currentDate.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _goToPreviousMonth,
                icon: const Icon(Icons.arrow_back_ios_new_outlined),
                color: black,
              ),
              currentDate.year != currentYear
                  ? Text(
                      "${getMonthName(currentDate)} ${currentDate.year}",
                      style: calendarMon,
                    )
                  : Text(
                      getMonthName(currentDate),
                      style: calendarMon,
                    ),
              IconButton(
                onPressed: _goToNextMonth,
                icon: const Icon(Icons.arrow_forward_ios_outlined),
                color: black,
              )
            ],
          ),
          const DayOfWeek(),
          // Expanded(
          //     child: DayCalendar(
          //   day: currentDate,
          // ))
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.38,
              child: DayCalendar2(
                day: currentDate,
                listLeaves: widget.listLeaves,
              ))
        ],
      ),
    ));
  }
}
