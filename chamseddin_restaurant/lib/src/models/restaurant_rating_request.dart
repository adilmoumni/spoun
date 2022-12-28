class RestaurantRatingRequest {
  int restaurantId;
  int restaurantRating;
  int orderId;

  RestaurantRatingRequest(
      {this.restaurantId, this.restaurantRating, this.orderId});

  RestaurantRatingRequest.fromJson(Map<String, dynamic> json) {
    restaurantId = json['restaurant_id'];
    restaurantRating = json['restaurant_rating'];
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurant_id'] = this.restaurantId;
    data['restaurant_rating'] = this.restaurantRating;
    data['order_id'] = this.orderId;
    return data;
  }
}