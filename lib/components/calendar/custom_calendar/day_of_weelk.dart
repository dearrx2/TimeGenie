import 'package:flutter/material.dart';
import 'package:untitled/utils/localizations.dart';

import '../../../utils/style.dart';

class DayOfWeek extends StatelessWidget {
  const DayOfWeek({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 25,
        child: GridView.count(
          crossAxisCount: 7,
          children: [
            Text(
              MyLocalizations.translate("text_Monday"),
              style: calendarDayOfWeek,
              textAlign: TextAlign.center,
            ),
            Text(
              MyLocalizations.translate("text_Tuesday"),
              style: calendarDayOfWeek,
              textAlign: TextAlign.center,
            ),
            Text(
              MyLocalizations.translate("text_Wednesday"),
              style: calendarDayOfWeek,
              textAlign: TextAlign.center,
            ),
            Text(
              MyLocalizations.translate("text_Thursday"),
              style: calendarDayOfWeek,
              textAlign: TextAlign.center,
            ),
            Text(
              MyLocalizations.translate("text_Friday"),
              style: calendarDayOfWeek,
              textAlign: TextAlign.center,
            ),
            Text(
              MyLocalizations.translate("text_Saturday"),
              style: calendarDayOfWeekRed,
              textAlign: TextAlign.center,
            ),
            Text(
              MyLocalizations.translate("text_Sunday"),
              style: calendarDayOfWeekRed,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
