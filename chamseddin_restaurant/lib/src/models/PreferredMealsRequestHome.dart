class PreferredMealsRequestHome {
  String api_token;
  String type;
  String dinning_id;
  int category_id;
  String restaurant_id;

  PreferredMealsRequestHome({this.api_token, this.type});

  PreferredMealsRequestHome.fromJson(Map<String, dynamic> json) {
    api_token = json['api_token'];
    type = json['type'];
    dinning_id = json['dinning_id'];
    category_id = json['category_id'];
    restaurant_id = json['restaurant_id'];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['api_token'] = api_token;
    map['type'] = type;
    map['dinning_id'] = dinning_id;
    map['category_id'] = category_id;
    map['restaurant_id'] = restaurant_id;
    return map;
  }
}
