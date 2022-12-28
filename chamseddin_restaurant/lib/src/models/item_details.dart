import 'meal_details.dart';
import 'recipe.dart';

class ItemDetails {
  Response response;

  ItemDetails({this.response});

  ItemDetails.fromJson(Map<String, dynamic> json) {
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
  List<ItemInfo> data;
  int code;

  Response({this.message, this.data, this.code});

  Response.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = new List<ItemInfo>();
      json['data'].forEach((v) {
        data.add(new ItemInfo.fromJson(v));
      });
    }
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['code'] = this.code;
    return data;
  }
}

class ItemInfo {
  int menuId;
  String type;
  int foodId;
  String imageName;
  String name;
  String category;
  List<Recipe> recipe;
  List<ItemList> list;
  double price;
  String currencySymbol;
  String flagName;
  String createdAt;
  String description;
  int fvrt;

  ItemInfo(
      {this.menuId,
      this.type,
      this.foodId,
      this.imageName,
      this.name,
      this.category,
      this.recipe,
      this.list,
      this.price,
      this.currencySymbol,
      this.flagName,
      this.createdAt,
      this.description,
      this.fvrt});

  ItemInfo.fromJson(Map<String, dynamic> json) {
    menuId = json['menu_id'];
    type = json['type'];
    foodId = json['food_id'];
    imageName = json['image_name'];
    name = json['name'];
    category = json['category'];
    if (json['recipe'] != null) {
      recipe = new List<Recipe>();
      json['recipe'].forEach((v) {
        recipe.add(new Recipe.fromJson(v));
      });
    }
    if (json['list'] != null) {
      list = new List<ItemList>();
      json['list'].forEach((v) {
        list.add(new ItemList.fromJson(v));
      });
    }
    price = json['price'] is int
        ? (json['price'] as int).toDouble()
        : json['price'];
    currencySymbol = json['currency_symbol'];
    flagName = json['flag_name'];
    createdAt = json['created_at'];
    description = json['description'];
    fvrt = json['fvrt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menu_id'] = this.menuId;
    data['type'] = this.type;
    data['food_id'] = this.foodId;
    data['image_name'] = this.imageName;
    data['name'] = this.name;
    data['category'] = this.category;
    if (this.recipe != null) {
      data['recipe'] = this.recipe.map((v) => v.toJson()).toList();
    }
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    data['price'] = this.price;
    data['currency_symbol'] = this.currencySymbol;
    data['flag_name'] = this.flagName;
    data['created_at'] = this.createdAt;
    data['description'] = this.description;
    data['fvrt'] = this.fvrt;
    return data;
  }
}
