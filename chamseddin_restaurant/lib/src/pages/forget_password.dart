import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/TextSize.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/user_controller.dart';
import '../helpers/app_config.dart' as config;
import 'login.dart';

class ForgetPasswordWidget extends StatefulWidget {
  @override
  _ForgetPasswordWidgetState createState() => _ForgetPasswordWidgetState();
}

class _ForgetPasswordWidgetState extends StateMVC<ForgetPasswordWidget> {
  UserController _con;
  GlobalKey<ScaffoldState> scaffoldKey;
  TextEditingController emailController = TextEditingController();

  _ForgetPasswordWidgetState() : super(UserController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          key: _con.scaffoldKey,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Platform.isAndroid
                      ? Icons.arrow_back
                      : Icons.arrow_back_ios_sharp,
                  color: Colors.black26,
                )),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          body: ListView(
            children: [
              Stack(
//          alignment: AlignmentDirectional.topCenter,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        top: 0,
                      ),
                      child: Container(
                        width: config.App(context).appWidth(100),
                        height: config.App(context).appHeight(30),
                        decoration: BoxDecoration(color: Colors.white),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                          child: Text(S.of(context).forgotYourPassword,
                              style: TextStyle(
                                  color: const Color(0xFF6244E8),
                                  fontSize: 26.5,
                                  fontFamily: 'Montserrat-Bold',
                                  fontWeight: FontWeight.bold,
                                  backgroundColor: Colors.white)),
                          padding: EdgeInsets.only(top: 10)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 80,
                      ),
                      child: new Container(
                        width: config.App(context).appWidth(100),
                        height: config.App(context).appHeight(80),
                        decoration:
                            BoxDecoration(color: const Color(0xFFF5F3F3)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        child: Text(
                          '-',
                          style: TextStyle(
                            color: const Color(0xFF6244E8),
                            fontSize: 100,
                            fontFamily: 'Montserrat',
//                        fontWeight: FontWeight.bold,
                          ),
                        ),
                        padding: EdgeInsets.only(top: 30),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        child: Text(
                          '  Enter your email to receive password\n'
                          '                     reset instruction',
                          style: TextStyle(
                            color: const Color(0xFF736F84),
                            fontSize: 16,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        padding: EdgeInsets.only(top: 130),
                      ),
                    ),
                    Positioned(
                        top: 10,
                        child: Container(
                          child: new Image(
                            image: new AssetImage(
                              "assets/img/sendIcon.png",
                            ),
                            height: TextSize.POPUP_PROFILE_HEIGHT,
                            width: TextSize.LOGO_WIDTH1,
                          ),
                          padding: EdgeInsets.fromLTRB(25, 20, 200, 100),
                        )),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    Positioned(
                        top: config.App(context).appHeight(42),
                        child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 0,
                            ),
                            padding: EdgeInsets.only(
                                top: 0,
                                right: 0,
                                left: TextSize.PADDING,
                                bottom: TextSize.PADDING),
                            width: config.App(context).appWidth(88),
                            child: Form(
                              key: _con.loginFormKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      onSaved: (input) =>
                                          _con.user.email = input,
                                      controller: emailController,
                                      validator: validateEmail,
                                      decoration: InputDecoration(
                                        hintText: "Enter mail address",
                                        hintStyle: TextStyle(
                                            color: Colors.black45,
                                            fontFamily: 'Montserrat',
                                            fontSize:
                                                TextSize.LOGO_PADDING_SIZE,
                                            fontWeight: FontWeight.w500),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                      )),
                                  new Row(
                                    children: <Widget>[
                                      new Container(
                                          child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0,
                                                  TextSize.BUTTON_PADDING,
                                                  0,
                                                  0),
                                              child: Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Text(
                                                    'Remember Password ? ',
                                                    style: TextStyle(
                                                      color: const Color(
                                                          0xFF736F84),
                                                      fontSize: TextSize.BUTTON,
                                                      fontFamily: 'Montserrat',
//                                    fontWeight: FontWeight.bold,x
//                                    backgroundColor: Colors.white
                                                    )),
//                            padding: EdgeInsets.only(top: 8, left: 0))
                                              ))),
                                      new Container(
                                          child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0,
                                                  TextSize.BUTTON_PADDING,
                                                  TextSize.CARD_WIDTH,
                                                  0),
                                              child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              LoginWidget(),
                                                        ),
                                                      );
                                                    },
                                                    child: new Text(
                                                      'Login',
                                                      style: TextStyle(
                                                        color: const Color(
                                                            0xFF6244E8),
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize:
                                                            TextSize.BUTTON,
                                                      ),
                                                    ),
                                                  ))))
                                    ],
                                  ),
                                ],
                              ),
                            ))),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.fromLTRB(50, 400, 50, 5),
                      alignment: Alignment.center,
                      child: RaisedButton(
                        padding: EdgeInsets.fromLTRB(50, 5, 50, 5),
                        color: const Color(0xFF6244E8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                            side: BorderSide(color: Colors.deepPurpleAccent)),
                        onPressed: () {
                          if (_con.loginFormKey.currentState.validate()) {
                            _con.user.email = emailController.text;
                            _con.resetPassword();
                          }
                        },
                        child: Text(
                          "Send",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: 'Montserrat'),
                        ),
                      ),
                    ),
                  ])
            ],
          )),
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
}
