import 'dart:convert';

import 'add_on.dart';
import 'cart_list.dart';
import 'recipe.dart';

class AddMealToCartRequest {
  String type = 'meal';
  List<Item> items;
  List<AddOn> add_on;
  int menu_id;
  int quantity;
  int restaurant_id;
  String price;
  int resetCart = 0;
  int cart_id = 0;

  AddMealToCartRequest(
      {this.quantity,
      this.items,
      this.add_on,
      this.price,
      this.restaurant_id,
      this.menu_id,
      this.cart_id,
      this.resetCart});

  AddMealToCartRequest.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    quantity = json['quantity'];
    items = json['items'];
    add_on = json['add_on'];
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
    map['items'] = items != null ? json.encode(items) : null;
    map['add_on'] = add_on != null ? json.encode(add_on) : null;

        //price;
    if(price!=null)
      {
        map['price'] = price;
      }

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

class Item {
  int item_id;
  List<Recipe> recipe;
  List<CartList> list;

  Item({
    this.item_id,
    this.recipe,
  });

  Item.fromJson(Map<String, dynamic> json) {
    item_id = json['item_id'];
    recipe = json['recipe'];
    list = json['list'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_id'] = this.item_id;
    data['recipe'] = this.recipe;
    data['list'] = list;
    return data;
  }
}
