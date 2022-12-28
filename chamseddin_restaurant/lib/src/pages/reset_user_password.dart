import 'dart:io';

import 'package:badges/badges.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/helpers/common_methods.dart';
import 'package:food_delivery_app/src/pages/pages.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';
import '../TextSize.dart';
import '../constants.dart';
import '../controllers/user_controller.dart';
import '../helpers/app_config.dart' as config;
import 'forget_password.dart';

class ResetUserPasswordWidget extends StatefulWidget {
  @override
  _ResetUserPasswordWidgetState createState() =>
      _ResetUserPasswordWidgetState();
}

class _ResetUserPasswordWidgetState extends StateMVC<ResetUserPasswordWidget> {
  UserController _con;

  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  int cartCount;

  _ResetUserPasswordWidgetState() : super(UserController()) {
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
  }

  @override
  void dispose() {
    super.dispose();
    FBroadcast.instance().unregister(this);
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
                  : Icons.arrow_back_ios_sharp),

              color: Colors.black26,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          body: ListView(
//          alignment: AlignmentDirectional.topCenter,
              children: <Widget>[
                Align(
                    alignment: Alignment.center,
                    child: Container(
//                    width: config.App(context).appWidth(84),
//                    height: config.App(context).appHeight(29.5)-70,
                      child: Padding(
                          child: Text(S.of(context).change_my_password,
                              style: TextStyle(
                                  color: const Color(0xFF6244E8),
                                  fontSize: TextSize.DIGIT_PADDING,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold)),
                          padding:
                          EdgeInsets.only(top: TextSize.SIZE_FIELD_WIDTH)),
                    )),
                SizedBox(
                  height: 10,
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
                                obscureText: _con.hidePassword,
                                controller: passwordController,
                                onSaved: (input) => _con.user.password = input,
                                validator: (input) => input.length < 6
                                    ? S
                                    .of(context)
                                    .should_be_more_than_6_letters
                                    : null,
                                decoration: InputDecoration(
                                  hintText: S.of(context).oldPassword,
                                  hintStyle: TextStyle(
                                      color: const Color(0xFF747084),
                                      fontFamily: 'Montserrat'),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: const Color(0xFF6244E8)),
                                  ),
                                )),
                            TextFormField(
                                obscureText: _con.hidePassword,
                                controller: newPasswordController,
                                onSaved: (val) => _con.user.password = val,
                                validator: (val) {
                                  if (val.isEmpty) return 'Enter new password';
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: S.of(context).newPassword,
                                  hintStyle: TextStyle(
                                      color: const Color(0xFF747084),
                                      fontFamily: 'Montserrat'),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: const Color(0xFF6244E8)),
                                  ),
                                )),
                            TextFormField(
                                obscureText: _con.hidePassword,
                                controller: confirmPasswordController,
                                onSaved: (val) => _con.user.password = val,
                                validator: (val) {
                                  if (val.isEmpty) return 'Empty';
                                  if (val != newPasswordController.text)
                                    return 'New Password and Confirm Password does not match';
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: S.of(context).confirmNewPassword,
                                  hintStyle: TextStyle(
                                      color: const Color(0xFF747084),
                                      fontFamily: 'Montserrat'),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: const Color(0xFF6244E8)),
                                  ),
                                )),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ForgetPasswordWidget(),
                                    ),
                                  );
                                },
                                child: new Text(
                                  'Forgotten password',
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                    fontSize: TextSize.FONT_SIZE3,
                                  ),
                                ),
                              ),
                            ),
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
                                    side: BorderSide(
                                        color: Colors.deepPurpleAccent)),
                                onPressed: () {
                                  passwordController.text;
                                  newPasswordController.text;
                                  confirmPasswordController.text;
                                  _con.resetUserPassword(
                                      passwordController.text);
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
}
