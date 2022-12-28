class MealDetailsRequest {
  String menu_id;
  String api_token;

  MealDetailsRequest({this.menu_id});

  MealDetailsRequest.fromJson(Map<String, dynamic> json) {
    menu_id = json['menu_id'];
    api_token = json['api_token'];
  }

  Map toMap() {
    var map = new Map<String,dynamic>();
    map['menu_id'] = menu_id;
    map['api_token'] = api_token;
    return map;
  }
}