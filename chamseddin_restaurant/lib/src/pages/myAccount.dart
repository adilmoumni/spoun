import 'dart:io';

import 'package:badges/badges.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery_app/src/helpers/common_methods.dart';
import 'package:food_delivery_app/src/pages/pages.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../TextSize.dart';
import '../constants.dart';
import '../controllers/user_controller.dart';
import '../helpers/app_config.dart' as config;
import '../models/my_account_response.dart';
import '../models/user.dart';
import '../repository/user_repository.dart';

class MyAccountWidget extends StatefulWidget {
  MyAccountUser user;

  MyAccountWidget(User user);

  @override
  _MyAccountWidgetState createState() => _MyAccountWidgetState();
}

class _MyAccountWidgetState extends StateMVC<MyAccountWidget> {
  UserController _con;
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController userImageController = TextEditingController();
  int cartCount;

  _MyAccountWidgetState() : super(UserController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    /// register
    FBroadcast.instance().register(Constants.cartCount, (value, callback) {
      /// get data
      cartCount = value;
      setState(() {});
    });
    CommonMethods.getCartCount();
        getUserProfile();
  }

  Future<bool> _onWillPop() async {
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return PagesWidget(currentTab: 3,);
        },
      ),
    );
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    FBroadcast.instance().unregister(this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          key: _con.scaffoldKey,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pushNamed('/Pages', arguments: 3),
              icon:   Icon(Platform.isAndroid
                  ? Icons.arrow_back
                  : Icons.arrow_back_ios_sharp,

              color: Colors.black26,)
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          body: widget.user == null
              ? Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              valueColor:
              AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
            ),
          )
              : ListView(children: <Widget>[
            Align(
                alignment: Alignment.center,
                child: Container(
                  child: Padding(
                      child: Text(S.of(context).my_account,
                          style: TextStyle(
                              color: const Color(0xFF6244E8),
                              fontSize: TextSize.DIGIT_PADDING,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold)),
                      padding:
                      EdgeInsets.only(top: TextSize.DIGIT_PADDING)),
                )),
            SizedBox(
              height: 5,
            ),
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
                          controller: firstNameController,
                          onSaved: (input) => _con.user.name = input,
                          validator: (input) => input.length < 3
                              ? S
                              .of(context)
                              .should_be_more_than_3_letters
                              : null,
                          inputFormatters: [
                            new FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z0-9]")),
                          ],
                          decoration: InputDecoration(
                            hintText: S.of(context).first_name,
                            hintStyle: TextStyle(
                                color: const Color(0xFF747084),
                                fontFamily: 'Montserrat'),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: const Color(0xFF6244E8)),
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: lastNameController,
                          onSaved: (input) =>
                          _con.user.familyName = input,
                          validator: (input) => input.length < 3
                              ? S
                              .of(context)
                              .should_be_more_than_3_letters
                              : null,
                          inputFormatters: [
                            new FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z0-9]")),
                          ],
                          decoration: InputDecoration(
                            hintText: S.of(context).last_name,
                            hintStyle: TextStyle(
                                color: const Color(0xFF747084),
                                fontFamily: 'Montserrat'),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: const Color(0xFF6244E8)),
                            ),
                          ),
                        ),
                        TextFormField(
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
                            )),
                        SizedBox(height: TextSize.TEXT_PADDING2),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: mobileNumberController,
                          onSaved: (value) =>
                          _con.user.mobileNumber = value,
                          validator: validateMobile,
                          decoration: InputDecoration(
                            hintText: S.of(context).mobile,
                            hintStyle: TextStyle(
                                color: const Color(0xFF747084),
                                fontFamily: 'Montserrat'),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: const Color(0xFF6244E8)),
                            ),
                          ),
                        ),
                        Container(
                          width: config.App(context).appWidth(100),
                          margin: EdgeInsets.fromLTRB(50, 20, 50, 0),
                          alignment: Alignment.center,
                          child: RaisedButton(
                            padding: EdgeInsets.fromLTRB(50, 5, 50, 5),
                            color: const Color(0xFF6244E8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                                side: BorderSide(
                                    color: Colors.deepPurpleAccent)),
                            onPressed: () {
                              if (_con.loginFormKey.currentState
                                  .validate()) {
                                updateUserProfile(
                                  firstNameController.text,
                                  lastNameController.text,
                                  emailController.text,
                                  countryCodeController.text,
                                  mobileNumberController.text,
//                                          userImageController.text
                                ).then((value) {
                                  if (value != null) {
                                    getUserProfile();
                                  }
                                });
                              }
                            },
                            child: Text(
                              S.of(context).save,
                              style: TextStyle(
                                  fontSize: TextSize.BUTTON_TEXT,
                                  color: Colors.white,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ]),
                ))
          ])),
    );
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

  String validateMobile(String value) {
    if (value.length != 10)
      return 'Mobile Number must be of 10 digit';
    else
      return null;
  }

  void getUserProfile() {
    widget.user = null;
    setState(() {});
    getUser().then((userResponse) {
      widget.user = userResponse.response.data.first;
      firstNameController.text = widget.user.name ?? '';
      lastNameController.text = widget.user.familyName ?? '';
      emailController.text = widget.user.email ?? '';
      mobileNumberController.text = widget.user.phone ?? '';
      countryCodeController.text = widget.user.countryCode ?? '';
      setState(() {});
    });
  }
}
