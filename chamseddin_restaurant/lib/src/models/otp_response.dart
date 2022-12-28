import 'package:food_delivery_app/src/models/verify_otp_response.dart';

class OtpResponse {

  Response response;

  OtpResponse(this.response);

  OtpResponse.fromJson(Map<String, dynamic> json) {
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

class Response{
  int otp;
  String message;
  int code;

  Response({this.otp, this.message, this.code});

  Response.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    message = json['message'] is List<dynamic>
    ? (json['message'] as List<dynamic>).toString()
    : json['message'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp'] = this.otp;
    data['message'] = this.message;
    data['code'] = this.code;
    return data;
  }
}