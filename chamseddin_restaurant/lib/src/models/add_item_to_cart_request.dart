import 'dart:convert';

import 'cart_list.dart';
import 'recipe.dart';

class AddItemToCartRequest {
  String type = 'item';
  List<Recipe> recipe;
  List<CartList> list;
  int menu_id;
  int quantity;
  int restaurant_id;
  String price;
  int cart_id =0;
  int resetCart = 0;

  AddItemToCartRequest(
      {this.quantity,
      this.recipe,
      this.list,
      this.price,
      this.restaurant_id,
      this.menu_id,
      this.cart_id,
      this.resetCart});

  AddItemToCartRequest.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    quantity = json['quantity'];
    recipe = json['recipe'];
    list = json['list'];
    price = json['price'];
    restaurant_id = json['restaurant_id'];
    menu_id = json['menu_id'];
    cart_id = json['cart_id'];
    resetCart = json['reset'];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['type'] = type;
    map['quantity'] = quantity;
    map['recipe'] = recipe != null ? json.encode(recipe) : null;
    map['list'] = list != null ? json.encode(list) : null;
    map['price'] = price;
    map['restaurant_id'] = restaurant_id;
    map['menu_id'] = menu_id;
    if (cart_id > 0) {
      map['cart_id'] = cart_id;
    }
    if (resetCart == 1) {
      map['reset'] = resetCart;
    }
    return map;
  }
}
