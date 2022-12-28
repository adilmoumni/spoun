import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/generated/l10n.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../TextSize.dart';
import '../controllers/cart_controller.dart';
import '../elements/CartItemWidget.dart';
import '../elements/EmptyCartWidget.dart';
import '../elements/PreferredMealsCartWidget.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';

class CartWidget extends StatefulWidget {
  final RouteArgument routeArgument;
  GlobalKey<ScaffoldState> parentScaffoldKey;

   CartWidget({Key key, this.routeArgument, this.parentScaffoldKey})
      : super(key: key);

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends StateMVC<CartWidget> {
  CartController _con;

  _CartWidgetState() : super(CartController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
      child: Scaffold(
        key: _con.scaffoldKey,
        bottomNavigationBar: RaisedButton(
          child: Text(S.of(context).select_payment_method_to_place_order),
          onPressed: () {
            Navigator.of(context)
                .pushNamed('/PaymentScreen', arguments: widget.routeArgument);
          },
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              if (widget.routeArgument != null) {
                Navigator.of(context).pushReplacementNamed(
                    widget.routeArgument.param,
                    arguments: RouteArgument(id: widget.routeArgument.id));
              } else {
                Navigator.of(context)
                    .pushReplacementNamed('/Pages', arguments: 0);
              }
            },
            icon:  Icon(Platform.isAndroid
                ? Icons.arrow_back
                : Icons.arrow_back_ios_sharp),
            color: Colors.black26,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: _con.refreshCarts,
          child: _con.carts.isEmpty
              ? EmptyCartWidget()
              : Container(
                  child: ListView(
                    padding: EdgeInsets.symmetric(vertical: 0),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 110, right: 10),
                        child: Padding(
                            child: Text('Check Out',
                                style: TextStyle(
                                    color: const Color(0xFF6244E8),
                                    fontSize: TextSize.TEXT2,
                                    fontFamily: 'Montserrat-Bold',
                                    fontWeight: FontWeight.bold)),
                            padding: EdgeInsets.only(top: TextSize.TEXT1)),
                      ),
                      PreferredMealsCartWidget(
                          "Add Preferred Meals", null, null, null, null),
                      Padding(
                        padding: const EdgeInsets.only(left: 7, right: 10),
                        child: ListTile(
                          subtitle: Text(S.of(context).my_cart,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontFamily: 'Montserrat-Bold',
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 10),
                        child: Text("Name of the restaurant",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Montserrat-Bold',
                                fontWeight: FontWeight.bold)),
                      ),
                      ListView.separated(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: _con.carts.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 10);
                        },
                        itemBuilder: (context, index) {
                          return CartItemWidget(
                            cart: _con.carts.elementAt(index),
                            heroTag: 'cart',
                            increment: () {
                              _con.incrementQuantity(
                                  _con.carts.elementAt(index));
                            },
                            decrement: () {
                              _con.decrementQuantity(
                                  _con.carts.elementAt(index));
                            },
                            onDismissed: () {
                              _con.removeFromCart(_con.carts.elementAt(index));
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
