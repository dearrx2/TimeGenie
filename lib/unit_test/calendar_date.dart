import 'package:intl/intl.dart';

import '../components/calendar/custom_calendar/model.dart';

class Date {
  final DateTime _currentDay;
  final int _currentMonth;
  final int _currentYear;

  Date()
      : _currentDay = DateTime.now(),
        _currentMonth = DateTime.now().month,
        _currentYear = DateTime.now().year;

  DateTime get today => _currentDay;
  int get thisMonth => _currentMonth;
  int get thisYear => _currentYear;

  int getActualMaximumWeekOfMonth(DateTime date) {
    int totalDaysInMonth =
        DateTime(date.year, date.month + 1, 0).day; // output 31
    int firstWeekdayOfMonth =
        DateTime(date.year, date.month, 1).weekday; // output 2 + วันอังคาร
    int remainingDays = totalDaysInMonth - (8 - firstWeekdayOfMonth);
    int actualMaximumWeek = 1 + (remainingDays / 7).ceil(); // .ceil() ปัดขึ้น.5
    return actualMaximumWeek; // ได้ 5 สัปดา
  }

  List<DateModel> getWeekDates(DateTime date) {
    int dayOfWeek = date.weekday; // output 1
    DateTime startOfWeek = date.subtract(Duration(days: dayOfWeek - 1));

    List<DateTime> weekDates = [];

    List<DateModel> weekDates2 = [];

    for (var i = 0; i < DateTime.daysPerWeek; i++) {
      weekDates.add(startOfWeek.add(Duration(days: i)));

      var dateTime = startOfWeek.add(Duration(days: i));
      var isCurrentMonth = false;
      var isCurrentDate = false;
      var isCurrentWeekend = false;
      var today = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
      if (dateTime.month == date.month && dateTime.year == date.year) {
        isCurrentMonth = true;
      }
      if (DateFormat("d/M/y").format(DateTime.now()) == today) {
        isCurrentDate = true;
      }
      if (dateTime.weekday == DateTime.saturday ||
          dateTime.weekday == DateTime.sunday) {
        isCurrentWeekend = true;
      }

      var dateModel = DateModel(
        dateString: "${dateTime.day}/${dateTime.month}/${dateTime.year}",
        date: dateTime,
        isCurrentMonth: isCurrentMonth,
        isCurrentDate: isCurrentDate,
        isCurrentWeekend: isCurrentWeekend,
        listEvents: [],
      );
      weekDates2.add(dateModel);
    }
    return weekDates2;
  }

  List<DateModel> getAllDateInCalendar(int year, int month) {
    var listDateInCalendar = <DateModel>[];
    var date = DateTime(year, month, 1);
    var maxWeekInCalendar = getActualMaximumWeekOfMonth(date);
    for (int i = 0; i < maxWeekInCalendar; i++) {
      listDateInCalendar.addAll(getWeekDates(date));
      date = date.add(const Duration(days: 7));
    }
    return listDateInCalendar;
  }
}
