import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/generated/l10n.dart';
import 'package:food_delivery_app/src/controllers/order_controller.dart';
import 'package:food_delivery_app/src/elements/NotificationListWidget.dart';
import 'package:food_delivery_app/src/helpers/custom_trace.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';
import 'package:food_delivery_app/src/models/order_detail_arguments.dart';
import 'package:food_delivery_app/src/models/order_details_response.dart';
import 'package:food_delivery_app/src/pages/pages.dart';
import '../TextSize.dart';
import '../elements/FavSearchBarWidget.dart';
import '../helpers/common_methods.dart';
import '../models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../repository/order_repository.dart';
import '../constants.dart';
import '../helpers/app_config.dart' as config;
import 'home.dart';

class QRcodeWidget extends StatefulWidget {
  dynamic currentTab;
  RouteArgument routeArgument;
  Widget currentPage = HomeWidget();
  OrderDetailsResponse orderDetailsResponse;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  PageBar pageBar;


  QRcodeWidget(this.orderDetailsResponse,{Key key, this.parentScaffoldKey, this.pageBar}) : super(key: key);

  @override
  _QRcodeWidgetState createState() => _QRcodeWidgetState();
}

class _QRcodeWidgetState extends StateMVC<QRcodeWidget> {
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
      onWillPop: () {
        var orderDetailsArguments =
        new OrderDetailsArguments(
            widget.orderDetailsResponse.response.data.first.orderId.toString(),
            null);
        widget.pageBar.orderDetails(orderDetailsArguments);
      },
//      onWillPop: () {
//        Navigator.of(context).pushNamed('/Pages');
//      },
      child: Scaffold(
          key: widget.scaffoldKey,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            actions: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 0, left: 10),
                      child: InkWell(
                        onTap: () {
                          var orderDetailsArguments =
                          new OrderDetailsArguments(
                              widget.orderDetailsResponse.response.data.first.orderId.toString(),
                              null);
//                          Navigator.of(context).pushNamed('/Pages', arguments: 3);
                          widget.pageBar.orderDetails(orderDetailsArguments);
//                          widget.pageBar.orderDetails('orderDetails');
//                          Navigator.of(context).pop();
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
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) =>
//                                    NotificationListingWidget()),
//                          );
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
                top: 0,
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
                    padding: EdgeInsets.only(top: 0),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    S.of(context).myQrCode,
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
                    S.of(context).qrCodeForYourOrderIs,
                    style: TextStyle(
                      color: const Color(0xFF736F84),
                      fontSize: 18,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                widget.orderDetailsResponse.response.data.first.qr == null
                    ? Text (S.of(context).unableToGenerateQrCode)
                : Container(
                  margin: EdgeInsets.only(top: 30),
                  child: QrImage(
                      data:
//                      "Hi There, My Order ID - 123abc1234",
                      widget.orderDetailsResponse.response.data.first.qr,
                      version: QrVersions.auto,
                      size: TextSize.PIC_WIDTH
                  ),
                )
              ],
            ),
          ])
      ),
    );
  }
}
