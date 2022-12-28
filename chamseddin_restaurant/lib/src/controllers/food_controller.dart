import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/Meals.dart';
import '../models/banners.dart';
import '../models/cart.dart';
import '../models/category.dart';
import '../models/food.dart';
import '../models/restaurant.dart';
import '../repository/cart_repository.dart';

class FoodController extends ControllerMVC {
  Food food;
  double quantity = 1;
  double total = 0;
  List<Cart> carts = [];
  Banners banner;
  bool loadCart = false;
  GlobalKey<ScaffoldState> scaffoldKey;

  FoodController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForCart() async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      carts.add(_cart);
    });
  }

  bool isSameRestaurants(Food food) {
    if (carts.isNotEmpty) {
      return carts[0].food?.restaurant?.id == food.restaurant?.id;
    }
    return true;
  }

  // void
  // addMealToCart(Meal meal, {bool reset = false}) async {
  //   Food food = new Food();
  //   food.id = meal.id.toString();
  //   food.name = meal.name;
  //   food.price = meal.price as double;
  //   food.discountPrice = meal.price as double;
  //   Restaurant restaurant = new Restaurant();
  //   restaurant.name = meal.restaurantName;
  //   food.restaurant = restaurant;
  //   Category category = new Category();
  //   category.name = meal.category;
  //   food.category = category;
  //   addToCart(food, reset: reset);
  // }

  // void addToCart(Food food, {bool reset = false}) async {
  //   setState(() {
  //     this.loadCart = true;
  //   });
  //   var _newCart = new Cart();
  //   _newCart.food = food;
  //   // _newCart.extras = food.extras.where((element) => element.checked).toList();
  //   _newCart.quantity = this.quantity;
  //   // if food exist in the cart then increment quantity
  //   var _oldCart = isExistInCart(_newCart);
  //   if (_oldCart != null) {
  //     _oldCart.quantity += this.quantity;
  //     updateCart(_oldCart).then((value) {
  //       setState(() {
  //         this.loadCart = false;
  //       });
  //     }).whenComplete(() {
  //       scaffoldKey?.currentState?.showSnackBar(SnackBar(
  //         content: Text(S.of(context).this_food_was_added_to_cart),
  //       ));
  //     });
  //   } else {
  //     // the food doesnt exist in the cart add new one
  //     addCart(_newCart, reset).then((value) {
  //       setState(() {
  //         this.loadCart = false;
  //       });
  //     }).whenComplete(() {
  //       scaffoldKey?.currentState?.showSnackBar(SnackBar(
  //         content: Text(S.of(context).this_food_was_added_to_cart),
  //       ));
  //     });
  //   }
  // }

  Cart isExistInCart(Cart _cart) {
    return carts.firstWhere((Cart oldCart) => _cart.isSame(oldCart),
        orElse: () => null);
  }

  void calculateTotal() {
    total = food?.price ?? 0;
    total *= quantity;
    setState(() {});
  }

  incrementQuantity() {
    if (this.quantity <= 99) {
      ++this.quantity;
      calculateTotal();
    }
  }

  decrementQuantity() {
    if (this.quantity > 1) {
      --this.quantity;
      calculateTotal();
    }
  }

}
