class LastOrderResponse {
  Response response;

  LastOrderResponse({this.response});

  LastOrderResponse.fromJson(Map<String, dynamic> json) {
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
  String diningName;
  List<RestaurantDetail> restaurantDetail;

  Data({this.diningName, this.restaurantDetail});

  Data.fromJson(Map<String, dynamic> json) {
    diningName = json['dining_name'];
    if (json['restaurant_detail'] != null) {
      restaurantDetail = new List<RestaurantDetail>();
      json['restaurant_detail'].forEach((v) {
        restaurantDetail.add(new RestaurantDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dining_name'] = this.diningName;
    if (this.restaurantDetail != null) {
      data['restaurant_detail'] =
          this.restaurantDetail.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RestaurantDetail {
  String name;
  int restaurantId;
  String image;
  int orderId;
  var rate;

  RestaurantDetail(
      {this.name, this.restaurantId, this.image, this.orderId, this.rate});

  RestaurantDetail.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    restaurantId = json['restaurant_id'];
    image = json['image'];
    orderId = json['order_id'];
    rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['restaurant_id'] = this.restaurantId;
    data['image'] = this.image;
    data['order_id'] = this.orderId;
    data['rate'] = this.rate;
    return data;
  }
}