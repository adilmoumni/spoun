class ViewCartCountResponse {
  String _message;
  int _data;
  int _code;

  ViewCartRes({String message, int data, int code}) {
    this._message = message;
    this._data = data;
    this._code = code;
  }

  String get message => _message;

  set message(String message) => _message = message;

  int get data => _data;

  set data(int data) => _data = data;

  int get code => _code;

  set code(int code) => _code = code;

  ViewCartCountResponse.fromJson(Map<String, dynamic> json) {
    _message = json['message'];
    _data = json['data'];
    _code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this._message;
    data['data'] = this._data;
    data['code'] = this._code;
    return data;
  }
}
