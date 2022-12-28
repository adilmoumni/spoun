class OrderDetailsRequest {
  String orderId;

  OrderDetailsRequest({this.orderId});

  OrderDetailsRequest.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
  }

  Map toMap() {
    var map = new Map<String,dynamic>();
    map['order_id'] = orderId;
    return map;
  }
}