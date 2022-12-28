import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:food_delivery_app/generated/l10n.dart';
import 'package:food_delivery_app/src/helpers/helper.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../models/user.dart' as User1;
import '../../session_manager.dart';
import '../controllers/splash_screen_controller.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as repository;

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends StateMVC<SplashScreen> {
  SplashScreenController _con;

  SplashScreenState() : super(SplashScreenController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    getDeviceToken();
    loadData();
  }

  getDeviceToken() async {
    User1.User user = User1.User();
    FirebaseMessaging _firebaseMessaging;
    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((String _deviceToken) {
      user.deviceToken = _deviceToken;
      print("Device token from shared pref : $_deviceToken");
    });
  }

  void loadData() {
    try {
      SessionManager.isLoggedIn().then((value) async {
        if (value) {
          String email = await SessionManager.getEmail();
          String password = await SessionManager.getPassword();
          String deviceToken = await SessionManager.getDeviceToken();
          User user = new User();
          user.email = email;
          user.password = password;
          user.deviceToken = deviceToken;
          print("hhhhhhhhhhhhyeahraha----$deviceToken");
          repository.login(user).then((value) {
            if (value != null && value.apiToken != null) {
              SessionManager.setLoginCredentials(
                value.name,
                value.familyName,
                value.address,
                value.country,
                value.birthDate,
                value.countryCode,
                value.mobileNumber,
                value.email,
                user.password,
                user.deviceToken,
              );
              Navigator.of(context)
                  .pushReplacementNamed('/Pages', arguments: 0);
            } else {
              _con.scaffoldKey?.currentState?.showSnackBar(SnackBar(
                content: Text(S.of(context).this_account_not_exist),
              ));
              Navigator.of(context).pushNamed('/Login');
            }
          }).catchError((e) {
            _con.scaffoldKey?.currentState?.showSnackBar(SnackBar(
              content: Text(e.toString()),
            ));
          });
          ;
        } else {
          Navigator.of(context).pushReplacementNamed('/Login');
        }
      });
    } catch (e) {}
    /*_con.progress.addListener(() {
      double progress = 0;
      _con.progress.value.values.forEach((_progress) {
        progress += _progress;
      });
      if (progress == 100) {

      }
    });*/
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return WillPopScope(
        onWillPop: () => Helper.of(context).onBackPressed(),
        child: Scaffold(
          key: _con.scaffoldKey,
          body: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF6246E7),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/img/logo.png',
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 50),
                  CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
