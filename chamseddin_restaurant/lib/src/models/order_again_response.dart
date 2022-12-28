class OrderAgainResponse {
  Response response;

  OrderAgainResponse({this.response});

  OrderAgainResponse.fromJson(Map<String, dynamic> json) {
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
  String message;
  int code;

  Response({this.message, this.code});

  Response.fromJson(Map<String, dynamic> json) {
    message = json['message'] is List<dynamic>
        ? (json['message'] as List<dynamic>).toString()
        : json['message'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['code'] = this.code;
    return data;
  }
}