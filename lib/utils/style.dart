import 'package:flutter/material.dart';
import 'package:untitled/utils/color_utils.dart';

// Thin: FontWeight.w100 (100)
// Extra Light: FontWeight.w200 (200)
// Light: FontWeight.w300 (300)
// Regular: FontWeight.w400 (400)
// Medium: FontWeight.w500 (500)
// Semi Bold: FontWeight.w600 (600)
// Bold: FontWeight.w700 (700)
// Extra Bold: FontWeight.w800 (800)
// Black: FontWeight.w900 (900)

// app bar zone
const TextStyle appBar = TextStyle(
  color: black,
  fontSize: 20,
  fontWeight: FontWeight.bold,
);
// header zone
const TextStyle header = TextStyle(
  color: black,
  fontSize: 24,
  fontWeight: FontWeight.bold,
);

const TextStyle headerCard = TextStyle(
  color: black,
  fontSize: 20,
  fontWeight: FontWeight.bold,
);
const TextStyle headerCard2 = TextStyle(
  color: black,
  fontSize: 18,
  fontWeight: FontWeight.bold,
);
// normal text zone
const TextStyle text =
    TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.w500);

const TextStyle textGery = TextStyle(
    color: textGrey,
    fontSize: 14,
    fontWeight: FontWeight.w400);

const TextStyle textHint = TextStyle(
    color: hint,
    fontSize: 10,
    fontWeight: FontWeight.w400);

const TextStyle success = TextStyle(
    color: successTextColor, fontSize: 24, fontWeight: FontWeight.bold);

const TextStyle blueText = TextStyle(
  color: blue,
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

// const TextStyle header = TextStyle(
//     color: black,
//     fontSize: 20,
//     fontWeight: FontWeight.w600,
//     );

const TextStyle headerTextFormField = TextStyle(
  color: black,
  fontSize: 14,
  fontWeight: FontWeight.w400,
);

const TextStyle hintTextFormField = TextStyle(
  color: grey,
  fontSize: 14,
  fontWeight: FontWeight.w400,
);

const TextStyle normalText = TextStyle(
  color: black,
  fontSize: 16,
  fontWeight: FontWeight.w200,
);

const TextStyle orangeItalic = TextStyle(
  color: orange,
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

const TextStyle redBold = TextStyle(
  color: red,
  fontSize: 16,
  fontWeight: FontWeight.bold,
);

const TextStyle redText = TextStyle(
  color: red,
  fontSize: 16,
  fontFamily: 'Prompt',
);

const TextStyle subscript = TextStyle(
  color: grey,
  fontSize: 12,
  fontWeight: FontWeight.w400,
);

const TextStyle textInButton = TextStyle(
  color: white,
  fontSize: 16,
  fontWeight: FontWeight.w400,
);

const TextStyle orangeItalic2 = TextStyle(
  color: orange,
  fontSize: 12,
  fontWeight: FontWeight.w600,
);

const TextStyle tabBarText = TextStyle(
  ///Tab bar
  fontSize: 18,
  fontWeight: FontWeight.bold,
  fontFamily: 'Prompt',
);

const TextStyle titleText = TextStyle(
  ///title in TodoCard
  color: black,
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

const TextStyle noteText = TextStyle(
  ///note in TodoCard
  color: black,
  fontSize: 14,
  fontWeight: FontWeight.w400,
);

const TextStyle dueDateText = TextStyle(
  ///dueDate in TodoCard
  fontStyle: FontStyle.italic,
  fontWeight: FontWeight.bold,
  fontSize: 10,
);

const TextStyle iconText = TextStyle(
  ///Requests
  color: primaryTextColor,
  fontSize: 14,
  fontWeight: FontWeight.w400,
);

const TextStyle calendarMon = TextStyle(
  color: calendarMonth,
  fontSize: 18,
  fontWeight: FontWeight.bold,
);
const TextStyle calendarDayOfWeek = TextStyle(
  color: calendarDayOfMonth,
  fontSize: 14,
  fontWeight: FontWeight.w600,
);
const TextStyle calendarDayOfWeekRed = TextStyle(
  color: calendarDayOfMonthRed,
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

const TextStyle calendarDayOfDay = TextStyle(
  color: calendarDay,
  fontSize: 16,
  fontWeight: FontWeight.w300,
);

const TextStyle calendarWfh = TextStyle(
  color: wfhTextColor,
  fontSize: 8,
  fontWeight: FontWeight.bold,
);

const TextStyle calendarLeave = TextStyle(
  color: leaveTextColor,
  fontSize: 8,
  fontWeight: FontWeight.bold,
);
