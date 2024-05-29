import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/responsive/app/main/main_page.dart';
import 'package:untitled/responsive/app/profile/profile_screen_mobile.dart';
import 'package:untitled/utils/color_utils.dart';
import '../../../components/loading_animation.dart';
import '../../../responsive/signin/signin_screen.dart';
import '../../../utils/localizations.dart';
import '../../../utils/snackbar.dart';
import '../../../utils/style.dart';
import '../resetpassword/forgotpassword_screen_mobile.dart';

class SettingMobile extends StatefulWidget {
  const SettingMobile({Key? key}) : super(key: key);

  @override
  State<SettingMobile> createState() => _SettingMobileScreenState();
}

class _SettingMobileScreenState extends State<SettingMobile> {
  var currentUser = {};
  bool isLoading = false;
  bool light = false;
  bool thai = false;
  bool isVisibleProfile = false;
  bool isVisibleResetPassword = false;
  final String profile = 'assets/svg/setting/profile.svg';
  final String resetPassword = 'assets/svg/setting/reset_password.svg';
  final String language = 'assets/svg/setting/language.svg';
  final String emptyProfie = 'assets/svg/signup/signup.svg';
  late Color select;
  late Color notSelect;
  late bool check;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
    getData();
  }

  void _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _checkLanguage();
  }

  void _changeLanguage(String language) async {
    var language = check ? "en" : "th";
    _prefs.setString("language", language);
    MyLocalizations.load(_prefs.getString('language') ?? "th");
  }

  void _checkLanguage() async {
    if ((_prefs.getString('language') ?? "th") == "en") {
      setState(() {
        select = const Color(0xff000000);
        notSelect = const Color(0xffF88939);
        check = true;
      });
    } else {
      setState(() {
        select = const Color(0xffF88939);
        notSelect = const Color(0xff000000);
        check = false;
      });
    }
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var currentSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      currentUser = currentSnap.data()!;
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  void toggleVisibility() {
    setState(() {
      isVisibleProfile = !isVisibleProfile;
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  void _logout() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()),
    );
    SharedPreferences.getInstance().then((prefs) {
      setState(() async {
        prefs.remove('email');
        prefs.remove('password');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: LoadingAnimation(),
          )
        : Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              title: Text(MyLocalizations.translate("appbar_Setting"),
                  style: header),
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: GestureDetector(
                  child: const Icon(Icons.arrow_back_ios, color: Colors.black),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreenPage(
                                uid: FirebaseAuth.instance.currentUser!.uid)));
                  }),
            ),
            body: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [backgroundLow, backgroundHigh],
                  )),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, bottom: 8, right: 16.0, top: 48),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfileScreenMobile()));
                          },
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.96,
                            height: MediaQuery.of(context).size.height * 0.104,
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: ClipOval(
                                      child: currentUser['image'] == ""
                                          ? MediaQuery.of(context).size.width >
                                                  360
                                              ? SvgPicture.asset(
                                                  emptyProfie,
                                                  width: 67,
                                                  height: 67,
                                                )
                                              : SvgPicture.asset(
                                                  emptyProfie,
                                                  width: 56,
                                                  height: 56,
                                                )
                                          : MediaQuery.of(context).size.width >
                                                  360
                                              ? Image.network(
                                                  currentUser['image'],
                                                  width: 67,
                                                  height: 67,
                                                  fit: BoxFit.fitWidth,
                                                )
                                              : Image.network(
                                                  currentUser['image'],
                                                  width: 56,
                                                  height: 56,
                                                  fit: BoxFit.fitWidth,
                                                ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        currentUser['name'].split(" ")[0],
                                        style: headerCard,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            MyLocalizations.translate(
                                                "text_SettingEdit"),
                                          ),
                                          const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: black,
                                            size: 16,
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.96,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          MyLocalizations.translate("appbar_Setting"),
                          style: headerCard,
                        ),
                        Container(
                          color: setting,
                          width: MediaQuery.of(context).size.width * 0.96,
                          height: MediaQuery.of(context).size.height * 0.23,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 16),
                                    child: SvgPicture.asset(
                                      resetPassword,
                                      width: 40,
                                      height: 40,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          MyLocalizations.translate(
                                              "button_ResetPassword"),
                                          style: headerCard,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ForgotPasswordScreenMobile()));
                                            },
                                            child: const Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: black,
                                              size: 24,
                                            )),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 16),
                                    child: SvgPicture.asset(
                                      language,
                                      width: 40,
                                      height: 40,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          MyLocalizations.translate(
                                              "text_Language"),
                                          style: headerCard,
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              select = const Color(0xFFF88939);
                                              notSelect =
                                                  const Color(0xff000000);
                                              check = false;
                                              _changeLanguage('th');
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const SettingMobile()));
                                            });
                                          },
                                          child: Text(
                                            "TH",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                color: select),
                                          ),
                                        ),
                                        const Text("|"),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              select = const Color(0xff000000);
                                              notSelect =
                                                  const Color(0xffF88939);
                                              check = true;
                                              _changeLanguage('en');
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const SettingMobile()));
                                            });
                                          },
                                          child: Text("EN",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  color: notSelect)),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(width: 1, color: black),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    width: MediaQuery.of(context).size.width * 0.96,
                    height: 54,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: white),
                        onPressed: _logout,
                        child: Text(
                          MyLocalizations.translate('text_SignOut'),
                          style: const TextStyle(
                              color: textButton,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        )),
                  ),
                )
              ],
            ),
          );
  }
}
