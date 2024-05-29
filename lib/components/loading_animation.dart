//animation loading
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/animation/animation_loading.json',
        width: 200,
        height: 200,
      ),
    );
  }
}