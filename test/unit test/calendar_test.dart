import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/unit_test/calendar_date.dart';
// this is setup all
// do
// test

void main() {
  late Date date;

  setUp(() {
    date = Date();
  });

// Testing
  group('calendar build ', () {
    test(
      'given Date class and check month of current day (21/9/2023)',
      () {
        // Act
        final val = date.thisMonth;
        // Assert
        expect(val, 9);
      },
    );

    test(
      'given Date class and check month of current day (21/9/2023)',
      () {
        // Act
        final val = date.thisYear;
        // Assert
        expect(val, 2023);
      },
    );

    test(
      'given Date class and check this month have amount week (21/9/2023)',
      () {
        // Act
        final month = DateTime(date.thisYear, date.thisMonth, 1);
        final val = date.getActualMaximumWeekOfMonth(month);
        // Assert
        expect(val, 5);
      },
    );

    test(
      'given Date class and check day in week (21/9/2023)',
      () {
        // Act
        final month = DateTime(date.thisYear, date.thisMonth, 1);
        final weekDates = date.getWeekDates(month);
        // Assert
        expect(weekDates.map((dateModel) => dateModel.dateString).toList(), [
          "28/8/2023",
          "29/8/2023",
          "30/8/2023",
          "31/8/2023",
          "1/9/2023",
          "2/9/2023",
          "3/9/2023"
        ]);
      },
    );
  });
}
