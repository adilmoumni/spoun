// import 'package:country_code_picker/country_code_picker.dart';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/generated/l10n.dart';
import 'package:food_delivery_app/src/pages/signup.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../session_manager.dart';
import '../controllers/mobile_controller.dart';
import '../helpers/app_config.dart' as config;
import '../repository/mobile_repository.dart' as repo;
import 'package:country_list_pick/country_list_pick.dart' as clp;

class MobileVerification extends StatefulWidget {
  MobileVerification();

  @override
  _MobileWidgetState createState() => _MobileWidgetState();
}

class _MobileWidgetState extends StateMVC<MobileVerification> {
  MobileController _con;
  String email;
  TextEditingController countryCodeController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  void _onCountryChange(clp.CountryCode countryCode) {
    setState(() {
      this.countryCodeController.text =
      countryCode == "" ? "+971" : countryCode.toString();
    });
    print("New Country selected: " + countryCode.toString());
  }

  _MobileWidgetState() : super(MobileController()) {
    _con = controller;
  }

  @override
  void initState() {
    this.countryCodeController.text = "+971";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _con.mobileVerification.countryCode = countryCodeController.text;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon:   Icon(Platform.isAndroid
              ? Icons.arrow_back
              : Icons.arrow_back_ios_sharp,

          color: Colors.black26,)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
          key: _con.scaffoldKey,
          child: ListView(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Padding(
                  child: Text(
                    S.of(context).registration,
                    style: TextStyle(
                      color: const Color(0xFF6244E8),
                      fontSize: 30,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  padding: EdgeInsets.only(top: 80),
                ),
              ),
              Container(
                  width: config.App(context).appWidth(88),
                  height: config.App(context).appHeight(29.5) - 30,
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      child: Text(
                        '              Enter your number.\n'
                        'We will send you a verification code',
                        style: TextStyle(
                          color: const Color(0xFF736F84),
                          fontSize: 18,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      padding: EdgeInsets.only(top: 50),
                    ),
                  )),
              SizedBox(height: 30),
              new Row(children: <Widget>[
                clp.CountryListPick(
                  theme: clp.CountryTheme(
                    isShowFlag: false,
                    isShowTitle: false,
                    isShowCode: true,
                    //isDownIcon: true,
                    showEnglishName: true,
                  ),
                  initialSelection: '+971',
                  onChanged: _onCountryChange,
                ),
                // CountryCodePicker(
//                   textStyle: TextStyle(
//                       fontSize: 16,
//                       fontFamily: 'Montserrat',
//                       color: Colors.black45),
//                   onChanged: _onCountryChange,
//                   // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
// //                  initialSelection: 'IN',
// //                  favorite: ['+91', 'IN'],
// //                  countryFilter: ['IN'],
//                   showFlagDialog: false,
//                   showFlagMain: false,
//                   alignLeft: false,
//                   comparator: (a, b) => b.name.compareTo(a.name),
//                   //Get the country information relevant to the initial selection
//                   onInit: (code) => print(
//                       "on init ${code.name} ${code.dialCode} ${code.flagUri}"),
//                 ),
                new Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 30, 20),
                    child: new TextField(
//                        validator: validateMobile,
                      controller: mobileNumberController,
                      onChanged: (input) =>
                          _con.mobileVerification.mobileNumber = input,
                      onSubmitted: (input) =>
                          _con.mobileVerification.mobileNumber = input,
//                        getMobileNumber(),
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        color: Colors.black45,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 22, 20, 10),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: const Color(0xFF736F84)),
                          )),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
              ]),
//            SizedBox(height: 50),
              Container(
                margin: EdgeInsets.fromLTRB(110, 40, 110, 100),
                child: RaisedButton(
                  color: const Color(0xFF6244E8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: const Color(0xFF6244E8))),
                  onPressed: () {
                    getEmail();
                    getCountryCode();
                  },
                  child: Text(
                    S.of(context).next,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  getEmail() async {
    String email = await SessionManager.getEmail();
    print("email from shared pref: $email");
    setMobile(countryCodeController.text, mobileNumberController.text);
    _con.sendOtp(context, email);
  }

  getCountryCode() async {
    String countryCode = await SessionManager.getCountryCode();
    print("Country code from shared pref : $countryCode");
  }

  String validateMobile(String value) {
// Indian Mobile number are of 10 digit only
    if (value.length != 10)
      return 'Mobile Number must be of 10 digit';
    else
      return null;
  }

  setMobile(String countryCode, String mobileNumber) {
    SessionManager.setMobile(countryCode, mobileNumber);
  }
}
