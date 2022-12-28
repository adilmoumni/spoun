import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/generated/l10n.dart';
import 'package:food_delivery_app/src/controllers/app_localization.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';
import 'package:food_delivery_app/src/pages/pages.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../TextSize.dart';

class ChangeLanguage extends StatefulWidget{
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  PageBar pageBar;

  ChangeLanguage({Key key, this.parentScaffoldKey, this.pageBar}) : super(key: key);

  @override
  _ChangeLanguageState createState() => _ChangeLanguageState();

}

class _ChangeLanguageState extends StateMVC<ChangeLanguage>{
  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 0, left: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/Pages', arguments: 3);
                      },
                      child: Padding(
                          padding: const EdgeInsets.only(right: 8, left: 10),
                          child:   Icon(Platform.isAndroid
                              ? Icons.arrow_back
                              : Icons.arrow_back_ios_sharp,

                            color: Colors.black26,
                          ),)
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Container(
//                    width: config.App(context).appWidth(84),
//                    height: config.App(context).appHeight(29.5)-70,
                    child: Padding(
                        child: Text(S.of(context).change_language,
                            style: TextStyle(
                                color: const Color(0xFF6244E8),
                                fontSize: TextSize.DIGIT_PADDING,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold)),
                        padding:
                        EdgeInsets.only(top: TextSize.SIZE_FIELD_WIDTH)),
                  )),
              TextButton(
                  child: Text("French", style: TextStyle(
                    color: Color(0xFF6244E8)
                  ),),
                  onPressed: () {
                      AppLocalization.load(Locale('fr', 'FR'));
              Navigator.of(context).pushReplacementNamed("/Pages", arguments: 0);
                  }),
              TextButton(
                  child: Text("English", style: TextStyle(
                      color: Color(0xFF6244E8)
                  )),
                  onPressed: () {
                      AppLocalization.load(Locale('en', 'EN'));
                      Navigator.of(context).pushReplacementNamed("/Pages", arguments: 0);
                  }),
              TextButton(
                  child: Text("Arabic", style: TextStyle(
                      color: Color(0xFF6244E8)
                  )),
                  onPressed: () {
                      AppLocalization.load(Locale('ar', 'AR'));
                      Navigator.of(context).pushReplacementNamed("/Pages", arguments: 0);
                  }),
            ],
          ),
        ),

      ),);
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

}