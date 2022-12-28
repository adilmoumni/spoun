import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/generated/l10n.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../session_manager.dart';
import '../TextSize.dart';
import '../controllers/mobile_controller.dart';
import '../helpers/app_config.dart' as config;
import '../models/mobile_verification.dart';

class MobileVerification2 extends StatefulWidget {
  MobileVerification mobileVerification;

  MobileVerification2(MobileVerification mobileVerification) {
    this.mobileVerification = mobileVerification;
  }

  @override
  _MobileWidgetState2 createState() => _MobileWidgetState2();
}

class _MobileWidgetState2 extends StateMVC<MobileVerification2> {
  MobileController _mobController;
  TextEditingController otp1 = TextEditingController();
  TextEditingController otp2 = TextEditingController();
  TextEditingController otp3 = TextEditingController();
  TextEditingController otp4 = TextEditingController();
  TextEditingController otp5 = TextEditingController();
  TextEditingController otp6 = TextEditingController();

  _MobileWidgetState2() : super(MobileController()) {
    _mobController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          leading: IconButton(
              icon:   Icon(Platform.isAndroid
                  ? Icons.arrow_back
                  : Icons.arrow_back_ios_sharp,

                color: Colors.black26,
              ),
              onPressed: () => Navigator.of(context).pop()),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: ListView(children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Padding(
                child: Text(
                  S.of(context).verification,
                  style: TextStyle(
                    color: const Color(0xFF6244E8),
                    fontSize: TextSize.TEXT2,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat-Bold',
                  ),
                ),
                padding: EdgeInsets.only(top: 50),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                child: Text(
                  'Enter the code we sent you\n'
                  '      on ${widget?.mobileVerification?.countryCode} ${widget?.mobileVerification?.mobileNumber}',
                  style: TextStyle(
                    color: const Color(0xFF736F84),
                    fontSize: TextSize.TEXT4,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat-Bold',
                  ),
                ),
                padding: EdgeInsets.only(top: 50),
              ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: new TextFormField(
                        keyboardType: TextInputType.number,
                        controller: otp1,
                        onChanged: (_) {
                          if(_ == "") {
//                            FocusScope.of(context).hasFocus;
                          } else {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        maxLength: 1,
                        textInputAction: TextInputAction.next,
                        autofocus: true,
                        decoration: InputDecoration(
                          counterText: "",
                          contentPadding: EdgeInsets.fromLTRB(15, 18, 15, 15),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        )),
                  ),
                ),
                new Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: new TextFormField(
                        keyboardType: TextInputType.number,
                        controller: otp2,
                        onChanged: (_) {
                          if(_ == "") {
//                            FocusScope.of(context).hasFocus;
                          } else {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        maxLength: 1,
                        textInputAction: TextInputAction.next,
                        autofocus: true,
                        decoration: InputDecoration(
                          counterText: "",
                          contentPadding: EdgeInsets.all(18),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        )),
                  ),
                ),
                new Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: new TextFormField(
                        keyboardType: TextInputType.number,
                        controller: otp3,
                        onChanged: (_) {
                          if(_ == "") {
//                            FocusScope.of(context).hasFocus;
                          } else {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        maxLength: 1,
                        textInputAction: TextInputAction.next,
                        autofocus: true,
                        decoration: InputDecoration(
                          counterText: "",
                          contentPadding: EdgeInsets.all(18),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        )),
                  ),
                ),
                new Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: new TextFormField(
                        keyboardType: TextInputType.number,
                        controller: otp4,
                        onChanged: (_) {
                          if(_ == "") {
//                            FocusScope.of(context).hasFocus;
                          } else {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        maxLength: 1,
                        textInputAction: TextInputAction.next,
                        autofocus: true,
                        decoration: InputDecoration(
                          counterText: "",
                          contentPadding: EdgeInsets.all(18),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        )),
                  ),
                ),
                new Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: new TextFormField(
                      keyboardType: TextInputType.number,
                      controller: otp5,
                      onChanged: (_) {
                        if(_ == "") {
//                            FocusScope.of(context).hasFocus;
                        } else {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: "",
                        contentPadding: EdgeInsets.all(18),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                new Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 15, 0),
                      child: new TextFormField(
                        keyboardType: TextInputType.number,
                        controller: otp6,
                        textInputAction: TextInputAction.done,
                        autofocus: true,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: "",
                          contentPadding: EdgeInsets.fromLTRB(10, 19, 15, 15),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
            Container(
              alignment: Alignment.center,
              child: Padding(
                child: Text(
                  S.of(context).didntYouReceiveTheCode,
                  style: TextStyle(
                    color: const Color(0xFF736F84),
                    fontSize: TextSize.TEXT4,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Montserrat',
                  ),
                ),
                padding: EdgeInsets.only(top: 20),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  getMobileNumber();
                },
                child: Text(
                  S.of(context).resent_a_new_code,
                  style: TextStyle(
                    color: const Color(0xFF736F84),
                    fontSize: TextSize.BUTTON_TEXT,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              padding: EdgeInsets.only(top: TextSize.TEXT),
            ),
            Container(
//          width: config.App(context).appWidth(88)-200,
              margin:
                  EdgeInsets.fromLTRB(80, TextSize.TEXT1, 80, TextSize.TEXT),
              child: RaisedButton(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                color: const Color(0xFF6244E8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                    side: BorderSide(color: const Color(0xFF6244E8))),
                onPressed: () {
                  getEmail(otp1.text, otp2.text, otp3.text, otp4.text,
                      otp5.text, otp6.text);
                  print("OTP :" +otp1.text+otp2.text+otp3.text+otp4.text+otp5.text+otp6.text);
                },
                child: Text(
                  S.of(context).create_an_account,
                  style: TextStyle(
                    fontSize: TextSize.TEXT3,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Padding(
                child: Text(
                  S.of(context).only_10_tentatives_possible,
                  style: TextStyle(
                    color: const Color(0xFF736F84),
                    fontSize: TextSize.BUTTON_TEXT,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Montserrat',
                  ),
                ),
                padding: EdgeInsets.only(top: 0),
              ),
            ),
          ]),
        )
    );
  }

  getEmail(
      String o1, String o2, String o3, String o4, String o5, String o6) async {
    String otp = "$o1$o2$o3$o4$o5$o6";
    String email = await SessionManager.getEmail();

    String countryCode = await SessionManager.getCountryCode();

    String mobileNumber = await SessionManager.getMobileNumber();

    String socialId = await SessionManager.getSocialId();
    print("social id from shared pref : $socialId");
    String socialName = await SessionManager.getSocialName();
    print("social name : $socialName");
//      _con.sendOtp(context,email);
    _mobController.verifyOtp(email, countryCode, mobileNumber, otp);
  }

  getSignupData() async {
    String name = await SessionManager.getFirstName();

    String familyName = await SessionManager.getLastName();

    String address = await SessionManager.getAddress();

    String country = await SessionManager.getCountryCode();

    String birthDate = await SessionManager.getBirthdate();

    String countryCode = await SessionManager.getCountryCode();

    String mobileNumber = await SessionManager.getMobileNumber();

    String email = await SessionManager.getEmail();

    String password = await SessionManager.getPassword();

    String socialId = await SessionManager.getSocialId();
    print("social id from shared pref : $socialId");
    String socialName = await SessionManager.getSocialName();
  }

  getMobileNumber() async {
    String mobileNumber = await SessionManager.getMobileNumber();
    print("mobile number from shared pref: $mobileNumber");
    String email = await SessionManager.getEmail();
    print("email from shared prefs : $email");
    String countryCode = await SessionManager.getCountryCode();
    print("Country code from shared prefs : $countryCode");
    _mobController.resendOtp(email, countryCode, mobileNumber);
  }
}
