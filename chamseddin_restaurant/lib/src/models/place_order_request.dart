import 'dart:convert';

import 'package:food_delivery_app/src/models/payment_arguments.dart';

import 'specific_instructions_request.dart';

class PlaceOrderRequest {
  final String method;
  final String price;
  final String vat;
  final String service_fee;
  final String description;
  final List<SpecificInstructionsRequest> specific_instructions;
  final List<PromoDiscountRequest> promoDiscount;
  final List<dynamic> promoId;

  PlaceOrderRequest(this.price, this.vat, this.service_fee, this.description,
      this.method, this.specific_instructions, this.promoDiscount, this.promoId);

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['method'] = method;
    map['vat'] = vat;
    map['service_fee'] = service_fee;
    map['price'] = price;
    map['description'] = description;
    if (this.specific_instructions != null) {
      map['specific_instructions'] =json.encode(this.specific_instructions.map((v) => v.toMap()).toList());
    }
    if (this.promoDiscount != null) {
      map['promo_discount'] = json.encode(this.promoDiscount.map((v) => v.toMap()).toList());
    }
    if(promoId!=null && promoId.first!=null)
      {
        map['promo_id'] = promoId;
      }

    return map;
  }
}
