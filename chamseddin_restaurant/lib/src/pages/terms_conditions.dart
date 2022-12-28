import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/generated/l10n.dart';
import 'package:food_delivery_app/src/pages/pages.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../TextSize.dart';
import '../controllers/user_controller.dart';

class TermsAndConditonsWidget extends StatefulWidget {
  @override
  _TermsAndConditonsWidgetState createState() =>
      _TermsAndConditonsWidgetState();
}

class _TermsAndConditonsWidgetState extends StateMVC<TermsAndConditonsWidget> {
  _TermsAndConditonsWidgetState() : super(UserController()) {}

  @override
  void initState() {
    super.initState();
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
            body: ListView(children: <Widget>[
              Align(
                  alignment: Alignment.center,
                  child: Container(
//                    width: config.App(context).appWidth(84),
//                    height: config.App(context).appHeight(29.5)-70,
                    child: Padding(
                      child: Text(S.of(context).terms_and_conditions,
                          style: TextStyle(
                              color: const Color(0xFF6244E8),
                              fontSize: TextSize.DIGIT_PADDING,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold)),
                      padding: EdgeInsets.only(top: TextSize.SIZE_FIELD_WIDTH),
                    ),
                  )),
              Padding(padding: EdgeInsets.only(left: 120, top: 50),
                child: Container(
                  child: Text('Coming Soon',
                    style: TextStyle(fontSize: 18),),
                ),)
            ])));
  }
}
