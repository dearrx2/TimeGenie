import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../provider/theme_provider.dart';
import '../../utils/color_utils.dart';
import '../../utils/localizations.dart';

class ToggleCardDarkMode extends StatefulWidget {
  final String icon;
  final String text;
  final bool checker;
  const ToggleCardDarkMode(
      {Key? key, required this.icon, required this.text, required this.checker})
      : super(key: key);

  @override
  State<ToggleCardDarkMode> createState() => _ToggleCardDarkState();
}

class _ToggleCardDarkState extends State<ToggleCardDarkMode> {
  late bool check;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    check = widget.checker;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
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
                        value: themeProvider.isDarkMode,
                        onChanged: (value) {
                          setState(() {
                            final provider = Provider.of<ThemeProvider>(context,
                                listen: false);
                            provider.toggleTheme(value);
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
