class Meals {
  Response response;

  Meals({this.response});

  Meals.fromJson(Map<String, dynamic> json) {
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
  List<Meal> data;
  int code;

  Response({this.message, this.data, this.code});

  Response.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Meal>();
      json['data'].forEach((v) {
        data.add(new Meal.fromJson(v));
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

class Meal {
  String restaurantName;
  int restaurantId;
  String type;
  int id;
  String cartId;
  String count;
  String imageName;
  String name;
  String diningArea;
  String category;
  String price;
  String currencySymbol;
  String flag;
  String flagColor;
  String description;

  Meal({this.restaurantName,
    this.restaurantId,
    this.type,
    this.id,
    this.imageName,
    this.name,
    this.cartId,
    this.count,
    this.diningArea,
    this.category,
    this.price,
    this.currencySymbol,
    this.flag,
    this.flagColor,
    this.description});

  Meal.fromJson(Map<String, dynamic> json) {
    restaurantName = json['restaurant_name'];
    restaurantId = json['restaurant_id'];
    type = json['type'];
    id = json['id'];
    imageName = json['image_name'];
    name = json['name'];
    diningArea = json['dining_area'];
    cartId = json['cartid'];
    count = json['count'];
    category = json['category'];
    price = json['price'];
    currencySymbol = json['currency_symbol'];
    flag = json['flag'];
    flagColor = json['flag_color'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurant_name'] = this.restaurantName;
    data['restaurant_id'] = this.restaurantId;
    data['type'] = this.type;
    data['id'] = this.id;
    data['cartId'] = this.cartId;
    data['count'] = this.count;
    data['image_name'] = this.imageName;
    data['name'] = this.name;
    data['dining_area'] = this.diningArea;
    data['category'] = this.category;
    data['price'] = this.price;
    data['currency_symbol'] = this.currencySymbol;
    data['flag'] = this.flag;
    data['flag_color'] = this.flagColor;
    data['description'] = this.description;
    return data;
  }
}