import 'dart:io';

import 'package:badges/badges.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/generated/l10n.dart';
import 'package:food_delivery_app/src/elements/NotificationListWidget.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';
import 'package:food_delivery_app/src/models/place_order_response.dart';
import '../TextSize.dart';
import '../elements/FavSearchBarWidget.dart';
import '../helpers/common_methods.dart';
import '../models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../constants.dart';
import '../helpers/app_config.dart' as config;
import 'filters.dart';
import 'home.dart';

class OrderSuccessfulWidget extends StatefulWidget {
  dynamic currentTab;
  RouteArgument routeArgument;
  Widget currentPage = HomeWidget();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  PlaceOrderResponse placeOrderResponse;
  PageBar pageBar;

  OrderSuccessfulWidget(this.placeOrderResponse,{Key key, this.parentScaffoldKey, this.pageBar}) : super(key: key);

  @override
  _OrderSuccessfulWidgetState createState() => _OrderSuccessfulWidgetState();
}

class _OrderSuccessfulWidgetState extends StateMVC<OrderSuccessfulWidget> {
  int cartCount;
  int notificationsCount;

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
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushNamed('/Pages', arguments: 1);
      },
      child: Scaffold(
          key: widget.scaffoldKey,
          resizeToAvoidBottomInset: false,
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
                    Navigator.of(context).pushNamed('/Pages', arguments: 1);
                  },
                  child: Padding(
                      padding: const EdgeInsets.only(right: 8, left: 10),
                      child:   Icon(Platform.isAndroid
                          ? Icons.arrow_back
                          : Icons.arrow_back_ios_sharp,

                        color: Colors.black26,
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 0, left: 0),
                child: InkWell(
                  onTap: () {
                    widget.pageBar.notifications('notifications');
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) =>
//                              NotificationListingWidget()),
//                    );
                  },
                  child: Padding(
                      padding: const EdgeInsets.only(right: 20, left: 0),
                      child: IconButton(
                        icon: notificationsCount != null &&
                            notificationsCount > 0
                            ? Badge(
                          badgeContent: Text(
                            notificationsCount.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                          child: Icon(Icons.notifications,
                              color: Colors.deepPurpleAccent,
                              size: 28),
                          badgeColor: Colors.deepPurpleAccent,
                        )
                            : Icon(Icons.notifications,
                            color: Colors.deepPurpleAccent, size: 28),
                      )),
                ),
              ),
            ],
          ),
          )
            ],
          ),
          body: Stack(children: <Widget>[
            Positioned(
                top: 50,
                child: new Container(
                  width: config.App(context).appWidth(100),
                  height: config.App(context).appHeight(100),
                  decoration: BoxDecoration(color: const Color(0xFFF5F3F3)),
                )),
            Column(
              children: [
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
                    padding: EdgeInsets.only(top: 50),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'My QR code',
                    style: TextStyle(
                      color: const Color(0xFF6244E8),
                      fontSize: 34,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Text(
                    'Thank you for placing your order.',
                    style: TextStyle(
                      color: const Color(0xFF736F84),
                      fontSize: 18,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                widget.placeOrderResponse.response.qr == null
                    ? Text (S.of(context).unableToGenerateQrCode)
                    : Container(
                  margin: EdgeInsets.only(top: 30),
                  child: QrImage(
                    data:
//                    "Hi There, My Order ID - 123abc1234",
                    widget.placeOrderResponse.response.qr,
                    version: QrVersions.auto,
                    size: TextSize.PIC_WIDTH
                  ),
                )
              ],
            ),
          ])),
    );
  }
}
