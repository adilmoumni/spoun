class LastOrderRequest {
  String superOrderId;

  LastOrderRequest({this.superOrderId});

  LastOrderRequest.fromJson(Map<String, dynamic> json) {
    superOrderId = json['super_order_id'];
  }

  Map toMap() {
    var map = new Map<String,dynamic>();
    map['super_order_id'] = superOrderId;
    return map;
  }
}