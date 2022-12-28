class Banners {
Response response;

Banners({this.response});

Banners.fromJson(Map<String, dynamic> json) {
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
  String imageUrl;

  Data({this.restaurantId, this.imageUrl});

  Data.fromJson(Map<String, dynamic> json) {
    restaurantId = json['restaurant_id'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurant_id'] = this.restaurantId;
    data['image_url'] = this.imageUrl;
    return data;
  }
}