class VerifyOtpResponse {
  Response response;

  VerifyOtpResponse({this.response});

  VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
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

class Response {
  String vCode;
  String message;
  int code;

  Response({this.vCode, this.message, this.code});

  Response.fromJson(Map<String, dynamic> json) {
    vCode = json['v_code'];
    message = json['message'].toString();
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['v_code'] = this.vCode;
    data['message'] = this.message;
    data['code'] = this.code;
    return data;
  }
}