import 'dart:convert';

import 'package:food_delivery_app/src/models/restaurant_rating_request.dart';

class RestaurantRatingArguments {

  List<RestaurantRatingRequest> myRating;

  RestaurantRatingArguments({this.myRating});

  RestaurantRatingArguments.fromJson(Map<String, dynamic> json) {
    if (json['myRating'] != null) {
      myRating = new List<RestaurantRatingRequest>();
      json['restaurant_detail'].forEach((v) {
        myRating.add(new RestaurantRatingRequest.fromJson(v));
      });
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['myRating'] = myRating != null ? json.encode(myRating) : null;
    return map;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.myRating != null) {
      data['myRating'] =
          this.myRating.map((v) => v.toJson()).toList();
    }
    return data;
  }
}




class RestaurantRatingRequest {
  int restaurantId;
  dynamic restaurantRating;
  int orderId;

  RestaurantRatingRequest(
      {this.restaurantId, this.restaurantRating, this.orderId});

  RestaurantRatingRequest.fromJson(Map<String, dynamic> json) {
    restaurantId = json['restaurant_id'];
    restaurantRating = json['restaurant_rating'];
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurant_id'] = this.restaurantId;
    data['restaurant_rating'] = this.restaurantRating;
    data['order_id'] = this.orderId;
    return data;
  }
}