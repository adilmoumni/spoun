import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/session_manager.dart';
import 'package:food_delivery_app/src/models/restaurant_rating_arguments.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../repository/order_repository.dart' as repository;
import '../helpers/Callback.dart';
import '../helpers/helper.dart';
import '../repository/settings_repository.dart';

class HomeController extends ControllerMVC {
  Callback callback;

  HomeController() {}

  void requestForCurrentLocation(BuildContext context) {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    setCurrentLocation().then((_address) async {
      deliveryAddress.value = _address;
      await refreshHome();
      loader.remove();
    }).catchError((e) {
      loader.remove();
    });
  }

  Future<void> refreshHome() async {}

  void restaurantRating(BuildContext context, int restaurantId,
      var restaurantRating, int orderId) async {
    FocusScope.of(context).unfocus();
    RestaurantRatingRequest restaurantRatingRequest = RestaurantRatingRequest();
    restaurantRatingRequest.restaurantId = restaurantId;
    print("Restaurant ID :::::" + restaurantId.toString());
    restaurantRatingRequest.orderId = orderId;
    print("Order ID :::::" + orderId.toString());
    restaurantRatingRequest.restaurantRating = restaurantRating;
    print("Restaurant rating :::::" + restaurantRating.toString());

    List<RestaurantRatingRequest> argu = List();
    argu.add(restaurantRatingRequest);
    repository.restaurantRating(argu).then((value) {
      if (value.response.code == 200) {
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
