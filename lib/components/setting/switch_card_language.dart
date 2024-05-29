import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/responsive/app/setting/setting_screen.dart';
import '../../utils/color_utils.dart';
import '../../utils/localizations.dart';

class ToggleCardLanguage extends StatefulWidget {
  final String icon;
  final String text;
  const ToggleCardLanguage({Key? key, required this.icon, required this.text})
      : super(key: key);

  @override
  State<ToggleCardLanguage> createState() => _ToggleCardLanguageState();
}

class _ToggleCardLanguageState extends State<ToggleCardLanguage> {
  late bool check = false;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  void _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _checkLanguage();
  }

  void _changeLanguage() {
    var language = check ? "en" : "th";
    _prefs.setString("language", language);
    MyLocalizations.load(_prefs.getString('language') ?? "th");
  }

  void _checkLanguage() {
    if ((_prefs.getString('language') ?? "th") == "en") {
      setState(() {
        check = true;
      });
    } else {
      setState(() {
        check = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
      child: Container(
        height: 88,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: veryGrey,
              blurRadius: 2.0,
              spreadRadius: 2.0,
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              SvgPicture.asset(
                widget.icon,
                width: 32,
                height: 32,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: SizedBox(
                  width: 260,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.text,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Switch(
                        value: check,
                        onChanged: (bool value) {
                          setState(() {
                            check = value;
                            _changeLanguage();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SettingPage()));
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
