import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'generated/l10n.dart';
import 'route_generator.dart';
import 'src/helpers/app_config.dart' as config;
import 'package:http/http.dart' as http;
import 'src/helpers/custom_trace.dart';
import 'src/models/setting.dart';
import 'src/repository/settings_repository.dart' as settingRepo;
import 'src/repository/user_repository.dart' as userRepo;
import 'src/constants.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
    },
    onBackgroundMessage: myBackgroundMessageHandler,
    onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
    },
    onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
    },
  );

  await GlobalConfiguration().loadFromAsset("configurations");
  print(CustomTrace(StackTrace.current,
      message: "base_url: ${GlobalConfiguration().getString('base_url')}"));
  print(CustomTrace(StackTrace.current,
      message:
          "api_base_url: ${GlobalConfiguration().getString('api_base_url')}"));
  runApp(MyApp());
  HttpOverrides.global = MyHttpOverrides();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  @override
  void initState() {
    settingRepo.initSettings();
    settingRepo.getCurrentLocation();
    userRepo.getCurrentUser();
    super.initState();
    StripePayment.setOptions(StripeOptions(
        publishableKey: Constants.stripe_publishable_key,
        merchantId: "Test",
        androidPayMode: 'test'));
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
    });
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: settingRepo.setting,
        builder: (context, Setting _setting, _) {
          print(CustomTrace(StackTrace.current,
              message: _setting.toMap().toString()));
          return MaterialApp(
              navigatorKey: settingRepo.navigatorKey,
              title: _setting.appName,
              initialRoute: '/Splash',
              onGenerateRoute: RouteGenerator.generateRoute,
              debugShowCheckedModeBanner: false,
              locale: _locale,
              // home: MyHome(),
              localizationsDelegates: [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              theme: _setting.brightness.value == Brightness.light
                  ? ThemeData(
                      fontFamily: 'Poppins',
                      primaryColor: Colors.white,
                      floatingActionButtonTheme: FloatingActionButtonThemeData(
                          elevation: 0, foregroundColor: Colors.white),
                      brightness: Brightness.light,
                      accentColor: config.Colors().mainColor(1),
                      dividerColor: config.Colors().accentColor(0.1),
                      focusColor: config.Colors().accentColor(1),
                      hintColor: config.Colors().secondColor(1),
                      textTheme: TextTheme(
                        headline5: TextStyle(
                            fontSize: 20.0,
                            color: config.Colors().secondColor(1),
                            height: 1.35),
                        headline4: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: config.Colors().secondColor(1),
                            height: 1.35),
                        headline3: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: config.Colors().secondColor(1),
                            height: 1.35),
                        headline2: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w700,
                            color: config.Colors().mainColor(1),
                            height: 1.35),
                        headline1: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w300,
                            color: config.Colors().secondColor(1),
                            height: 1.5),
                        subtitle1: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: config.Colors().secondColor(1),
                            height: 1.35),
                        headline6: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: config.Colors().mainColor(1),
                            height: 1.35),
                        bodyText2: TextStyle(
                            fontSize: 12.0,
                            color: config.Colors().secondColor(1),
                            height: 1.35),
                        bodyText1: TextStyle(
                            fontSize: 14.0,
                            color: config.Colors().secondColor(1),
                            height: 1.35),
                        caption: TextStyle(
                            fontSize: 12.0,
                            color: config.Colors().accentColor(1),
                            height: 1.35),
                      ),
                    )
                  : ThemeData(
                      fontFamily: 'Poppins',
                      primaryColor: Color(0xFF252525),
                      brightness: Brightness.dark,
                      scaffoldBackgroundColor: Color(0xFF2C2C2C),
                      accentColor: config.Colors().mainDarkColor(1),
                      dividerColor: config.Colors().accentColor(0.1),
                      hintColor: config.Colors().secondDarkColor(1),
                      focusColor: config.Colors().accentDarkColor(1),
                      textTheme: TextTheme(
                        headline5: TextStyle(
                            fontSize: 20.0,
                            color: config.Colors().secondDarkColor(1),
                            height: 1.35),
                        headline4: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: config.Colors().secondDarkColor(1),
                            height: 1.35),
                        headline3: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: config.Colors().secondDarkColor(1),
                            height: 1.35),
                        headline2: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w700,
                            color: config.Colors().mainDarkColor(1),
                            height: 1.35),
                        headline1: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w300,
                            color: config.Colors().secondDarkColor(1),
                            height: 1.5),
                        subtitle1: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: config.Colors().secondDarkColor(1),
                            height: 1.35),
                        headline6: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: config.Colors().mainDarkColor(1),
                            height: 1.35),
                        bodyText2: TextStyle(
                            fontSize: 12.0,
                            color: config.Colors().secondDarkColor(1),
                            height: 1.35),
                        bodyText1: TextStyle(
                            fontSize: 14.0,
                            color: config.Colors().secondDarkColor(1),
                            height: 1.35),
                        caption: TextStyle(
                            fontSize: 12.0,
                            color: config.Colors().secondDarkColor(0.6),
                            height: 1.35),
                      ),
                    ));
        });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
