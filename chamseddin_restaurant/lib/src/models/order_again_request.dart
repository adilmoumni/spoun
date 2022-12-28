class OrderAgainRequest {
  String id;

  OrderAgainRequest({this.id});

  OrderAgainRequest.fromJson(Map <String,dynamic> json) {
    id = json['id'];
  }

  Map toMap() {
    var map = new Map<String,dynamic>();
    map['id'] = id;
    return map;
  }
}