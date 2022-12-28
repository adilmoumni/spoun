class DiningAreaRequest {
  String latitude;
  String longitude;

  DiningAreaRequest({this.latitude, this.longitude});

  DiningAreaRequest.fromJson(Map<String, dynamic> json) {
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