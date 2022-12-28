import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../session_manager.dart';
import '../helpers/helper.dart';
import '../models/mobile_verification.dart';
import '../models/otp_response.dart';
import '../models/user.dart';
import '../models/verify_otp_response.dart';
import '../pages/login.dart';
import '../pages/mobile_verification_2.dart';
import '../repository/mobile_repository.dart' as repository;
import '../repository/user_repository.dart' as userRepo;

class MobileController extends ControllerMVC {
  MobileVerification mobileVerification = new MobileVerification();
  GlobalKey<ScaffoldState> scaffoldKey;
  OverlayEntry loader;
  GlobalKey<FormState> loginFormKey;
  FirebaseMessaging _firebaseMessaging;

  MobileController() {
    loader = Helper.overlayLoader(context);
  }

  void sendOtp(BuildContext context, String email) async {
    FocusScope.of(context).unfocus();
    Overlay.of(context).insert(loader);
    mobileVerification.email = email;
    repository.sendOTP(mobileVerification).then((value) {
      if(value.response.code == 200) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => MobileVerification2(mobileVerification)),
        );
        loader.remove();
        Flushbar(
//          title: value.response.message,
          message: "Otp sent successfully",
          duration: Duration(seconds: 3),
        ).show(context);
      } else if (value.response.code == 202) {
        loader.remove();
       Flushbar(
//         title: value.response.message,
         message: value.response.message.toString(),
         duration: Duration(seconds: 3),
       ).show(context);
      }
    });
  }


  void verifyOtp(
      String email, String countryCode, String mobileNumber, String otp) async {
    FocusScope.of(context).unfocus();
    mobileVerification.email = email;
    mobileVerification.countryCode = countryCode;
    mobileVerification.mobileNumber = mobileNumber;
    mobileVerification.otp = otp;
    Overlay.of(context).insert(loader);
    VerifyOtpResponse verifyOtpResponse =
        await repository.verifyOtp(mobileVerification);
    if (verifyOtpResponse != null && verifyOtpResponse.response.vCode != null) {
      User user = User();
      _firebaseMessaging = FirebaseMessaging();
      _firebaseMessaging.getToken().then((String _deviceToken) {
        user.deviceToken = _deviceToken;
        user.vCode = verifyOtpResponse.response.vCode;
        user.countryCode = countryCode;
        getSignupData(user);
        loader.remove();
      });
    } else {
      Flushbar(
        message: ("OTP invalid"),
        duration: Duration(seconds: 3),
      ).show(context);
      loader.remove();
    }
  }

  void resendOtp(String email, String countryCode, String mobileNumber) async {
    mobileVerification.email = email;
    mobileVerification.countryCode = countryCode;
    mobileVerification.mobileNumber = mobileNumber;
    repository.sendOTP(mobileVerification).then((value){
      if (value.response.code == 200) {
        Flushbar(
//          title: value.response.message,
          message: "Otp sent successfully",
          duration: Duration(seconds: 3),
        ).show(context);
      } else if (value.response.code == 202) {
        Flushbar(
//          title: value.response.message,
          message: "Unable to send OTP",
          duration: Duration(seconds: 3),
        ).show(context);
      }
    });
  }

  getSignupData(User user) async {
    user.name = await SessionManager.getFirstName();

    user.familyName = await SessionManager.getLastName();

    user.address = await SessionManager.getAddress();

    user.country = await SessionManager.getCountryCode();
    user.birthDate = await SessionManager.getBirthdate();
//    user.countryCode = await SessionManager.getBirthdate();
//    print("country code from shared pref : $user.countryCode");
    user.mobileNumber = await SessionManager.getMobileNumber();

    user.email = await SessionManager.getEmail();

    user.password = await SessionManager.getPassword();

    user.socialId = await SessionManager.getSocialId();
    print("social id :::::: ${user.socialId}");
    user.socialName = await SessionManager.getSocialName();

    User userResponse = await userRepo.register(user);
    if (userResponse != null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginWidget()));
      Flushbar(
//          title: value.response.message,
        message: "Account created successfully",
        duration: Duration(seconds: 3),
      ).show(context);
    }
  }
}
