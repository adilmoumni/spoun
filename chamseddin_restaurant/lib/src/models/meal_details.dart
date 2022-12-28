import 'add_on.dart';
import 'choice.dart';
import 'recipe.dart';

class MealDetails {
  Response response;

  MealDetails({this.response});

  MealDetails.fromJson(Map<String, dynamic> json) {
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
  List<MealInfo> mealsInfo;
  int code;

  Response({this.message, this.mealsInfo, this.code});

  Response.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      mealsInfo = new List<MealInfo>();
      json['data'].forEach((v) {
        mealsInfo.add(new MealInfo.fromJson(v));
      });
    }
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.mealsInfo != null) {
      data['data'] = this.mealsInfo.map((v) => v.toJson()).toList();
    }
    data['code'] = this.code;
    return data;
  }
}

class MealInfo {
  int menuId;
  String type;
  int foodId;
  String imageName;
  String name;
  String foodDescription;
  String category;
  List<Items> items;
  List<AddOn> addOn;
  double price;
  String currencySymbol;
  String flagName;
  String createdAt;
  String status;
  String description;
  int fvrt;

  MealInfo(
      {this.menuId,
      this.type,
      this.foodId,
      this.imageName,
      this.name,
      this.foodDescription,
      this.category,
      this.items,
      this.addOn,
      this.price,
      this.currencySymbol,
      this.flagName,
      this.createdAt,
      this.status,
      this.description,
      this.fvrt});

  MealInfo.fromJson(Map<String, dynamic> json) {
    menuId = json['menu_id'];
    type = json['type'];
    foodId = json['food_id'];
    imageName = json['image_name'];
    name = json['name'];
    foodDescription = json['food_description'];
    category = json['category'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    if (json['add_on'] != null) {
      addOn = new List<AddOn>();
      json['add_on'].forEach((v) {
        addOn.add(new AddOn.fromJson(v));
      });
    }
    price = json['price'] is int
        ? (json['price'] as int).toDouble()
        : json['price'];
    currencySymbol = json['currency_symbol'];
    flagName = json['flag_name'];
    createdAt = json['created_at'];
    status = json['status'];
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
    data['food_description'] = this.foodDescription;
    data['category'] = this.category;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    if (this.addOn != null) {
      data['add_on'] = this.addOn.map((v) => v.toJson()).toList();
    }
    data['price'] = this.price;
    data['currency_symbol'] = this.currencySymbol;
    data['flag_name'] = this.flagName;
    data['created_at'] = this.createdAt;
    data['status'] = this.status;
    data['description'] = this.description;
    data['fvrt'] = this.fvrt;
    return data;
  }
}

class Items {
  int itemId;
  String name;
  String price;
  List<Recipe> recipe;
  List<ItemList> list;

  Items({this.itemId, this.name, this.price, this.recipe, this.list});

  Items.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    name = json['name'];
    price = json['price'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_id'] = this.itemId;
    data['name'] = this.name;
    data['price'] = this.price;
    if (this.recipe != null) {
      data['recipe'] = this.recipe.map((v) => v.toJson()).toList();
    }
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemList {
  String listName;
  int required;
  List<Choice> choices;
  int maxChoice;

  ItemList({this.listName, this.required, this.choices, this.maxChoice});

  ItemList.fromJson(Map<String, dynamic> json) {
    listName = json['list_name'];
    required = json['required'];
    if (json['choices'] != null) {
      choices = new List<Choice>();
      json['choices'].forEach((v) {
        choices.add(new Choice.fromJson(v));
      });
    }
    maxChoice = json['max_choice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['list_name'] = this.listName;
    data['required'] = this.required;
    data['choices'] = this.choices;
    data['max_choice'] = this.maxChoice;
    return data;
  }
}
