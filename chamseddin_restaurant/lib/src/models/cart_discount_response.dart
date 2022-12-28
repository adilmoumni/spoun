import 'package:food_delivery_app/src/models/add_on.dart';
import 'package:food_delivery_app/src/models/recipe.dart';

class GetCartDiscountResponse {
  Response response;

  GetCartDiscountResponse({this.response});

  GetCartDiscountResponse.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    return data;
  }
}

class Response {
  String message;
  Data data;
  int code;

  Response({this.message, this.data, this.code});

  Response.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['code'] = this.code;
    return data;
  }
}

class Data {
  List<RestaurantList> restaurantList;
  dynamic grandTotal;
  dynamic vat;
  String serviceFee;

  Data({this.restaurantList, this.grandTotal, this.vat, this.serviceFee});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['restaurant_list'] != null) {
      restaurantList = new List<RestaurantList>();
      json['restaurant_list'].forEach((v) {
        restaurantList.add(new RestaurantList.fromJson(v));
      });
    }
    grandTotal = json['grand_total'];
    vat = json['vat'];
    serviceFee = json['service_fee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.restaurantList != null) {
      data['restaurant_list'] =
          this.restaurantList.map((v) => v.toJson()).toList();
    }
    data['grand_total'] = this.grandTotal;
    data['vat'] = this.vat;
    data['service_fee'] = this.serviceFee;
    return data;
  }
}

class RestaurantList {
  String restaurantName;
  int restaurantId;
  List<FoodDetail> foodDetail;
  dynamic restTotal;
  var discount;
  int beforeDiscount;
  String promoResponse;
  int promoId;

  RestaurantList(
      {this.restaurantName,
        this.restaurantId,
        this.foodDetail,
        this.restTotal,
        this.discount,
        this.beforeDiscount,
        this.promoResponse,
        this.promoId});

  RestaurantList.fromJson(Map<String, dynamic> json) {
    restaurantName = json['restaurant_name'];
    restaurantId = json['restaurant_id'];
    if (json['food-detail'] != null) {
      foodDetail = new List<FoodDetail>();
      json['food-detail'].forEach((v) {
        foodDetail.add(new FoodDetail.fromJson(v));
      });
    }
    restTotal = json['rest_total'];
    discount = json['discount'];
    beforeDiscount = json['before_discount'];
    promoResponse = json['promo_response'];
    promoId = json['promo_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurant_name'] = this.restaurantName;
    data['restaurant_id'] = this.restaurantId;
    if (this.foodDetail != null) {
      data['food-detail'] = this.foodDetail.map((v) => v.toJson()).toList();
    }
    data['rest_total'] = this.restTotal;
    data['discount'] = this.discount;
    data['before_discount'] = this.beforeDiscount;
    data['promo_response'] = this.promoResponse;
    data['promo_id'] = this.promoId;
    return data;
  }
}

class FoodDetail {
  int cartId;
  int menuId;
  String name;
  List<dynamic> addon;
  List<dynamic> recipes;
  List<dynamic> lists;
  String price;
  int quantity;

  FoodDetail(
      {this.cartId,
        this.menuId,
        this.name,
        this.addon,
        this.recipes,
        this.lists,
        this.price,
        this.quantity});

  FoodDetail.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    menuId = json['menu_id'];
    name = json['name'];
    addon = json['addon'];
    recipes = json['recipes'];
    lists = json['lists'];
    price = json['price'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cart_id'] = this.cartId;
    data['menu_id'] = this.menuId;
    data['name'] = this.name;
    data['addon'] = this.addon;
    data['recipes'] = this.recipes;
    data['lists'] = this.lists;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    return data;
  }
}