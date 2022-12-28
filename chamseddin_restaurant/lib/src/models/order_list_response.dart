class OrderListResponse {
  Response response;

  OrderListResponse({this.response});

  OrderListResponse.fromJson(Map<String, dynamic> json) {
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
  double price;
  String currencySymbol;
  int orderId;
  String diningName;
  String diningImage;
  List<Detail> detail;

  Data(
      {this.createdAt,
      this.price,
      this.currencySymbol,
      this.orderId,
      this.diningName,
      this.diningImage,
      this.detail});

  Data.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    price = json['price'] is int
        ? (json['price'] as int).toDouble()
        : json['price'];
    currencySymbol = json['currency_symbol'];
    orderId = json['order_id'];
    diningName = json['dining_name'];
    diningImage = json['dining_image'];
    if (json['detail'] != null) {
      detail = new List<Detail>();
      json['detail'].forEach((v) {
        detail.add(new Detail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['price'] = this.price;
    data['currency_symbol'] = this.currencySymbol;
    data['order_id'] = this.orderId;
    data['dining_name'] = this.diningName;
    data['dining_image'] = this.diningImage;
    if (this.detail != null) {
      data['detail'] = this.detail.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Detail {
  String restaurant;
  String status;
  double price;

  Detail({this.restaurant, this.status, this.price});

  Detail.fromJson(Map<String, dynamic> json) {
    restaurant = json['restaurant'];
    status = json['status'];
    price = json['price'] is int
        ? (json['price'] as int).toDouble()
        : json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurant'] = this.restaurant;
    data['status'] = this.status;
    data['price'] = this.price;
    return data;
  }
}
