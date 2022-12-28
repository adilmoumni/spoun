import 'dart:convert';

import 'package:food_delivery_app/src/models/restaurant_rating_request.dart';

class CartDiscountArguments {
  List<GetDiscountRequest> code;

  CartDiscountArguments({this.code});

  CartDiscountArguments.fromJson(Map<String, dynamic> json) {
    if (json['code'] != null) {
      code = new List<GetDiscountRequest>();
      json['restaurant_detail'].forEach((v) {
        code.add(new GetDiscountRequest.fromJson(v));
      });
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['code'] = code != null ? json.encode(code) : null;
    return map;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.code != null) {
      data['code'] = this.code.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetDiscountRequest {
  int restaurantId;
  String promoCode;

  GetDiscountRequest({this.restaurantId, this.promoCode});

  GetDiscountRequest.fromJson(Map<String, dynamic> json) {
    restaurantId = json['restaurant_id'];
    promoCode = json['promo_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurant_id'] = this.restaurantId;
    data['promo_code'] = this.promoCode;
    return data;
  }
}
