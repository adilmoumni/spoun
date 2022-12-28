import 'dart:io';

import 'package:badges/badges.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/elements/OrderListingWidget.dart';
import 'package:food_delivery_app/src/helpers/common_methods.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';
import 'package:food_delivery_app/src/pages/pages.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../TextSize.dart';
import '../constants.dart';
import '../controllers/user_controller.dart';

class CustomerServiceWidget extends StatefulWidget {
  PageBar pageBar;

  CustomerServiceWidget({Key key, this.pageBar}) : super(key: key);
  @override
  _CustomerServiceWidgetState createState() => _CustomerServiceWidgetState();
}

class _CustomerServiceWidgetState extends StateMVC<CustomerServiceWidget> {
  int cartCount;

  _CustomerServiceWidgetState() : super(UserController()) {}

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
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () => Navigator.of(context).pushNamed('/Pages', arguments: 3),
                icon:   Icon(Platform.isAndroid
                    ? Icons.arrow_back
                    : Icons.arrow_back_ios_sharp,
              ),
                color: Colors.black26,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
            ),
            body: Stack(
                alignment: AlignmentDirectional.topStart,
                children: <Widget>[
                  Center(
                    child: Stack(children: <Widget>[
                      Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            child: Padding(
                                child: Text('Customer service',
                                    style: TextStyle(
                                        color: const Color(0xFF6244E8),
                                        fontSize: TextSize.DIGIT_PADDING,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold)),
                                padding: EdgeInsets.only(
                                    top: TextSize.SIZE_FIELD_HEIGHT)),
                          )),
                      Positioned(
                          top: 10,
                          child: Container(
                            child: new Image(
                              image: new AssetImage(
                                "assets/img/logo2.png",
                              ),
                              height: TextSize.PRODUCT_INFO_HEIGHT,
                              width: TextSize.PRODUCTADD_CONTAINER_WIDTH,
                            ),
                            padding: EdgeInsets.fromLTRB(50, 20, 200, 70),
                          )),
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 15, 0, 0),
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                widget.pageBar.orderListing('orderListing');
//                                Navigator.of(context).pushReplacement(
//                                    MaterialPageRoute(
//                                        builder: (context) => OrderListingWidget()));
                              },
                              child: new Text(
                                'Contact us about your order',
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  fontSize: TextSize.FONT_SIZE,
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 15, 20, 0),
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {},
                              child: new Text(
                                '>',
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  fontSize: TextSize.FONT_SIZE,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 100, 0, 0),
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {},
                              child: new Text(
                                'Send us your feedback',
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  fontSize: TextSize.FONT_SIZE,
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 100, 20, 0),
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {},
                              child: new Text(
                                '>',
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  fontSize: TextSize.FONT_SIZE,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 180, 0, 0),
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {},
                              child: new Text(
                                'Rate us on the app store',
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  fontSize: TextSize.FONT_SIZE,
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 180, 20, 0),
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {},
                              child: new Text(
                                '>',
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  fontSize: TextSize.FONT_SIZE,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 550, 140, 0),
                            alignment: Alignment.centerRight,
                            child: new Text(
                              'C 2020 Spoon Eat',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                fontSize: TextSize.FONT_SIZE2,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(60, 10, 80, 0),
                            alignment: Alignment.center,
                            child: new Text(
                              'Version 1.1',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                fontSize: TextSize.FONT_SIZE2,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(40, 10, 80, 0),
                            alignment: Alignment.centerRight,
                            child: new Text(
                              'Terms & Conditions - Privacy Policy',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                fontSize: TextSize.FONT_SIZE3,
                              ),
                            ),
                          )
                        ],
                      )
                    ]),
                  )
                ])));
  }
}
