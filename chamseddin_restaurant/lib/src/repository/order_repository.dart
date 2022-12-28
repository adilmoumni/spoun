import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/src/helpers/common_methods.dart';
import 'package:food_delivery_app/src/models/last_order_request.dart';
import 'package:food_delivery_app/src/models/last_order_response.dart';
import 'package:food_delivery_app/src/models/notification_read_response.dart';
import 'package:food_delivery_app/src/models/order_again_request.dart';
import 'package:food_delivery_app/src/models/order_again_response.dart';
import 'package:food_delivery_app/src/models/order_details_response.dart';
import 'package:food_delivery_app/src/models/order_list_response.dart';
import 'package:food_delivery_app/src/models/restaurant_rating_arguments.dart';
//import 'package:food_delivery_app/src/models/restaurant_rating_request.dart';
import 'package:food_delivery_app/src/models/restaurant_rating_response.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/custom_trace.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

ValueNotifier<User> currentUser = new ValueNotifier(User());

Future<OrderListResponse> getOrderList() async {
  User _user = userRepo.currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}order_list_mob?$_apiToken';

  print('url=====  $url');
  final client = new http.Client();

  final response = await client.get(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );
  print(OrderListResponse());
  if (response.statusCode == 200) {
    print(response.body);
    return OrderListResponse.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 202) {
    Fluttertoast.showToast(
        msg: "There are no orders", toastLength: Toast.LENGTH_LONG);
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }
}

Future<http.Response> getOrderDetails(String orderId) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return null;
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}order_show_mob/$orderId?$_apiToken';
  print("hello$orderId");
  print('url=====  $url');
  final client = new http.Client();
  final response = await client.get(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );

  print("helloDetails${response.body}");
  return response;
}

Future<NotificationReadResponse> markNotificationRead(
    String notificationId) async {
  User _user = userRepo.currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}notify/$notificationId?$_apiToken';
  print('url=====  $url');
  print("llll$notificationId");

  var map = new Map<String, dynamic>();
  map['read'] = 1;
  final client = new http.Client();
  final response = await client.patch(url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(map));
  if (response.statusCode == 200) {
    print(response.body);
    CommonMethods.getNotifications();
    return NotificationReadResponse.fromJson(jsonDecode(response.body));
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }
}

Future<OrderAgainResponse> orderAgain(
    OrderAgainRequest orderAgainRequest) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return null;
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}order_again?$_apiToken';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(orderAgainRequest.toMap()),
  );
  if (response.statusCode == 200) {
    print(response.body);
    return OrderAgainResponse.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 202) {
    print(response.body);
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }
}

Future<RestaurantRatingResponse> restaurantRating(
    List<RestaurantRatingRequest> argu) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return null;
  }
  RestaurantRatingArguments restaurantRatingArguments =
      RestaurantRatingArguments();
  restaurantRatingArguments.myRating = argu;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}restaurant_reviews?$_apiToken';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(restaurantRatingArguments.toMap()),
  );
  print(json.encode(restaurantRatingArguments.toJson()));
  if (response.statusCode == 200) {
    print(response.body);
    return RestaurantRatingResponse.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 202) {
    print(response.body);
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }
}

Future<http.Response> lastOrder([String orderId]) async {
  User _user = userRepo.currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}last_order?$_apiToken';
  print('url=====  $url');
  final client = new http.Client();
  LastOrderRequest lastOrderRequest = new LastOrderRequest();
  lastOrderRequest.superOrderId = orderId;
//  print("Super order id :::: " +orderId);
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(lastOrderRequest.toMap()),
  );
  if (response.statusCode == 200) {
    print(response.body);
    return response;
  } else if (response.statusCode == 202) {
    Fluttertoast.showToast(
        msg: "No order found", toastLength: Toast.LENGTH_LONG);
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }
}
