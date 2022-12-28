class DiningArea {
  Response response;

  DiningArea({this.response});

  DiningArea.fromJson(Map<String, dynamic> json) {
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
  var dinningId;
  String dinningName;
  String lat;
  String lng;
  int noFloor;
  String imageName;
  String createdAt;
  String updatedAt;
  double distanceMile;

  Data(
      {this.dinningId,
        this.dinningName,
        this.lat,
        this.lng,
        this.noFloor,
        this.imageName,
        this.createdAt,
        this.updatedAt,
        this.distanceMile});

  Data.fromJson(Map<String, dynamic> json) {
    dinningId = json['dinning_id'];
    dinningName = json['dinning_name'];
    lat = json['lat'];
    lng = json['lng'];
    noFloor = json['no_floor'];
    imageName = json['image_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    distanceMile = json['distance_mile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dinning_id'] = this.dinningId;
    data['dinning_name'] = this.dinningName;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['no_floor'] = this.noFloor;
    data['image_name'] = this.imageName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['distance_mile'] = this.distanceMile;
    return data;
  }
}