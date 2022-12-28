import 'add_on.dart';
import 'choice.dart';
import 'recipe.dart';

class OrderDetailsResponse {
  Response response;

  OrderDetailsResponse({this.response});

  OrderDetailsResponse.fromJson(Map<String, dynamic> json) {
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
  List<Data> data;
  int code;

  Response({this.message, this.data, this.code});

  Response.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
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

class Data {
  String createdAt;
  double totalPrice;
  String currencySymbol;
  String vat;
  String serviceFee;
  int orderId;
  List<Detail> detail;
  String pdfUrl;
  String qr;
  double restaurantTotal;
  String diningName;


  Data({this.createdAt, this.totalPrice,this.currencySymbol,this.vat, this.serviceFee, this.orderId, this.detail, this.pdfUrl, this.qr, this.restaurantTotal, this.diningName});

  Data.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    vat = json['vat'];
    serviceFee = json['service_fee'];
    totalPrice = json['total_price'] is int
        ? (json['total_price'] as int).toDouble()
        : json['total_price'];
    currencySymbol = json['currency_symbol'];
    orderId = json['order_id'];
    if (json['detail'] != null) {
      detail = new List<Detail>();
      json['detail'].forEach((v) {
        detail.add(new Detail.fromJson(v));
      });
    }
    pdfUrl = json['pdf_url'];
    qr = json['qr'];
    restaurantTotal = json['restaurant_total'] is int
    ? (json['restaurant_total'] as int).toDouble()
    : json['restaurant_total'];
    diningName = json['dining_name'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['total_price'] = this.totalPrice;
    data['currency_symbol'] = this.currencySymbol;
    data['vat'] = this.vat;
    data['service_fee'] = this.serviceFee;
    data['order_id'] = this.orderId;
    if (this.detail != null) {
      data['detail'] = this.detail.map((v) => v.toJson()).toList();
    }
    data['pdf_url'] = this.pdfUrl;
    data['qr'] = this.qr;
    data['restaurant_total'] = this.restaurantTotal;
    data['dining_name'] = this.diningName;

    return data;
  }
}

class Detail {
  String restaurant;
  String restaurantPhone;
  String status;
  double complete_percentage ;
  String waitingTime;
  double restaurantPrice;
  List<Food> food;
  int subOrderId;
  dynamic discount;

  Detail(
      {this.restaurant,
        this.restaurantPhone,
      this.status,
      this.complete_percentage,
        this.waitingTime,
      this.restaurantPrice,
      this.food, this.subOrderId, this.discount});

  Detail.fromJson(Map<String, dynamic> json) {
    restaurant = json['restaurant'];
    restaurantPhone = json['restaurant_phone'];
    status = json['status'];
    complete_percentage = json['complete_percentage'] is int
        ? (json['complete_percentage']as int).toDouble()
        : json['complete_percentage'] ;
    waitingTime = json['waiting_time'];
    restaurantPrice = json['restaurant_price'] is int
        ? (json['restaurant_price'] as int).toDouble()
        : json['restaurant_price'];
    if (json['food'] != null) {
      food = new List<Food>();
      json['food'].forEach((v) {
        food.add(new Food.fromJson(v));
      });
    }
    subOrderId = json['sub_order_id'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurant'] = this.restaurant;
    data['restaurant_phone'] = this.restaurantPhone;
    data['status'] = this.status;
    data['complete_percentage'] = this.complete_percentage;
    data['waiting_time'] = this.waitingTime;
    data['restaurant_price'] = this.restaurantPrice;
    if (this.food != null) {
      data['food'] = this.food.map((v) => v.toJson()).toList();
    }
    data['sub_order_id'] = this.subOrderId;
    data['discount'] = this.discount;
    return data;
  }
}

class Food {
  String name;
  int quantity;
  double foodPrice;
  List<AddOn> addOn;
  List<Items> items;

  Food({this.name, this.quantity, this.foodPrice, this.addOn, this.items});

  Food.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    quantity = json['quantity'];
    foodPrice = json['food_price'] is int
        ? (json['food_price'] as int).toDouble()
        : json['food_price'];
    if (json['add_on'] != null) {
      addOn = new List<AddOn>();
      json['add_on'].forEach((v) {
        addOn.add(new AddOn.fromJson(v));
      });
    }
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['quantity'] = this.quantity;
    data['food_price'] = this.foodPrice;
    if (this.addOn != null) {
      data['add_on'] = this.addOn.map((v) => v.toJson()).toList();
    }
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String item_name;
  List<Choice> list;
  List<Recipe> recipe;

  Items({this.item_name, this.list});

  Items.fromJson(Map<String, dynamic> json) {
    item_name = json['item_name'];
    if (json['list'] != null) {
      list = new List<Choice>();
      json['list'].forEach((v) {
        list.add(new Choice.fromJson(v));
      });
    }
    if (json['recipe'] != null) {
      recipe = new List<Recipe>();
      json['recipe'].forEach((v) {
        recipe.add(new Recipe.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_name'] = this.item_name;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
