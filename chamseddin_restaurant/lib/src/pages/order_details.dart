import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_delivery_app/generated/l10n.dart';
import 'package:food_delivery_app/session_manager.dart';
import 'package:food_delivery_app/src/helpers/custom_trace.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';
import 'package:food_delivery_app/src/models/last_order_request.dart';
import 'package:food_delivery_app/src/models/last_order_response.dart';
import 'package:food_delivery_app/src/pages/pages.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:open_file/open_file.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:url_launcher/url_launcher.dart';

import '../TextSize.dart';
import '../constants.dart';
import '../controllers/order_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/NotificationListWidget.dart';
import '../helpers/common_methods.dart';
import '../models/add_on.dart';
import '../models/order_detail_arguments.dart';
import '../models/order_details_response.dart';
import '../repository/order_repository.dart';

class OrderDetailsWidget extends StatefulWidget {
  final OrderDetailsArguments orderDetailsArguments;
  PageBar pageBar;

  OrderDetailsWidget(this.orderDetailsArguments, {Key key, this.pageBar})
      : super(key: key);

  @override
  _OrderDetailsWidgetState createState() => _OrderDetailsWidgetState();
}

class _OrderDetailsWidgetState extends StateMVC<OrderDetailsWidget> {
  OrderController _con;
  OrderDetailsResponse orderDetailsResponse;
  LastOrderResponse lastOrderResponse;
  int cartCount;
  int notificationsCount;
  Detail detail;
  TextEditingController ratingController = TextEditingController();

  void _onRated(double rating) {
    this.ratingController.text = rating.toString();
    print("Rating: " + rating.toString());
  }

  getData() {
    getOrderDetails(widget.orderDetailsArguments.orderId).then((response) {
      if (response.statusCode == 200 || response.statusCode == 202) {
        print(response.body);
        orderDetailsResponse =
            OrderDetailsResponse.fromJson(jsonDecode(response.body));
        setState(() {});
      } else {
        orderDetailsResponse = new OrderDetailsResponse();
        print(
            CustomTrace(StackTrace.current, message: response.body).toString());
        _con.scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text(response.body)));
      }
    });
  }

  getLastOrder() {
    lastOrder(widget.orderDetailsArguments.orderId).then((response) {
      if (response.statusCode == 200 || response.statusCode == 202) {
        print(response.body);
        lastOrderResponse =
            LastOrderResponse.fromJson(jsonDecode(response.body));

        setState(() {});
      } else {
        lastOrderResponse = new LastOrderResponse();
        print(
            CustomTrace(StackTrace.current, message: response.body).toString());
      }
    });
  }

  _OrderDetailsWidgetState() : super(OrderController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();

    ///
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
    if (widget.orderDetailsArguments.notificationId != null) {
      markNotificationRead(widget.orderDetailsArguments.notificationId);
    }
    getData();
    Timer.periodic(Duration(seconds: 15), (Timer t) => getData());

    //getData();
    getLastOrder();
  }

//  _launchURL() async {
//     String url = orderDetailsResponse.response.data.first.pdfUrl;
//    if (await canLaunch(url)) {
//      await launch(url);
//    } else {
//      throw 'Could not launch $url';
//    }
//  }

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: 350.0,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: 20, left: 40, right: 30, bottom: 20),
                      child: new Text(
                        "Share your last dining experience at \n " +
                            orderDetailsResponse.response.data.first.diningName,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: lastOrderResponse
                            .response.data.first.restaurantDetail.length,
                        itemBuilder: (context, index) {
                          return getRestaurantDetail(lastOrderResponse
                              .response.data.first.restaurantDetail[index]);
                        },
                      ),
                    ),
                    ButtonTheme(
                      minWidth: 50,
                      height: 35,
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 140, right: 140, top: 20),
                        child: FlatButton(
                          color: const Color(0xFF6244E8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: const Color(0xFF6244E8))),
                          child: new Text("Submit",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Montserrat-Bold',
                              )),
                          onPressed: () {
                            _con.restaurantRating(
                                context,
                                lastOrderResponse.response.data.first
                                    .restaurantDetail.first.restaurantId,
                                double.parse(ratingController.text),
                                lastOrderResponse.response.data.first
                                    .restaurantDetail.first.orderId);
                            Future.delayed(
                              Duration(seconds: 3),
                            );
                            setState(() {
                              Navigator.pop(context);
                            });

                            print(S.of(context).orderId +
                                " :::: " +
                                lastOrderResponse.response.data.first
                                    .restaurantDetail.first.orderId
                                    .toString());
                            print("Rating ::::" + ratingController.text);
                            print("Restaurant ID :::: " +
                                lastOrderResponse.response.data.first
                                    .restaurantDetail.first.restaurantId
                                    .toString());
                          },
                        ),
                      ),
                    ),
                  ],
                )),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    FBroadcast.instance().unregister(this);
  }

  Future<bool> _onWillPop() async {
    await widget.pageBar.orderListing('orderListing');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          widget.pageBar.orderListing('orderListing');
        },
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
                          widget.pageBar.orderListing('orderListing');
                        },
                        child: Padding(
                            padding: const EdgeInsets.only(right: 8, left: 10),
                            child:  Icon(Platform.isAndroid
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
          key: _con.scaffoldKey,
          resizeToAvoidBottomInset: true,
          body: getDataWidget(),
        ));
  }

  getDataWidget() {
    return orderDetailsResponse == null
        ? CircularLoadingWidget(height: 50)
        : orderDetailsResponse.response == null ||
                orderDetailsResponse.response.data == null ||
                orderDetailsResponse.response.data.isEmpty
            ? Center(child: Text('Order Details not found'))
            : SingleChildScrollView(
                child: Container(
                child: Container(
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(vertical: 0),
                    children: <Widget>[
                      Center(
                        child: Text(S.of(context).orderDetails,
                            style: TextStyle(
                                color: const Color(0xFF6244E8),
                                fontSize: TextSize.TEXT2,
                                fontFamily: 'Montserrat-Bold',
                                fontWeight: FontWeight.bold)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonTheme(
                            minWidth: 20,
                            height: 25,
                            child: FlatButton(
                              color: const Color(0xFF6244E8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                      color: const Color(0xFF6244E8))),
                              child: new Text(S.of(context).showQrCode,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: TextSize.SOCIAL_PADDING_SIZE,
                                    fontFamily: 'Montserrat-Bold',
                                  )),
                              onPressed: () {
                                widget.pageBar
                                    .showQrCode(orderDetailsResponse);
//                              Navigator.of(context).pushNamed('/QRCode', arguments: orderDetailsResponse);
                              },
                            ),
                          ),
                          SizedBox(width:4,height: 4),
                          ButtonTheme(
                            minWidth: 20,
                            height: 25,
                            child: FlatButton(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                      color: const Color(0xFF6244E8))),
                              child: new Text(S.of(context).rateDiner,
                                  style: TextStyle(
                                    color: const Color(0xFF6244E8),
                                    fontSize: TextSize.SOCIAL_PADDING_SIZE,
                                    fontFamily: 'Montserrat-Bold',
                                  )),
                              onPressed: () {
                                getLastOrder();
//                                lastOrder(widget.orderDetailsArguments.orderId);
                                _modalBottomSheetMenu();
//                            widget.pageBar.showQrCode(orderDetailsResponse);
//                              Navigator.of(context).pushNamed('/QRCode', arguments: orderDetailsResponse);
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 10, top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                S.of(context).orderId +
                                    " : #" +
                                    orderDetailsResponse
                                        .response.data.first.orderId
                                        .toString(),
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 20,
                                    fontFamily: 'Montserrat-Bold',
                                    fontWeight: FontWeight.bold)),
                            Text(
                                DateFormat("MMM dd'th at' hh:mm aa").format(
                                    DateTime.parse(orderDetailsResponse
                                        .response.data.first.createdAt)),
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontFamily: 'Montserrat-Bold',
                                )),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: orderDetailsResponse
                            .response.data.first.detail.length,
                        itemBuilder: (context, index) {
                          print(
                              "DONE: promo ${orderDetailsResponse.response.data.first.detail[index].discount}");

                          return getRestaurantDetails(orderDetailsResponse
                              .response.data.first.detail[index]);
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 20, bottom: 20, left: 20, right: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.grey[300]),
                        child: Padding(
                          padding:
                              EdgeInsets.only(top: 10, left: 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: TextSize.PIC_DOUBLE_HEIGHT,
                                      bottom: 20),
                                  child: Text(
                                    S.of(context).final_payment,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black38,
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                              Padding(
                                padding: EdgeInsets.only(
                                  right: 40,
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 40),
                                      child: Text(
                                        S.of(context).restaurant_total,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black38,
                                        ),
                                      ),
                                    ),
                                    Spacer(
                                      flex: 2,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 40),
                                      child: orderDetailsResponse.response.data
                                                  .first.restaurantTotal ==
                                              null
                                          ? Text(
                                              'N/A',
                                              style: TextStyle(
                                                color: Colors.black38,
                                              ),
                                            )
                                          : Text(
                                              orderDetailsResponse.response.data
                                                      .first.restaurantTotal
                                                      .toString() +
                                                  orderDetailsResponse
                                                      .response
                                                      .data
                                                      .first
                                                      .currencySymbol,
                                              style: TextStyle(
                                                color: Colors.black38,
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 10, right: 40),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 0),
                                        child: Text(
                                          S.of(context).vat,
                                          style: TextStyle(
                                            color: Colors.black38,
                                          ),
                                        ),
                                      ),
                                      Spacer(
                                        flex: 1,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 40),
                                        child: orderDetailsResponse
                                                    .response.data.first.vat ==
                                                null
                                            ? Text(
                                                "N/A",
                                                style: TextStyle(
                                                  color: Colors.black38,
                                                ),
                                              )
                                            : Text(
                                                orderDetailsResponse.response
                                                        .data.first.vat +
                                                    orderDetailsResponse
                                                        .response
                                                        .data
                                                        .first
                                                        .currencySymbol,
                                                style: TextStyle(
                                                  color: Colors.black38,
                                                ),
                                              ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(top: 10, right: 40),
                                  child: Row(
                                    children: [
                                      Text(
                                        S.of(context).service_fee,
                                        style: TextStyle(
                                          color: Colors.black38,
                                        ),
                                      ),
                                      Spacer(
                                        flex: 3,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 40),
                                        child: orderDetailsResponse.response
                                                    .data.first.serviceFee ==
                                                null
                                            ? Text(
                                                "N/A",
                                                style: TextStyle(
                                                  color: Colors.black38,
                                                ),
                                              )
                                            : Text(
                                                orderDetailsResponse.response
                                                        .data.first.serviceFee
                                                        .toString() +
                                                    orderDetailsResponse
                                                        .response
                                                        .data
                                                        .first
                                                        .currencySymbol,
                                                style: TextStyle(
                                                  color: Colors.black38,
                                                ),
                                              ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 10, right: 40, bottom: 10),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 0),
                                      child: Text(
                                        S.of(context).totalPayment,
                                        style: TextStyle(
                                          color: Colors.black38,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: EdgeInsets.only(right: 40),
                                      child: Text(
                                        orderDetailsResponse
                                                .response.data.first.totalPrice
                                                .toString() +
                                            orderDetailsResponse.response.data
                                                .first.currencySymbol,
                                        style: TextStyle(
                                          color: Colors.black38,
                                        ),
                                      ),
                                    ),
//                                  Spacer(),
//                                  ButtonTheme(
//                                    minWidth: 50,
//                                    height: 25,
//                                    child: OutlineButton(
//                                        child: new Text("View PDF invoice",
//                                            style: TextStyle(
//                                                color: const Color(0xFF6244E8),
//                                                fontSize: 12,
//                                                fontFamily: 'Montserrat-Bold',
//                                                fontWeight: FontWeight.bold)),
//                                        onPressed: () {
//                                          _launchURL();
//                                        },
//                                        borderSide: BorderSide(
//                                            color: const Color(0xFF6244E8),
//                                            width: 1,
//                                            style: BorderStyle.solid),
//                                        shape: new RoundedRectangleBorder(
//                                            borderRadius:
//                                                new BorderRadius.circular(
//                                                    30.0))),
//                                  ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }

  Widget getFoodDetailsWidget(Detail detail) {
    List<Widget> columnContent = [];
    if (detail != null) {
      if (detail.food != null && detail.food.isNotEmpty) {
        for (var food in detail.food) {
          columnContent.add(
            Padding(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
              child: getFoodDetails(food),
            ),
          );
        }
      }
    }
    if (detail.discount > 0) {
      columnContent.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 20, right: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Discount:',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.black38,
                      fontSize: 14,
                      fontFamily: 'Montserrat-Bold',
                      fontWeight: FontWeight.bold)),
              Spacer(),
              Text(
                '${detail.discount.toString()} ' +
                    orderDetailsResponse.response.data.first.currencySymbol,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                textAlign: TextAlign.end,
              )
            ],
          ),
        ),
      );
    }
    return Column(
      children: columnContent,
    );
  }

  Widget getFoodItemsWidget(Items content) {
    List<Widget> columnContent = [];
    if (content != null) {
      if (content.recipe != null && content.recipe.isNotEmpty) {
        for (var recipe in content.recipe) {
          columnContent.add(
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: recipe.quantity > 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          recipe.name ?? '',
                          style: TextStyle(
                              fontSize: 15, fontStyle: FontStyle.italic),
                        ),
                        Spacer(),
                        Text(
                          recipe.price.toString() +
                              orderDetailsResponse
                                  .response.data.first.currencySymbol,
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    )
                  : Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'No ${recipe.name}' ?? '',
                        style: TextStyle(
                            fontSize: 18, fontStyle: FontStyle.italic),
                      ),
                    ),
            ),
          );
        }
      }
      if (content.list != null && content.list.isNotEmpty) {
        for (var choice in content.list) {
          columnContent.add(
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '. ${choice.name}' ?? '',
                    style: TextStyle(fontSize: 15),
                  ),
                  Spacer(),
                  Text(
                    choice.price.toString() +
                        orderDetailsResponse.response.data.first.currencySymbol,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            ),
          );
        }
      }
    }
    return Column(
      children: columnContent,
    );
  }

  int getFoodItemsCount(Food food) {
    int totalItemsCount = 0;

    if (food.items != null && food.items.isNotEmpty) {
      totalItemsCount += food.items.length;
    }
    return totalItemsCount;
  }

  getRestaurantDetails(Detail detail) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(left: 30, right: 60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(detail.restaurant,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: TextSize.BUTTON,
                    fontFamily: 'Montserrat-Bold',
                    fontWeight: FontWeight.bold)),
            Padding(padding: EdgeInsets.only(left: 0)),
//            IconButton(
//                icon: Image.asset(
//                  "assets/img/thumbUp.png",
//                  color: null,
//                ),
//                onPressed: null),
//            IconButton(
//                icon: Image.asset(
//                  "assets/img/thumbDown.png",
//                  color: null,
//                ),
//                onPressed: null)
          ],
        ),
      ),
      Padding(
        padding:
            const EdgeInsets.only(top: 8.0, bottom: 8, right: 20, left: 20),
        // oyee
        child: new LinearPercentIndicator(
          lineHeight: 10.0,
          percent: detail.complete_percentage / 100,
          backgroundColor: Colors.black12,
          progressColor: Colors.green,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(top: 5, left: 25, right: 25),
        child: Text(detail.status,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.black54,
                fontSize: 13,
                fontFamily: 'Montserrat-Bold',
                fontStyle: FontStyle.italic)),
      ),
      Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: 25, bottom: 5, right: 25),
        child: detail.waitingTime == null
            ? (detail.status == "REJECTED" || detail.status == "COLLECTED")
                ? Text("")
                : Text('Estimated collect time : Please check in a while',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                        fontFamily: 'Montserrat-Bold',
                        fontStyle: FontStyle.italic))
            : Text('Estimated collect time : ' + detail.waitingTime.toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    fontFamily: 'Montserrat-Bold',
                    fontStyle: FontStyle.italic)),
      ),
      Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: [
            Text("+ " + S.of(context).orderDetails,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black38,
                    fontSize: 18,
                    fontFamily: 'Montserrat-Bold',
                    fontWeight: FontWeight.bold)),
            Spacer(),
            ButtonTheme(
              minWidth: 50,
              height: 25,
              child: FlatButton(
                color: const Color(0xFF6244E8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: const Color(0xFF6244E8))),
                child: new Text(S.of(context).orderAgain,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Montserrat-Bold',
                    )),
                onPressed: () {
                  _con.orderAgain(
                      context,
                      orderDetailsResponse.response.data.first.orderId
                          .toString());
                },
              ),
            ),
          ],
        ),
      ),
      getFoodDetailsWidget(detail),
      Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Divider(
                color: Colors.black54,
              ),
              Row(
                children: [
                  Text(
                    "Total " + detail.restaurant,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: TextSize.PADDING_lOW_SIZE,
                        color: Colors.black38),
                  ),
                  Spacer(),
                  Text(
                    detail.restaurantPrice.toString() +
                        orderDetailsResponse.response.data.first.currencySymbol,
                    style: TextStyle(
                        color: Colors.black38,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  ButtonTheme(
                    minWidth: 50,
                    height: 25,
                    child: OutlineButton(
                        child: new Text(S.of(context).reportIssue,
                            style: TextStyle(
                                color: const Color(0xFF6244E8),
                                fontSize: 12,
                                fontFamily: 'Montserrat-Bold',
                                fontWeight: FontWeight.bold)),
                        onPressed: () {
//                          Navigator.of(context).pushNamed('/AskForDispute', arguments: detail);
                          widget.pageBar.dispute(detail);
                        },
                        borderSide: BorderSide(
                            color: const Color(0xFF6244E8),
                            width: 1,
                            style: BorderStyle.solid),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0))),
                  ),
                ],
              )
            ],
          ))
    ]);
  }

  getRestaurantDetail(RestaurantDetail detail) {
    double rating = 0.0;
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 60, top: 10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          child: CachedNetworkImage(
                            width: TextSize.ADD_PIC_WIDTH,
                            height: TextSize.ADD_PIC_WIDTH,
                            fit: BoxFit.cover,
                            imageUrl: detail.image == null
                                ? 'http://chamseddinprod.n1.iworklab.com/images/restaurant_image/rest1.jpeg'
                                : detail.image,
                            placeholder: (context, url) =>
                                CircularLoadingWidget(height: 50),
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                          ))),
                  Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Column(
                        children: [
                          Text("How was " + detail.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: TextSize.LOGO_PADDING_SIZE,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold)),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: SmoothStarRating(
                              rating: lastOrderResponse.response.data.first
                                          .restaurantDetail.first.rate ==
                                      null
                                  ? 0.0
                                  : lastOrderResponse.response.data.first
                                      .restaurantDetail.first.rate
                                      .toDouble(),
                              isReadOnly: false,
                              size: 40,
                              filledIconData: Icons.star,
                              borderColor: Colors.deepPurpleAccent,
                              halfFilledIconData: Icons.star_half,
                              defaultIconData: Icons.star_border,
                              color: Colors.deepPurpleAccent,
                              starCount: 5,
                              allowHalfRating: true,
                              spacing: 1.0,
                              onRated: _onRated,
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ]),
      ),
    ]);
  }

  Widget getFoodDetails(Food food) {
    return Column(
      children: [
        Row(
          children: [
            Text(food.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black38,
                    fontSize: 14,
                    fontFamily: 'Montserrat-Bold',
                    fontWeight: FontWeight.bold)),
            Spacer(),
            Text(
              food.foodPrice.toString() +
                  orderDetailsResponse.response.data.first.currencySymbol,
              style: TextStyle(
                color: Colors.black38,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
//            IconButton(
//                icon: Image.asset(
//                  "assets/img/thumbUp.png",
//                  color: null,
//                ),
//                iconSize: 12.0,
//                onPressed: null),
//            IconButton(
//                icon: Image.asset(
//                  "assets/img/thumbDown.png",
//                  color: null,
//                ),
//                iconSize: 12.0,
//                onPressed: null)
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: getFoodItemsCount(food),
            itemBuilder: (context, index) {
              return getFoodItemsWidget(food.items[index]);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 20),
          child: food.addOn == null
              ? Text('')
              : Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        food.addOn.length > 1 ? 'Add Ons' : 'Add On',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                            fontStyle: FontStyle.normal,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                    getAddOnsWidget(food.addOn),
                  ],
                ),
        )
      ],
    );
  }

  Widget getAddOnsWidget(List<AddOn> addOns) {
    List<Widget> columnContent = [];
    if (addOns != null && addOns.isNotEmpty) {
      for (var addOn in addOns) {
        columnContent.add(
          Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
            child: getAddOnWidget(addOn),
          ),
        );
      }
    }
    return Column(
      children: columnContent,
    );
  }

  Widget getAddOnWidget(AddOn addOn) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '. ${addOn.name}' ?? '',
          style: TextStyle(fontSize: 16),
        ),
        Spacer(),
        Text(
          addOn.price.toString() +
              orderDetailsResponse.response.data.first.currencySymbol,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          textAlign: TextAlign.end,
        ),
      ],
    );
  }
}
