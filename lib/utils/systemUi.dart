import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SystemUiMode> getSystemUiMode() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? modeValue = prefs.getInt('systemUiMode');
  return modeValue != null
      ? SystemUiMode.values[modeValue]
      : SystemUiMode.immersive;
}

Future<void> setSystemUiMode(SystemUiMode mode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('systemUiMode', mode.index);
}
