import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/provider/theme_provider.dart';
import 'package:untitled/responsive/splashscreen/app/splash_screen.dart';
import 'package:untitled/services/notification_service.dart';
import 'package:untitled/utils/localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var prefs = await SharedPreferences.getInstance();
  await NotificationService.initializeNotification();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  String selectedLanguage = prefs.getString('language') ?? "th";
  Intl.defaultLocale = selectedLanguage;
  await initializeDateFormatting();
  await MyLocalizations.load(selectedLanguage);
  runApp(MyApp(selectedLanguage: selectedLanguage));
}

class MyApp extends StatelessWidget {
  static const String title = 'Light & Dark Theme';
  final String? selectedLanguage;

  const MyApp({Key? key, required this.selectedLanguage}) : super(key: key);

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    builder: (context, _) {
      final themeProvider = Provider.of<ThemeProvider>(context);

      return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('th'),
          Locale('en'),
        ],
        locale: Locale(selectedLanguage ?? "th"),
        navigatorKey: navigatorKey,
        title: title,
        themeMode: themeProvider.themeMode,
        debugShowCheckedModeBanner: false,
        theme: MyThemes.lightTheme,
        home: const AppSplashPage(),
      );
    },
  );
}