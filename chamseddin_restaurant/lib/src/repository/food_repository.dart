import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/custom_trace.dart';
import '../models/add_to_fav_request.dart';
import '../models/add_to_fav_response.dart';
import '../models/favorite.dart';
import '../models/get_favorites_response.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

Future<GetFavoritesResponse> getFavorites() async {
  User _user = userRepo.currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}favorite_list?$_apiToken';
  final client = new http.Client();
  try {
    final response = await client.get(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    if (response.statusCode == 200 || response.statusCode == 202) {
      return GetFavoritesResponse.fromJson(json.decode(response.body));
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
      return null;
    }
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return null;
  }
}

Future<AddToFavResponse> addFavorite(String id, bool add) async {
  AddToFavoriteRequest addToFavoriteRequest = new AddToFavoriteRequest();
  addToFavoriteRequest.id = id;
  if (add) {
    addToFavoriteRequest.type = "add";
  } else {
    addToFavoriteRequest.type = "remove";
  }
  User _user = userRepo.currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}is_favorite?$_apiToken';
  final client = new http.Client();
  try {
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(addToFavoriteRequest.toMap()),
    );
    if (response.statusCode == 202) {
      return AddToFavResponse.fromJson(json.decode(response.body));
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
      return null;
    }
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return null;
  }
}

Future<Favorite> removeFavorite(Favorite favorite) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Favorite();
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}favorites/${favorite.id}?$_apiToken';
  try {
    final client = new http.Client();
    final response = await client.delete(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    return Favorite.fromJSON(json.decode(response.body)['data']);
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return Favorite.fromJSON({});
  }
}
