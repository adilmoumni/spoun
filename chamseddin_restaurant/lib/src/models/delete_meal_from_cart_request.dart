class DeleteMealFromCartRequest {
  String cart_id;

  DeleteMealFromCartRequest({this.cart_id});

  DeleteMealFromCartRequest.fromJson(Map<String, dynamic> json) {
    cart_id = json['cart_id'];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['cart_id'] = cart_id;
    return map;
  }
}
