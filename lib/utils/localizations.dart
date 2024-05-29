import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class MyLocalizations {
  static Map<String, dynamic> _localizedStrings = {};

  static Future<void> load(String locale) async {
    String jsonString =
        await rootBundle.loadString('assets/language/$locale.json');
    _localizedStrings = json.decode(jsonString);
  }

  static String translate(String key) {
    return _localizedStrings[key] ?? '[$key]';
  }

  static String formatDate(DateTime date) {
    return DateFormat.MMMM().format(date);
  }

  static String formatDateDay(DateTime date) {
    return DateFormat('d MMMM y').format(date);
  }
}
