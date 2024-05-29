import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import the flutter_svg package
import 'package:intl/intl.dart'; // Import the intl package
import 'dart:math';

import '../../../components/long_button.dart';
import '../../../utils/style.dart';
import '../main/main_page_mobile.dart';

class SuccessPage extends StatelessWidget {
  final DateTime checkInTime;
  final List<String> successPictures = [
    'assets/images/success_pictures/undraw_1.svg',
    'assets/images/success_pictures/undraw_2.svg',
    'assets/images/success_pictures/undraw_3.svg',
    'assets/images/success_pictures/undraw_4.svg',
    'assets/images/success_pictures/undraw_5.svg',
    'assets/images/success_pictures/undraw_6.svg',
    'assets/images/success_pictures/undraw_7.svg',
    'assets/images/success_pictures/undraw_8.svg',
    'assets/images/success_pictures/undraw_10.svg',
    'assets/images/success_pictures/undraw_11.svg',
    'assets/images/success_pictures/undraw_12.svg',
  ];

  SuccessPage({required this.checkInTime, required imageUrl});

  @override
  Widget build(BuildContext context) {
    // Generate a random index to pick a picture from the list
    final Random random = Random();
    final int randomIndex = random.nextInt(successPictures.length);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              successPictures[randomIndex],
              width: 150, // Adjust the width to your preference
              height: 150, // Adjust the height to your preference
            ),
            SizedBox(height: 16),
            const Text(
              'Successful !',
              style: success,
            ),
            const SizedBox(height: 8),
            const Text(
              'Check-In Time:',
              style: headerTextFormField,
            ),
            Text(
              DateFormat('yyyy-MM-dd HH:mm:ss').format(checkInTime.toLocal()),
              style: normalText,
            ),
            SizedBox(height: 20), // Adjust the spacing as needed
            LongButton( // Replace LongButton with your custom button component name
              ontap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreenMobile(uid: '',), // Replace HomePageMobile with the appropriate page.
                  ),
                );
              },
              title: "Let's go work :)",
            ),
          ],
        ),
      ),
    );
  }
}
