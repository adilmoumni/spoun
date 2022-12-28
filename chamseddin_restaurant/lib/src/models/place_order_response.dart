class PlaceOrderResponse {
  Response response;

  PlaceOrderResponse({this.response});

  PlaceOrderResponse.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
    print("orderkarra$response");
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
  String qr;
  int code;

  Response({this.message,this.qr, this.code});

  Response.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    qr = json['qr'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['qr'] = this.qr;
    data['code'] = this.code;
    return data;
  }
}