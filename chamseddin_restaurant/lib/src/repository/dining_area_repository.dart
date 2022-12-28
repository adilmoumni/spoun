import 'dart:convert';
import 'dart:io';

import 'package:food_delivery_app/src/models/filters_list_response.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/custom_trace.dart';
import '../models/DiningArea.dart';
import '../models/DiningRestaurantRequest.dart';
import '../models/DiningRestaurantResponse.dart';
import '../models/diningAreaRequest.dart';

Future<DiningArea> diningArea(String latitude, String longitude) async {
  DiningAreaRequest diningAreaRequest = new DiningAreaRequest();
  diningAreaRequest.latitude = latitude;
  diningAreaRequest.longitude = longitude;
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}dinning_area';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(diningAreaRequest.toMap()),
  );
  if (response.statusCode == 200) {
    print(response.body);
    return DiningArea.fromJson(jsonDecode(response.body));
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }
}

Future<DiningRestaurantResponse> getRestaurantsInDiningArea(
    String diningId, List<Cuisine> cuisines) async {
  DiningRestaurantRequest diningRestaurantRequest =
      new DiningRestaurantRequest();
  diningRestaurantRequest.diningId = diningId;
  List<int> cuisineIds;
  if (cuisines != null && cuisines.isNotEmpty) {
    cuisineIds = new List<int>();
    for (Cuisine cuisine in cuisines) {
      cuisineIds.add(cuisine.cuisineId);
    }
  }
  diningRestaurantRequest.cuisineIds = cuisineIds;
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}dinning_restaurant';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(diningRestaurantRequest.toMap()),
  );
  if (response.statusCode == 200 || response.statusCode == 202) {
    print(response.body);
    return DiningRestaurantResponse.fromJson(jsonDecode(response.body));
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }
}
