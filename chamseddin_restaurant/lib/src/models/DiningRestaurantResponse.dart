class DiningRestaurantResponse {
  Response response;

  DiningRestaurantResponse({this.response});

  DiningRestaurantResponse.fromJson(Map<String, dynamic> json) {
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
  int restaurantId;
  String title;
  String imageUrl;
  String location;
  String rating;
  int ratingCount;
  bool closed;
  String lat;
  String lng;
  String diningName;

  Data({this.restaurantId,
    this.title,
    this.imageUrl,
    this.location,
    this.rating,
    this.ratingCount,
    this.closed,
    this.lat,
    this.lng,
    this.diningName});

  Data.fromJson(Map<String, dynamic> json) {
    restaurantId = json['restaurant_id'];
    title = json['title'];
    imageUrl = json['image_url'];
    location = json['location'];
    rating = json['rating'];
    ratingCount = json['rating_count'];
    closed = json['closed'];
    lat = json['lat'];
    lng = json['lng'];
    diningName = json['dining_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurant_id'] = this.restaurantId;
    data['title'] = this.title;
    data['image_url'] = this.imageUrl;
    data['location'] = this.location;
    data['rating'] = this.rating;
    data['rating_count'] = this.ratingCount;
    data['closed'] = this.closed;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['dining_name'] = this.diningName;
    return data;
  }
}