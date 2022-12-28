import 'package:country_list_pick/country_list_pick.dart' as clp;
// import 'package:country_code_picker/country_code_picker.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';
import '../../session_manager.dart';
import '../TextSize.dart';
import '../controllers/user_controller.dart';
import '../helpers/app_config.dart' as config;
import '../models/user.dart';
import 'mobile_verification.dart';

class SignUpWidget extends StatefulWidget {
  User user;

  SignUpWidget(User user) {
    this.user = user;
  }

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends StateMVC<SignUpWidget> {
  UserController _con;
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController deviceTokenController = TextEditingController();
  TextEditingController socialIdController = TextEditingController();
  TextEditingController socialNameController = TextEditingController();
  var datetime;
  var formateDate;
  String _locale;

  void _onCountryChange(String country) {
    this.countryController.text = country;
    setState(() { });
    print("New Country selected: " + country);
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _onCountryChange("+971");
  }

  Future<void> initPlatformState() async {
    List languages;
    String currentLocale;
    try {
      languages = await Devicelocale.preferredLanguages;
      print(languages);
    } on PlatformException {
      print("Error obtaining preferred languages");
    }
    try {
      currentLocale = await Devicelocale.currentLocale;

      print(currentLocale);
    } on PlatformException {
      print("Error obtaining current locale");
    }

    if (!mounted) return;

    setState(() {
//      _languages = languages;
      _locale = currentLocale;
    });
  }

  _SignUpWidgetState() : super(UserController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.user != null) {
      firstNameController.text = widget.user.name;
      emailController.text = widget.user.email;
    }
    return WillPopScope(
//      onWillPop: Helper.of(context).onWillPop,
      child: Scaffold(
          key: _con.scaffoldKey,
          resizeToAvoidBottomInset: true,
          body: ListView(children: <Widget>[
            Align(
                alignment: Alignment.center,
                child: Container(
//                    width: config.App(context).appWidth(84),
//                    height: config.App(context).appHeight(29.5)-70,
                  child: Padding(
                      child: Text('Welcome',
                          style: TextStyle(
                              color: const Color(0xFF6244E8),
                              fontSize: TextSize.SIZE_FIELD_HEIGHT,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold)),
                      padding: EdgeInsets.only(top: TextSize.TEXT1)),
                )),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: TextSize.TEXT,
              ),
              padding: EdgeInsets.symmetric(
                  vertical: TextSize.TEXT1, horizontal: 10),
              child: Form(
                key: _con.loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: firstNameController,
                      onSaved: (input) => _con.user.name = input,
                      validator: (input) => input.length < 3
                          ? S.of(context).should_be_more_than_3_letters
                          : null,
                      inputFormatters: [
                        new FilteringTextInputFormatter.allow(
                            RegExp("[a-zA-Z]")),
                      ],
                      decoration: InputDecoration(
                        hintText: S.of(context).first_name,
                        hintStyle: TextStyle(
                            color: const Color(0xFF747084),
                            fontFamily: 'Montserrat'),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: const Color(0xFF6244E8)),
                        ),
                      ),
                    ),
                    SizedBox(height: 0),
                    Container(
                        width: config.App(context).appWidth(88),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: lastNameController,
                          onSaved: (input) => _con.user.familyName = input,
                          validator: (input) => input.length < 3
                              ? S.of(context).should_be_more_than_3_letters
                              : null,
                          inputFormatters: [
                            new FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z]")),
                          ],
                          decoration: InputDecoration(
                            hintText: S.of(context).last_name,
                            hintStyle: TextStyle(
                                color: const Color(0xFF747084),
                                fontFamily: 'Montserrat'),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: const Color(0xFF6244E8)),
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 0,
                    ),
                    Container(
                        width: config.App(context).appWidth(88),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: addressController,
                          onSaved: (input) => _con.user.address = input,
                          inputFormatters: [
                            new FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z0-9 ]")),
                          ],
                          decoration: InputDecoration(
                            hintText: "Address (optional)",
                            hintStyle: TextStyle(
                                color: const Color(0xFF747084),
                                fontFamily: 'Montserrat'),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: const Color(0xFF6244E8)),
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 0,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 1.0, color: const Color(0xFF6244E8)),
                        ),
                      ),
                      child: clp.CountryListPick(
                        theme: clp.CountryTheme(
                          initialSelection: "+971",
                          isShowFlag: true,
                          isShowTitle: true,
                          isShowCode: false,
                          //isDownIcon: true,
                          //showEnglishName: true,
                        ),

//                         initialSelection: '+971',
                        onChanged: (c) => _onCountryChange(c.name),
                      ),
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: birthdateController,
                          keyboardType: TextInputType.datetime,
                          onSaved: (input) => _con.user.birthDate = input,
                          decoration: InputDecoration(
                            hintText: 'Birthdate (optional)',
                            prefixIcon: Icon(
                              Icons.calendar_today,
                            ),
                            hintStyle: TextStyle(
                                color: const Color(0xFF747084),
                                fontFamily: 'Montserrat'),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: const Color(0xFF6244E8)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    new Container(
                        child: Padding(
                            padding: EdgeInsets.only(top: 0),
                            child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: emailController,
                                onSaved: (input) => _con.user.email = input,
                                validator: validateEmail,
                                decoration: InputDecoration(
                                  hintText: S.of(context).email,
                                  hintStyle: TextStyle(
                                      color: const Color(0xFF747084),
                                      fontFamily: 'Montserrat'),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: const Color(0xFF6244E8)),
                                  ),
                                )))),
                    SizedBox(height: 0),
                    TextFormField(
                        obscureText: _con.hidePassword,
                        controller: passwordController,
                        onSaved: (input) => _con.user.password = input,
                        validator: validatePassword,
                        decoration: InputDecoration(
                          errorMaxLines: 2,
                          hintText: S.of(context).password,
                          hintStyle: TextStyle(
                              color: const Color(0xFF747084),
                              fontFamily: 'Montserrat'),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: const Color(0xFF6244E8)),
                          ),
                        )),
                    SizedBox(height: TextSize.TEXT_PADDING2),
                    Container(
                      width: config.App(context).appWidth(100),
                      margin: EdgeInsets.fromLTRB(50, 20, 50, 0),
                      alignment: Alignment.center,
                      child: RaisedButton(
                        padding: EdgeInsets.fromLTRB(50, 5, 50, 5),
                        color: const Color(0xFF6244E8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                            side: BorderSide(color: Colors.deepPurpleAccent)),
                        onPressed: () {
                          print(
                              "Country code in shared pref : ${countryCodeController.text}");
                          if (_con.loginFormKey.currentState.validate()) {
                            setLoginCrendentails(
                              firstNameController.text,
                              lastNameController.text,
                              addressController.text,
                              countryController.text,
                              birthdateController.text,
                              countryCodeController.text,
                              mobileNumberController.text,
                              emailController.text,
                              deviceTokenController.text,
                              passwordController.text,
                            );
                            print(
                                "saved email in shared Pref : ${emailController.text}");
                            print(
                                "Country  in shared pref : ${countryController.text}");
                            print(
                                "Country code in shared pref : ${countryCodeController.text}");
                            print(
                                "device token in shared pref : ${deviceTokenController.text}");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MobileVerification(),
                              ),
                            );
                          }
                        },
                        child: Text(
                          S.of(context).signup,
                          style: TextStyle(
                              fontSize: TextSize.BUTTON_TEXT,
                              color: Colors.white,
                              fontFamily: 'Montserrat'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              child: Padding(
                  child: Text(S.of(context).by_signing_up,
                      style: TextStyle(
                        color: const Color(0xFF747084),
                        fontFamily: 'Montserrat',
                        fontSize: TextSize.TEXT,
                      )),
                  padding: EdgeInsets.fromLTRB(
                      20, TextSize.TEXT_PADDING5, 20, TextSize.TEXT_PADDING2)),
            ),
          ])),
    );
  }

  setLoginCrendentails(
    String firstName,
    String lastName,
    String address,
    String country,
    String birthdate,
    String countryCode,
    String mobileNumber,
    String email,
    String deviceToken,
    String password,
  ) {
    SessionManager.setLoginCredentials(firstName, lastName, address, country,
        birthdate, countryCode, mobileNumber, email, password, deviceToken);
  }

  DateTime selectedDate = DateTime.now();
  TextEditingController birthdateController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1960, 1),
        lastDate: (selectedDate));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        birthdateController.value = TextEditingValue(
            text: picked.year.toString() +
                '/' +
                picked.month.toString() +
                '/' +
                picked.day.toString());
      });
  }

//  String validateMobile(String value) {
//    if (value.length < 8 && value.length = 10)
//      return 'Mobile Number must be of 10 digit';
//    else
//      return null;
//  }

  String validateBirthdate(String value) {
    Pattern pattern = r'\d{4}\/(0[1-9]|1[012])\/(0[1-9]|[12][0-9]|3[01])$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty)
      return null;
    else if (!regex.hasMatch(value))
      return 'Please check the format (YYYY/MM/DD)';
    else
      return null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String validatePassword(String value) {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=(.*[a-z]){1,})(?=(.*[\d]){1,})(?=(.*[\W]){1,})(?!.*\s).{6,}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Password must contain uppercase, lower case, number and special symbol';
    else
      return null;
  }

  getSocialId() async {
    String socialId = await SessionManager.getSocialId();
    print("Social id from shared pref : $socialId");
  }

  getSocialName() async {
    String socialName = await SessionManager.getSocialName();
    print("Social name from shared pref : $socialName");
  }
}
