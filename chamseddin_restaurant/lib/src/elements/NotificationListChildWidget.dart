import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/TextSize.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';
import 'package:food_delivery_app/src/models/order_detail_arguments.dart';

import '../models/notification_response.dart';

class NotificationListingChildWidget extends StatefulWidget {
  final Data notification;
  NotificationListResponse notificationListResponse;
  PageBar pageBar;

  NotificationListingChildWidget(this.notification,{Key key, this.pageBar}) : super(key: key);

  @override
  _NotificationListingChildWidgetState createState() =>
      _NotificationListingChildWidgetState();
}

class _NotificationListingChildWidgetState
    extends State<NotificationListingChildWidget> {
  _NotificationListingChildWidgetState() {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          var orderDetailsArguments = new OrderDetailsArguments(
              widget.notification.orderId.toString(),
              widget.notification.id.toString());
          widget.pageBar.orderDetails(orderDetailsArguments);
//          Navigator.of(context)
//              .pushNamed('/OrderDetails', arguments: orderDetailsArguments);
        },
        child: Container(
            width: TextSize.PRODUCT_IMAGE_WIDTH,
//        height: TextSize.SELLER_PIC_WIDTH,
            margin: EdgeInsets.only(
                left: TextSize.TEXT_PADDING, right: 5, top: 15, bottom: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).focusColor.withOpacity(0.1),
                    blurRadius: 15,
                    offset: Offset(0, 5)),
              ],
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 200,
                                    color: Colors.white54,
                                  ),
                                  Container(
                                    child: Text(
                                      widget.notification.restaurantName,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: const Color(0xFF6244E8),
                                      ),
                                      softWrap: false,
                                      overflow: TextOverflow.fade,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 50,
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.notification.notify,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                                widget.notification.read == 0
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                            color: widget.notification.read == 0
                                                ? const Color(0xFF6244E8)
                                                : Colors.grey,
                                            fontFamily: 'Montserrat-Bold'),
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ]
            )
        )
    );
  }
}
