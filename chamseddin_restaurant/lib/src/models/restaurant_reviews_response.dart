class RestaurantReviewResponse {
  bool success;
  Data data;
  String message;

  RestaurantReviewResponse({this.success, this.data, this.message});

  RestaurantReviewResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int id;
  String review;
  String rate;
  int userId;
  int restaurantId;
  String createdAt;
  String updatedAt;
  List<Null> customFields;

  Data(
      {this.id,
        this.review,
        this.rate,
        this.userId,
        this.restaurantId,
        this.createdAt,
        this.updatedAt,
        this.customFields});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    review = json['review'];
    rate = json['rate'];
    userId = json['user_id'];
    restaurantId = json['restaurant_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    customFields = json['custom_fields'];
//    if (json['custom_fields'] != null) {
//      customFields = new List<Null>();
//      json['custom_fields'].forEach((v) {
//        customFields.add(new Null.fromJson(v));
//      });
//    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['review'] = this.review;
    data['rate'] = this.rate;
    data['user_id'] = this.userId;
    data['restaurant_id'] = this.restaurantId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['custom_fields'] = this.customFields;
//    if (this.customFields != null) {
//      data['custom_fields'] = this.customFields.map((v) => v.toJson()).toList();
//    }
    return data;
  }
}