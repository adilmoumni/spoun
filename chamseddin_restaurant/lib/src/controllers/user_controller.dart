import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/user.dart';
import '../models/user_login_response.dart';
import '../repository/user_repository.dart' as repository;
import '../../session_manager.dart';

class UserController extends ControllerMVC {
  User user = new User();
  UserLoginResponse userLoginResponse = UserLoginResponse();
  bool hidePassword = true;
  bool loading = false;
  GlobalKey<FormState> loginFormKey;
  OverlayEntry loader;
  GlobalKey<ScaffoldState> scaffoldKey;
  FirebaseMessaging _firebaseMessaging;


  UserController() {
    loader = Helper.overlayLoader(context);
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((String _deviceToken) {
      user.deviceToken = _deviceToken;
    }).catchError((e) {
      print('Notification not configured');
    });
  }

  void login(String deviceToken) async {
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      user.deviceToken= deviceToken;
      repository.login(user).then((value) {
        if (value != null && value.apiToken != null) {
          SessionManager.setLoginCredentials(value.name, value.familyName, value.address, value.country,
              value.birthDate, value.countryCode, value.mobileNumber, value.email, user.password, user.deviceToken,);
          Navigator.of(scaffoldKey.currentContext)
              .pushReplacementNamed('/Pages', arguments: 0);
        } else if (value == null && value !=true) {
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text(S.of(context).wrong_email_or_password),
          ));
        } else {
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
              content: Text(S.of(context).this_account_not_exist)));
      }
      }).catchError((e) {
        loader.remove();
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).this_account_not_exist),
        ));
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  void socialLogin() async {
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      repository.login(user).then((value) {
        if (value != null && value.apiToken != null) {
          SessionManager.setLoginCredentials(value.name, value.familyName, value.address, value.country,
            value.birthDate, value.countryCode, value.mobileNumber, value.email, user.password, user.deviceToken,);
          Navigator.of(scaffoldKey.currentContext)
              .pushReplacementNamed('/Pages', arguments: 0);
        } else {
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text(S.of(context).wrong_email_or_password),
          ));
        }
      }).catchError((e) {
        loader.remove();
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).this_account_not_exist),
        ));
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  void register(
      String name,
      String lastName,
      String address,
      String country,
      String countryCode,
      String birthdate,
      String mobileNumber,
      String email,
      String password,
      String vCode,
      String deviceToken,
      String socialId,
      String socialName,) async {
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      user.name = name;
      user.familyName = lastName;
      user.address = address;
      user.countryCode = countryCode;
      user.country = country;
      user.birthDate = birthdate;
      user.mobileNumber = mobileNumber;
      user.email = email;
      user.password = password;
      user.socialId = socialId;
      user.socialName = socialName;
      Overlay.of(context).insert(loader);
      repository.register(user).then((value) {
        if (value != null && value.apiToken != null) {
          Navigator.of(scaffoldKey.currentContext)
              .pushReplacementNamed('/Pages', arguments: 2);
        } else {
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text(S.of(context).wrong_email_or_password),
          ));
        }
      }).catchError((e) {
        loader?.remove();
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).this_email_account_exists),
        ));
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  void resetPassword() {
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      repository.resetPassword(user).then((value) {
        if (value != null && value == true) {
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content:
                Text(S.of(context).your_reset_link_has_been_sent_to_your_email),
            action: SnackBarAction(
              label: S.of(context).login,
              onPressed: () {
                Navigator.of(scaffoldKey.currentContext)
                    .pushReplacementNamed('/Login');
              },
            ),
            duration: Duration(seconds: 90),
          )
          );
        } else if (value == null && value != true) {
          loader.remove();
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text('Email does not exist'),
          ));
        }
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  void resetUserPassword(String oldPassword) {
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      user.oldPassword = oldPassword;
      Overlay.of(context).insert(loader);
      repository.resetUserPassword(user).then((value) {
        if (value != null && value == true) {
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text("Password successfully changed"),
            duration: Duration(seconds: 5),
          ) );
          loader.remove();
          if (currentUser.value.apiToken != null) {
            logout().then((value) {
              SessionManager.clearSession();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/Login', (Route<dynamic> route) => false,
                  arguments: 2);
            });
          } else {
            Navigator.of(context).pushNamed('/Login');
          }
        } else if (value == null && value !=true){
          loader.remove();
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text("Old Password didn't match"),
          ));
        }
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }
}
