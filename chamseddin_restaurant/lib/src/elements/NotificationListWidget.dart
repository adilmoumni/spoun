import 'package:badges/badges.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/generated/l10n.dart';
import 'package:food_delivery_app/src/elements/NotificationListChildWidget.dart';
import 'package:food_delivery_app/src/helpers/common_methods.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';
import 'package:food_delivery_app/src/pages/pages.dart';
import '../TextSize.dart';
import '../constants.dart';
import '../models/notification_response.dart';
import 'CircularLoadingWidget.dart';

class NotificationListingWidget extends StatefulWidget {
  PageBar pageBar;

  NotificationListingWidget({Key key, this.pageBar}) : super(key: key);
  @override
  NotificationListingWidgetState createState() =>
      NotificationListingWidgetState();
}

class NotificationListingWidgetState extends State<NotificationListingWidget> {
  Response response;
  NotificationListResponse notificationListResponse;
  int cartCount;

  Future<String> getData() async {
    CommonMethods.getNotifications().then((value) {
      notificationListResponse = value;
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
    CommonMethods.getCartCount();
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
          return PagesWidget(currentTab: 0,);
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
              leading: IconButton(
                onPressed: () => Navigator.of(context).pushNamed('/Pages', arguments: 0),
                icon: Icon(Icons.arrow_back),
                color: Colors.black26,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
//          actions: [
//            IconButton(icon: Icon(Icons.notifications), onPressed: null)
//          ],
            ),
//        bottomNavigationBar: Row(
//          children: [
//            Container(
//              height: TextSize.ADDRESS_ALERT_TOP,
////              color: Colors.black26,
//              child: InkWell(
//                onTap: () {
//                  Navigator.of(context).pushNamed('/Pages');
//                },
//                child: Padding(
//                  padding: EdgeInsets.only(top: TextSize.PADDING, left: TextSize.SIZED_BOX_HEIGHT),
//                  child: Column(
//                    children: [
//                      Icon(
//                        Icons.home,
//                        color: Colors.grey,
//                      size: 24,
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//            ),
//            Container(
//              height: TextSize.ADDRESS_ALERT_TOP,
////              color: Colors.black26,
//              child: InkWell(
//                onTap: () {
//                  Navigator.of(context).pushNamed('/Pages', arguments: 1);
//                },
//                child: Padding(
//                  padding: EdgeInsets.only(top: TextSize.PADDING, left: TextSize.ADD_PIC_HEIGHT),
//                  child: Column(
//                    children: [
//                      cartCount != null && cartCount > 0
//                          ? Badge(
//                        badgeContent: Text(
//                          cartCount.toString(),
//                          style: TextStyle(color: Colors.white),
//                        ),
//                        child: Icon(Icons.shopping_cart,
//                                color: Colors.grey, size: 24),
//                        badgeColor: Colors.deepPurpleAccent,
//                      )
//                           : Icon(Icons.shopping_cart,
//                            color: Colors.grey, size: 24),
//                    ],
//                  ),
//                ),
//              ),
//            ),
//            Container(
//              height: TextSize.ADDRESS_ALERT_TOP,
////              color: Colors.black26,
//              child: InkWell(
//                onTap: () {
//                  Navigator.of(context).pushNamed('/Pages', arguments: 2);
//                },
//                child: Padding(
//                  padding: EdgeInsets.only(top: TextSize.PADDING, left: TextSize.ADD_PIC_HEIGHT),
//                  child: Column(
//                    children: [
//                      Icon(
//                        Icons.favorite,
//                        color: Colors.grey,
//                      size: 24,
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//            ),
//            Container(
//              height: TextSize.ADDRESS_ALERT_TOP,
////              color: Colors.black26,
//              child: InkWell(
//                onTap: () {
//                  Navigator.of(context).pushNamed('/Pages', arguments: 3);
//                },
//                child: Padding(
//                  padding: EdgeInsets.only(top: TextSize.PADDING, left: TextSize.PAYMENT_MM_WIDTH),
//                  child: Column(
//                    children: [
//                      Icon(
//                        Icons.person,
//                        color: Colors.grey,
//                      size: 24,
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//            ),
//          ],
//        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0, left: 130, right: 20),
              child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  title: Text(S.of(context).notifications,
                      style: TextStyle(
                          color: const Color(0xFF6244E8),
                          fontSize: TextSize.TEXT1,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold))),
            ),
            showNotificationsWidget()
          ],
        )));
  }

  Widget showNotificationsWidget() {
    if (notificationListResponse == null ||
        notificationListResponse.response == null) {
      return CircularLoadingWidget(height: 50);
    }
    if (notificationListResponse.response.data == null ||
        notificationListResponse.response.data.isEmpty) {
      return Container(
        child: Text("No notifications yet!"),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      );
    }
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: notificationListResponse.response.data.length,
        itemBuilder: (context, index) {
          return NotificationListingChildWidget(
              notificationListResponse.response.data[index], pageBar: widget.pageBar,);
        },
      ),
    );
  }
}
