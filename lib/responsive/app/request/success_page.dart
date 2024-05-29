import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:untitled/utils/color_utils.dart';
import '../../../components/long_button.dart';
import '../../../utils/style.dart';

class SuccessPage extends StatelessWidget {
  final String icon;
  final String requestType; // New parameter for request type
  final List<DateTime> selectedDates; // Change to a list of DateTime

  SuccessPage({
    required this.icon,
    required this.requestType,
    required this.selectedDates,
  });

  @override
  Widget build(BuildContext context) {

    final selectedDatesString = selectedDates.map((date) {
      return DateFormat('dd/MM/yyyy').format(date);
    }).toList();

    final List<Widget> dateWidgets = [];
    for (int i = 0; i < selectedDatesString.length; i += 2) {
      final dateLine = selectedDatesString.skip(i).take(2).join(', ');
      dateWidgets.add(Text('$dateLine${i + 2 < selectedDatesString.length ? ',' : ''}', style: normalText));
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animation/animation_rocket_sent.json',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 16),
            const Text(
              'Successful !',
              style: success,
            ),
            const SizedBox(height: 8),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Type: ',
                    style: headerTextFormField,
                  ),
                  Image.asset(
                    icon,
                    width: 24,
                    height: 24,
                  ),
                  Text(
                    requestType,
                    style: normalText.copyWith(
                      color: _getTextColor(requestType), // Call a function to get the appropriate color
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Selected Dates:', // Updated label
              style: TextStyle(

              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: dateWidgets,
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
            LongButton(
              ontap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              title: "Let's go work :)",
            ),
          ],
        ),
      ),
    );
  }
}

Color _getTextColor(String requestType) {
  switch (requestType) {
    case 'Annual Leave':
      return annualIcon;
    case 'Work From Home':
      return wfhIcon;
    case 'Sick Leave':
      return sickIcon;
    case 'Business Leave':
      return businessIcon;
    default:
      return Colors.black; // Default color if requestType doesn't match any case
  }
}

class SuccessPageRange extends StatelessWidget {
  final String icon;
  final String requestType;
  final DateTime startDate; // Change to DateTime for start date
  final DateTime endDate; // Change to DateTime for end date

  SuccessPageRange({
    required this.icon,
    required this.requestType,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the difference between start and end dates
    final daysDuration = endDate.difference(startDate).inDays + 1;
    final formattedDateRange =
        DateFormat('dd/MM/yyyy').format(startDate) + ' - ' + DateFormat('dd/MM/yyyy').format(endDate);

    // Determine whether to use "day" or "days" based on the duration
    final dayText = daysDuration == 1 ? 'day' : 'days';

    // Create a TextSpan with different styles for the day count and "day/days" text
    final textSpan = TextSpan(
      children: [
        TextSpan(
          text: '$daysDuration',
          style: redText,
        ),
        TextSpan(
          text: ' $dayText', // Display "day" or "days"
          style: redText,
        ),
      ],
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animation/animation_rocket_sent.json',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 16),
            const Text(
              'Successful !',
              style: success,
            ),
            const SizedBox(height: 8),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Type: ',
                    style: headerTextFormField,
                  ),
                  Image.asset(
                    icon,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    requestType,
                    style: normalText.copyWith(
                      color: _getTextColor(requestType),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                  'Date: ',
                  style: headerTextFormField,
                ),
                  Text(
                    formattedDateRange,
                    style: normalText,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '(',
                    style: redText,
                  ),
                  RichText(
                    text: textSpan,
                  ),
                  const Text(
                    ')',
                    style: redText,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            LongButton(
              ontap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              title: "Let's go work :)",
            ),
          ],
        ),
      ),
    );
  }
}
