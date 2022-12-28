import 'dart:convert';
import 'dart:io';

import 'package:fbroadcast/fbroadcast.dart';
import 'package:food_delivery_app/src/models/notification_response.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/item_details.dart';
import '../models/meal_details.dart';
import '../models/user.dart';
import '../models/view_cart_count_response.dart';
import '../repository/user_repository.dart' as userRepo;
import 'custom_trace.dart';

class CommonMethods {
  static bool isMealEmpty(MealDetails mealDetails) {
    bool isMealEmpty = true;
    if (mealDetails.response.mealsInfo != null &&
        mealDetails.response.mealsInfo.isNotEmpty) {
      MealInfo mealInfo = mealDetails.response.mealsInfo.first;
      if (mealInfo.items != null && mealInfo.items.isNotEmpty) {
        for (var item in mealInfo.items) {
          if (item.list != null && item.list.isNotEmpty) {
            isMealEmpty = false;
            break;
          }
          if (item.recipe != null && item.recipe.isNotEmpty) {
            isMealEmpty = false;
            break;
          }
        }
      }
      if (mealInfo.addOn != null && mealInfo.addOn.isNotEmpty) {
        isMealEmpty = false;
      }
    }
    return isMealEmpty;
  }

  static bool isItemEmpty(ItemDetails itemDetails) {
    bool isItemEmpty = true;
    if (itemDetails.response.data != null &&
        itemDetails.response.data.isNotEmpty) {
      ItemInfo itemInfo = itemDetails.response.data.first;
      if (itemInfo.list != null && itemInfo.list.isNotEmpty) {
        isItemEmpty = false;
      }
      if (itemInfo.recipe != null && itemInfo.recipe.isNotEmpty) {
        isItemEmpty = false;
      }
    }
    return isItemEmpty;
  }

  static void getCartCount() async {
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return null;
    }
    final String _apiToken = 'api_token=${_user.apiToken}';
    final String url =
        '${GlobalConfiguration().getString('api_base_url')}carts/count?${_apiToken}';
    final client = new http.Client();
    try {
      final response = await client.get(
        url,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      if (response.statusCode == 200) {
        var cartCountResponse =
            ViewCartCountResponse.fromJson(json.decode(response.body));
        FBroadcast.instance().broadcast(
          // message type
          Constants.cartCount,
          // data
          value: cartCountResponse.data,
        );
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

  static Future<NotificationListResponse> getNotifications() async {
    User _user = userRepo.currentUser.value;
    final String _apiToken = 'api_token=${_user.apiToken}';
    final String url =
        '${GlobalConfiguration().getString('api_base_url')}notify?$_apiToken';
    print('url=====  $url');

    final client = new http.Client();
    final response = await client.get(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},

    );
    if (response.statusCode == 200) {
      print('llllllll${response.body}');
      var notificationsListResponse =
          NotificationListResponse.fromJson(jsonDecode(response.body));
      int unreadCount = 0;
      if (notificationsListResponse.response.data != null &&
          notificationsListResponse.response.data.isNotEmpty) {
        for (var notification in notificationsListResponse.response.data) {
          if (notification.read == 0) {
            unreadCount++;
          }
        }
      }
      FBroadcast.instance().broadcast(
        // message type
        Constants.unreadNotificationsCount,
        // data
        value: unreadCount,
      );
      return notificationsListResponse;
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
      throw new Exception(response.body);
    }
  }
}
