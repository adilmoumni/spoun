class DiningRestaurantRequest {
  String diningId;
  List<int> cuisineIds;

  DiningRestaurantRequest({this.diningId, this.cuisineIds});

  DiningRestaurantRequest.fromJson(Map<String, dynamic> json) {
    diningId = json['dinning_id'];
    cuisineIds = json['cuisines_id'];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['dinning_id'] = diningId;
    if (cuisineIds != null) {
      map['cuisines_id'] = cuisineIds;
    }
    return map;
  }
}
