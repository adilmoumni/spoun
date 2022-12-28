import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/helpers/common_methods.dart';
import 'package:food_delivery_app/src/models/cart_discount_arguments.dart';
import 'package:food_delivery_app/src/models/cart_discount_response.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:mvc_pattern/mvc_pattern.dart';
import '../helpers/custom_trace.dart';
import '../models/Meals.dart';
import '../models/add_item_to_cart_request.dart';
import '../models/add_meal_to_cart_request.dart';
import '../models/add_on.dart';
import '../models/add_to_cart_response.dart';
import '../models/add_to_fav_response.dart';
import '../models/cart_list.dart';
import '../models/choice.dart';
import '../models/delete_meal_from_cart_request.dart';
import '../models/get_favorites_response.dart';
import '../models/meal_details.dart';
import '../models/recipe.dart';
import '../models/restaurant.dart';
import '../models/user.dart';
import '../models/view_cart_response.dart';
import '../repository/food_repository.dart';
import '../repository/user_repository.dart' as userRepo;

class RestaurantController extends ControllerMVC {
  Restaurant restaurant;
  GlobalKey<ScaffoldState> scaffoldKey;

  RestaurantController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  Future<ViewCartResponse> getCart() async {
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return null;
    }
    final String _apiToken = 'api_token=${_user.apiToken}';
    final String url =
        '${GlobalConfiguration().getString('api_base_url')}carts?${_apiToken}';
    final client = new http.Client();
    // try {
    final response = await client.get(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    if (response.statusCode == 200) {
      return ViewCartResponse.fromJson(json.decode(response.body));
    } else if (response.statusCode == 202) {
      return null;
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
      return null;
    }
    // }
    // catch (e) {
    //   print(CustomTrace(StackTrace.current, message: e.toString()));
    //   return null;
    // }
  }

  Future<http.Response> getDiscountCart(List<GetDiscountRequest> argu) async {
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return null;
    }
    CartDiscountArguments cartDiscountArguments = CartDiscountArguments();
    cartDiscountArguments.code = argu;
    final String _apiToken = 'api_token=${_user.apiToken}';
    final String url =
        '${GlobalConfiguration().getString('api_base_url')}get_cart?${_apiToken}';
    print(url);
    final client = new http.Client();
    print(json.encode(cartDiscountArguments.toMap()));
    try {
      final response = await client.post(
        url,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: json.encode(cartDiscountArguments.toMap()),
      );
      print(json.encode(cartDiscountArguments.toMap()));
      if (response.statusCode == 200) {
        print("Success ::::" + response.body);
        return response;
      } else if (response.statusCode == 202) {
        print("Response" + response.body.toString());
        return null;
      } else {
        print(
            CustomTrace(StackTrace.current, message: response.body).toString());
        return null;
      }
    } catch (e) {
//      print(CustomTrace(StackTrace.current, message: e));
      return null;
    }
  }

  Future<AddToCartResponse> addMealToCart(

      BuildContext context,
      GlobalKey<ScaffoldState> globalKey,
      int cartId,
      int mealId,
      String price,
      List<Items> itemsList,
      List<AddOn> addOns,
      int restaurantId,
      int _itemCount,
      bool resetCart) async {
    print("addItemToCart--m----cartId--$cartId, mealId--$mealId, price--$price , _itemCount--$_itemCount,resetCart--$resetCart  ");

    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return null;
    }

    var itemsListRequest = null;
    if (itemsList != null && itemsList.isNotEmpty) {
      itemsListRequest = List<Item>();
      for (var items in itemsList) {
        Item itemRequest = new Item();
        itemRequest.item_id = items.itemId;
        List<CartList> cartList = getCartListForItem(items.list);
        List<Recipe> cartRecipes = getCartRecipeForItem(items.recipe);
        if (cartList != null && cartList.isNotEmpty) {
          itemRequest.list = cartList;
        }
        if (cartRecipes != null && cartRecipes.isNotEmpty) {
          itemRequest.recipe = cartRecipes;
        }
        if (itemRequest.list != null || itemRequest.recipe != null) {
          itemsListRequest.add(itemRequest);
        }
      }
    }
    var selectedAddons = List<AddOn>();
    if (addOns != null && addOns.isNotEmpty) {
      for (var addOn in addOns) {
        if (addOn.isSelected) {
          selectedAddons.add(addOn);
        }
      }
    }
    var request = AddMealToCartRequest(
      quantity: _itemCount,
      menu_id: mealId,
      price: price,
      cart_id: cartId,
      add_on: selectedAddons != null && selectedAddons.isNotEmpty
          ? selectedAddons
          : null,
      items: itemsListRequest,
      restaurant_id: restaurantId,
      resetCart: resetCart ? 1 : 0,
    );
    final String _apiToken = 'api_token=${_user.apiToken}';
    final String url =
        '${GlobalConfiguration().getString('api_base_url')}carts?${_apiToken}';
    final client = new http.Client();
    try {
      final response = await client.post(
        url,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: json.encode(request.toMap()),
      );
      if (response.statusCode == 200 || response.statusCode == 202) {
        CommonMethods.getCartCount();
        return AddToCartResponse.fromJson(json.decode(response.body));
      } else {
        print(
            CustomTrace(StackTrace.current, message: response.body).toString());
        globalKey.currentState
            .showSnackBar(SnackBar(content: Text(response.reasonPhrase)));
        return null;
      }
    } catch (e) {
      globalKey.currentState
          .showSnackBar(SnackBar(content: Text(e.toString())));
      return null;
    }
  }

  Future<AddToCartResponse> addItemToCart(
      BuildContext context,
      GlobalKey<ScaffoldState> globalKey,
      int cartId,
      int mealId,
      String price,
      List<Recipe> recipes,
      List<ItemList> lists,
      int restaurantId,
      int _itemCount,
      bool resetCart) async {
    print("addItemToCart----cartId--$cartId, mealId--$mealId, price--$price , _itemCount--$_itemCount,resetCart--$resetCart  ");

    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return null;
    }

    List<CartList> cartList = null;
    List<Recipe> cartRecipes = null;
    print("keoago$lists");
    if (recipes != null && recipes.isNotEmpty)  {
      cartList = getCartListForItem(lists);

      cartRecipes = getCartRecipeForItem(recipes);
    }
    var request = AddItemToCartRequest(
      quantity: _itemCount,
      list: cartList,
      recipe: cartRecipes,
      menu_id: mealId,
      price: price,
      cart_id: cartId,
      restaurant_id: restaurantId,
      resetCart: resetCart ? 1 : 0,
    );
    final String _apiToken = 'api_token=${_user.apiToken}';
    final String url =
        '${GlobalConfiguration().getString('api_base_url')}carts?${_apiToken}';
    final client = new http.Client();
    try {
      final response = await client.post(
        url,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: json.encode(request.toMap()),
      );
      if (response.statusCode == 200 || response.statusCode == 202) {
        CommonMethods.getCartCount();
        return AddToCartResponse.fromJson(json.decode(response.body));
      } else {
        print(
            CustomTrace(StackTrace.current, message: response.body).toString());
        globalKey.currentState
            .showSnackBar(SnackBar(content: Text(response.reasonPhrase)));
        return null;
      }
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: url).toString());
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      return null;
    }
  }

  Future<AddToCartResponse> removeFromCart(
      BuildContext context, String cart_id, RestaurantController _con) async {
    DeleteMealFromCartRequest deleteMealFromCartRequest =
        DeleteMealFromCartRequest(cart_id: cart_id);
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return null;
    }
    final String _apiToken = 'api_token=${_user.apiToken}';
    final String url =
        '${GlobalConfiguration().getString('api_base_url')}remove_cart?${_apiToken}';
    final client = new http.Client();
    try {
      final response = await client.post(
        url,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: json.encode(deleteMealFromCartRequest.toMap()),
      );
      if (response.statusCode == 200) {
        CommonMethods.getCartCount();
        return AddToCartResponse.fromJson(json.decode(response.body));
      } else {
        print(
            CustomTrace(StackTrace.current, message: response.body).toString());
        return null;
      }
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: url).toString());
      return null;
    }
  }

  Future<GetFavoritesResponse> getAllFavouriteMeals() async {
    return getFavorites();
  }

  Future<AddToFavResponse> addMealToFavourite(Meal meal) async {
    return addFavorite(meal.id.toString(), true);
  }

  Future<AddToFavResponse> removeMealFromFavourite(String meal_id) async {
    return addFavorite(meal_id, false);
  }

  List<CartList> getCartListForItem(List<ItemList> list) {
    List<CartList> cartList;
    if (list != null && list.length > 0) {
      cartList = new List<CartList>();
      for (var listItem in list) {
        var cartListItem = CartList();
        cartListItem.list_name = listItem.listName;
        for (var choice in listItem.choices) {
          var choices = new List<Choice>();
          if (choice.isSelected) {
            choices.add(choice);
          }
          if (choices != null && choices.isNotEmpty) {
            cartListItem.choices = choices;
          }
        }
        if (cartListItem.choices != null && cartListItem.choices.isNotEmpty) {
          cartList.add(cartListItem);
        }
      }
    }
    return cartList;
  }

  List<Recipe> getCartRecipeForItem(List<Recipe> recipes) {
    List<Recipe> cartRecipes;
    if (recipes != null && recipes.length > 0) {
      cartRecipes = new List<Recipe>();
      for (var recipeItem in recipes) {
        if (recipeItem.isSelected) {
          cartRecipes.add(recipeItem);
        }
      }
    }
    return cartRecipes;
  }
}
