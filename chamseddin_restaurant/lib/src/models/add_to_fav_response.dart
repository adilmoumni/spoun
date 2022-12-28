class AddToFavResponse {
  Response _response;

  AddToFavResponse({Response response}) {
    this._response = response;
  }

  Response get response => _response;
  set response(Response response) => _response = response;

  AddToFavResponse.fromJson(Map<String, dynamic> json) {
    _response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._response != null) {
      data['response'] = this._response.toJson();
    }
    return data;
  }
}

class Response {
  String _message;
  int _code;

  Response({String message, int code}) {
    this._message = message;
    this._code = code;
  }

  String get message => _message;
  set message(String message) => _message = message;
  int get code => _code;
  set code(int code) => _code = code;

  Response.fromJson(Map<String, dynamic> json) {
    _message = json['message'];
    _code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this._message;
    data['code'] = this._code;
    return data;
  }
}
