class BannerRequest {
  String latitude;
  String longitude;

  BannerRequest({this.latitude, this.longitude});

  BannerRequest.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map toMap() {
    var map = new Map<String,dynamic>();
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    return map;
  }
}