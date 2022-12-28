import 'specific_instructions_request.dart';

class PaymentArguments {
  final double payment_amount;
  final double vat;
  final String serviceFee;
  final bool makePayment;
  final List<SpecificInstructionsRequest> specificInstructionsRequest;
  final List<PromoDiscountRequest> promoDiscount;
  final List<dynamic> promoId;

  PaymentArguments(
      [this.payment_amount, this.vat, this.serviceFee, this.makePayment, this.specificInstructionsRequest, this.promoDiscount, this.promoId]);
}

class PromoDiscountRequest {
  int restaurantId;
  var discount;

  PromoDiscountRequest({this.restaurantId, this.discount});

  PromoDiscountRequest.fromJson(Map<String, dynamic> json) {
    restaurantId = json['restaurant_id'];
    discount = json['discount'];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['restaurant_id'] = restaurantId;
    map['discount'] = discount;
    return map;
  }
}
