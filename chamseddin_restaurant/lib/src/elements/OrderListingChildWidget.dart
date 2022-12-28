import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/generated/l10n.dart';
import 'package:food_delivery_app/src/TextSize.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';
import 'package:food_delivery_app/src/models/order_detail_arguments.dart';
import '../models/order_list_response.dart';
import 'CircularLoadingWidget.dart';

class OrderListingChildWidget extends StatefulWidget {
  final Data details;
  PageBar pageBar;

  OrderListingChildWidget(this.details, {Key key, this.pageBar})
      : super(key: key);

  @override
  _OrderListingChildWidgetState createState() =>
      _OrderListingChildWidgetState();
}

class _OrderListingChildWidgetState extends State<OrderListingChildWidget> {
  _OrderListingChildWidgetState() {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: TextSize.PRODUCT_IMAGE_WIDTH,
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                            CachedNetworkImage(
                              height: 150,
                              width: 400,
                              fit: BoxFit.fitWidth,
                              imageUrl: widget.details.diningImage ?? "",
                              placeholder: (context, url) =>
                                  CircularLoadingWidget(height: 50),
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                            ),
                            Container(
                              height: 150,
                              width: 400,
                              color: Colors.white54,
                            ),
                            Center(
                              child: Text(
                                widget.details.diningName ?? "",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF6244E8),
                                    fontFamily: 'Montserrat-Bold'),
                                overflow: TextOverflow.fade,
                                softWrap: false,
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(left: 10, top: 10)),
                        ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: (widget.details.detail != null &&
                                    widget.details.detail.isNotEmpty)
                                ? widget.details.detail.length
                                : 0,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Text(
                                    widget.details.detail[index].restaurant +
                                        ": " +
                                        widget.details.detail[index].status,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Spacer(),
                                  Text(
                                    widget.details.detail[index].price
                                            .toString() + widget.details.currencySymbol,
                                    style: TextStyle(color: Colors.black26),
                                  ),
                                ],
                              );
                            }),
                        Padding(padding: EdgeInsets.only(left: 5, top: 10)),
                        Flexible(
                            flex: 1,
                            child: Row(
                              children: [
                                Text(
                                  "Order ID: #" +
                                      widget.details.orderId.toString(),
                                  style: TextStyle(color: Colors.black26),
                                ),
                                Spacer(),
                                Text(
                                  widget.details.price.toString() + widget.details.currencySymbol,
                                  style: TextStyle(
                                    color: Colors.black26,
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.only(right: 0, left: 250),
                          child: ButtonTheme(
                            minWidth: 50,
                            height: 25,
                            child: OutlineButton(
                                child: new Text(S.of(context).viewDetails,
                                    style: TextStyle(
                                        color: const Color(0xFF6244E8),
                                        fontSize: TextSize.SOCIAL_PADDING_SIZE,
                                        fontFamily: 'Montserrat-Bold',
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  var orderDetailsArguments =
                                      new OrderDetailsArguments(
                                          widget.details.orderId.toString(),
                                          null);
//                                  Navigator.of(context).pushNamed(
//                                      '/OrderDetails',
//                                      arguments: orderDetailsArguments);
                                  widget.pageBar
                                      .orderDetails(orderDetailsArguments);
                                },
                                borderSide: BorderSide(
                                    color: const Color(0xFF6244E8),
                                    width: 1,
                                    style: BorderStyle.solid),
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
