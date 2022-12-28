import 'dart:io';

import 'package:badges/badges.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../TextSize.dart';
import '../constants.dart';
import '../controllers/restaurant_controller.dart';
import '../helpers/common_methods.dart';

class WebViewWidget extends StatefulWidget {
  final String url;

  WebViewWidget(this.url);

  @override
  _WebViewWidgetState createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends StateMVC<WebViewWidget> {
  RestaurantController _con;
  int cartCount;
  int notificationsCount;

  _WebViewWidgetState() : super(RestaurantController()) {
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

    /// register
    FBroadcast.instance().register(Constants.unreadNotificationsCount,
        (value, callback) {
      /// get data
      notificationsCount = value;
      setState(() {});
    });
    CommonMethods.getCartCount();
    CommonMethods.getNotifications();
  }

  @override
  void dispose() {
    super.dispose();
    FBroadcast.instance().unregister(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon:   Icon(Platform.isAndroid
              ? Icons.arrow_back
              : Icons.arrow_back_ios_sharp),

          color: Colors.black26,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBar: Row(
        children: [
          Container(
            height: TextSize.ADDRESS_ALERT_TOP,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/Pages');
              },
              child: Padding(
                padding: EdgeInsets.only(top: TextSize.PADDING, left: TextSize.SIZED_BOX_HEIGHT),
                child: Column(
                  children: [
                    Icon(
                      Icons.home,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: TextSize.ADDRESS_ALERT_TOP,
//              color: Colors.black26,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/Pages', arguments: 1);
              },
              child: Padding(
                padding: EdgeInsets.only(top: TextSize.PADDING, left: TextSize.ADD_PIC_HEIGHT),
                child: Column(
                  children: [
                    cartCount != null && cartCount > 0
                        ? Badge(
                            badgeContent: Text(
                              cartCount.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                            child: Icon(Icons.shopping_cart,
                                color: Colors.grey, size: 24),
                            badgeColor: Colors.deepPurpleAccent,
                          )
                         : Icon(Icons.shopping_cart,
                            color: Colors.grey, size: 24),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: TextSize.ADDRESS_ALERT_TOP,
//              color: Colors.black26,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/Pages', arguments: 2);
              },
              child: Padding(
                padding: EdgeInsets.only(top: TextSize.PADDING, left: TextSize.ADD_PIC_HEIGHT),
                child: Column(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: TextSize.ADDRESS_ALERT_TOP,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/Pages', arguments: 3);
              },
              child: Padding(
                padding: EdgeInsets.only(top: TextSize.PADDING, left: TextSize.PAYMENT_MM_WIDTH),
                child: Column(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.deepPurpleAccent,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.topCenter,
            child: Text('Terms & Conditions',
                style: TextStyle(
                    color: const Color(0xFF6244E8),
                    fontSize: TextSize.DIGIT_PADDING,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 20),
              child: WebView(
                initialUrl: widget.url,
                javascriptMode: JavascriptMode.unrestricted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
