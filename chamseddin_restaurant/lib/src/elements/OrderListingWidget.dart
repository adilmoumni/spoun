import 'package:badges/badges.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/generated/l10n.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';
//import 'package:food_delivery_app/src/models/pageBar.dart';
import 'OrderListingChildWidget.dart';
import '../helpers/common_methods.dart';
import '../pages/pages.dart';
import '../repository/order_repository.dart';
import 'package:geolocator/geolocator.dart';

import '../TextSize.dart';
import '../constants.dart';
import '../models/order_list_response.dart';
import 'CircularLoadingWidget.dart';
import 'NotificationListWidget.dart';

class OrderListingWidget extends StatefulWidget {
  PageBar pageBar;
  OrderListingWidget({Key key, this.pageBar}) : super(key: key);

  @override
  OrderListingWidgetState createState() => OrderListingWidgetState();
}

class OrderListingWidgetState extends State<OrderListingWidget> {
  List<Data> details;
  List<Detail> detail;
  Position position;
  int cartCount;
  int notificationsCount;

  Future<String> getData() async {
    getOrderList().then((value) {
      this.details = value.response.data as List<Data>;
      setState(() {});
    });
    return "Success!";
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
    getData();
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          actions: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 0, left: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/Pages',arguments: 3);
                      },
                      child: Padding(
                          padding: const EdgeInsets.only(right: 8, left: 10),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black26,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 0, left: 0),
                    child: InkWell(
                      onTap: () {
//                        Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) =>
//                                  NotificationListingWidget()),
//                        );
                      widget.pageBar.notifications('notifications');
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

        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0, left: 110, right: 20),
              child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  title: Text(S.of(context).my_orders,
                      style: TextStyle(
                          color: const Color(0xFF6244E8),
                          fontSize: TextSize.ICON_COMMUNITY_HEIGHT,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold))),
            ),
            getAreas()
          ],
        )));
  }

  Widget getAreas() {
    if (details == null) {
      if(details == null) {
        return Container(height: 80,
        child: Text("No Orders found", style: TextStyle(fontSize: 25),),
        padding: EdgeInsets.only(top: 40),);
      }
      return CircularLoadingWidget(height: 50);
    }
    if (details.isEmpty) {
      return Container(
        child: Text("No Data"),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      );
    }
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: details.length,
        itemBuilder: (context, index) {
          return OrderListingChildWidget(details[index],pageBar: widget.pageBar);
        },
      ),
    );
  }
}
