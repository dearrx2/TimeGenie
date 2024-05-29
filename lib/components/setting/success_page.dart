import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../components/long_button.dart';
import '../../../utils/style.dart';

class SuccessPageSetting extends StatelessWidget {
  const SuccessPageSetting({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 20),
            LongButton(
              ontap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              title: "Your profile got change :)",
            ),
          ],
        ),
      ),
    );
  }
}
