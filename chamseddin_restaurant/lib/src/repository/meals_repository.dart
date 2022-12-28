import 'dart:convert';
import 'dart:io';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../helpers/custom_trace.dart';
import '../models/Meals.dart';
import '../models/PreferredMealsRequestHome.dart';
import '../models/meal_details_request.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

Future<Meals> getPreferredMealsForHome() async {
  PreferredMealsRequestHome preferredMealsRequest =
      new PreferredMealsRequestHome();
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return null;
  }
  preferredMealsRequest.type = Constants.PREFERRED_MEALS_TYPE_HOME;
  preferredMealsRequest.api_token = _user.apiToken;
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}restaurant_meal';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(preferredMealsRequest.toMap()),
  );
  if (response.statusCode == 200 || response.statusCode == 202) {
    print(response.body);
    return Meals.fromJson(jsonDecode(response.body));
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }
}

Future<Meals> getPreferredMealsForDiningArea(String diningId) async {
  if (diningId == null) {
    return null;
  }
  PreferredMealsRequestHome preferredMealsRequest =
      new PreferredMealsRequestHome();
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return null;
  }
  preferredMealsRequest.type = Constants.PREFERRED_MEALS_TYPE_DINING_AREA;
  preferredMealsRequest.api_token = _user.apiToken;
  preferredMealsRequest.dinning_id = diningId;
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}restaurant_meal';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(preferredMealsRequest.toMap()),
  );
  if (response.statusCode == 200 || response.statusCode == 202) {
    print(response.body);
    return Meals.fromJson(jsonDecode(response.body));
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }
}

Future<Meals> getPreferredMealsForRestaurant(String restaurantId) async {
  if (restaurantId == null) {
    return null;
  }
  PreferredMealsRequestHome preferredMealsRequest =
      new PreferredMealsRequestHome();
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return null;
  }
  preferredMealsRequest.type = Constants.PREFERRED_MEALS_TYPE_RESTAURANT;
  preferredMealsRequest.api_token = _user.apiToken;
  preferredMealsRequest.restaurant_id = restaurantId;
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}restaurant_meal';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(preferredMealsRequest.toMap()),
  );
  if (response.statusCode == 200 || response.statusCode == 202) {
    print(response.body);
    return Meals.fromJson(jsonDecode(response.body));
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }
}

Future<Meals> getAllMealsForRestaurant(
    int categoryId, int restaurantId) async {
  if (restaurantId == null) {
    return null;
  }
  PreferredMealsRequestHome preferredMealsRequest =
      new PreferredMealsRequestHome();
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return null;
  }
  preferredMealsRequest.type = Constants.PREFERRED_MEALS_TYPE_RESTAURANT_MEAL;
  preferredMealsRequest.api_token = _user.apiToken;
  preferredMealsRequest.restaurant_id = restaurantId.toString();
  if (categoryId != null) {
    preferredMealsRequest.category_id = categoryId;
  }
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}restaurant_meal';
  print("url ====== "+url);
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(preferredMealsRequest.toMap()),
  );
  if (response.statusCode == 200 || response.statusCode == 202) {
    print(response.body);
    return Meals.fromJson(jsonDecode(response.body));
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }
}

Future<http.Response> getMealDetails(String meal_id) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return null;
  }
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}food_detail';
  final client = new http.Client();
  MealDetailsRequest detailsRequest = new MealDetailsRequest();
  detailsRequest.menu_id = meal_id;
  detailsRequest.api_token=_user.apiToken;
  print("Menu id : "+meal_id);
  try {
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(detailsRequest.toMap()),
    );
    print("Response ::::::" +response.body);
    print("Status code :::::"+response.statusCode.toString());
    return response;
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return null;
  }
}

Future<http.Response> getItemDetails(String item_id) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return null;
  }
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}food_detail';
  final client = new http.Client();
  MealDetailsRequest detailsRequest = new MealDetailsRequest();
  detailsRequest.menu_id = item_id;
  detailsRequest.api_token=_user.apiToken;
  try {
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(detailsRequest.toMap()),
    );
    return response;
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return null;
  }
}
