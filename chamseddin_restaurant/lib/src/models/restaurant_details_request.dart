class RestaurantDetailsRequest {
  String restaurant_id;

  RestaurantDetailsRequest({this.restaurant_id});

  RestaurantDetailsRequest.fromJson(Map<String, dynamic> json) {
    restaurant_id = json['restaurant_id'];
  }

  Map toMap() {
    var map = new Map<String,dynamic>();
    map['restaurant_id'] = restaurant_id;
    return map;
  }
}