import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/session_manager.dart';
import 'package:food_delivery_app/src/models/order_again_request.dart';
import 'package:food_delivery_app/src/models/restaurant_rating_arguments.dart';
//import 'package:food_delivery_app/src/models/restaurant_rating_request.dart';
import 'package:food_delivery_app/src/pages/view_cart_page.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../repository/order_repository.dart'as repository;

import '../models/order.dart';

class OrderController extends ControllerMVC {
  List<Order> orders = <Order>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  OrderAgainRequest orderAgainRequest = new OrderAgainRequest();
//  RestaurantRatingRequest restaurantRatingRequest;
  RestaurantRatingArguments restaurantRatingArguements;
//  List<RestaurantRatingRequest> myRating = <RestaurantRatingRequest> [];

  OrderController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void orderAgain(BuildContext context, String id) async {
    FocusScope.of(context).unfocus();
    orderAgainRequest.id = id;
    repository.orderAgain(orderAgainRequest).then((value) {
      if(value.response.code == 200) {
        Navigator.of(context).pushNamed('/Pages', arguments: 1);
        Flushbar(
//          title: value.response.message,
          message: "Order successfully added",
//          value.response.message,
          duration: Duration(seconds: 3),
        ).show(context);
      } else if (value.response.code == 202) {
        Flushbar(
//         title: value.response.message,
          message: value.response.message.toString(),
          duration: Duration(seconds: 3),
        ).show(context);
      }
    });
  }

  void restaurantRating(BuildContext context, int restaurantId, double restaurantRating, int orderId ) async {
    FocusScope.of(context).unfocus();
    RestaurantRatingRequest restaurantRatingRequest = RestaurantRatingRequest();
    restaurantRatingRequest.restaurantId = restaurantId;
    print("Restaurant ID :::::" +restaurantId.toString());
    restaurantRatingRequest.orderId = orderId;
    print("Order ID :::::" +orderId.toString());
    restaurantRatingRequest.restaurantRating = restaurantRating;
    print("Restaurant rating :::::" +restaurantRating.toString());

    List<RestaurantRatingRequest> argu=List();
    argu.add(restaurantRatingRequest);
    repository.restaurantRating(argu).then((value) {
      if(value.response.code == 200) {
        Flushbar(
          message: "Rated successfully",
          duration: Duration(seconds: 3),
        ).show(context);

      } else if (value.response.code == 202) {
        Flushbar(
          message: "Unable to rate restaurant",
          duration: Duration(seconds: 3),
        ).show(context);
      }
    });
  }

}
