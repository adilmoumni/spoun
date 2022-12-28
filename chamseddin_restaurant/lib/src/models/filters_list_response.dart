class FiltersListResponse {
  Response _response;

  FiltersListResponse({Response response}) {
    this._response = response;
  }

  Response get response => _response;
  set response(Response response) => _response = response;

  FiltersListResponse.fromJson(Map<String, dynamic> json) {
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
  List<Cuisine> _data;
  int _code;

  Response({String message, List<Cuisine> data, int code}) {
    this._message = message;
    this._data = data;
    this._code = code;
  }

  String get message => _message;
  set message(String message) => _message = message;
  List<Cuisine> get data => _data;
  set data(List<Cuisine> data) => _data = data;
  int get code => _code;
  set code(int code) => _code = code;

  Response.fromJson(Map<String, dynamic> json) {
    _message = json['message'];
    if (json['data'] != null) {
      _data = new List<Cuisine>();
      json['data'].forEach((v) {
        _data.add(new Cuisine.fromJson(v));
      });
    }
    _code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this._message;
    if (this._data != null) {
      data['data'] = this._data.map((v) => v.toJson()).toList();
    }
    data['code'] = this._code;
    return data;
  }
}

class Cuisine {
  int _cuisineId;
  String _name;
  String _imageName;
  String _description;

  Cuisine({int cuisineId, String name, String imageName, String description}) {
    this._cuisineId = cuisineId;
    this._name = name;
    this._imageName = imageName;
    this._description = description;
  }

  int get cuisineId => _cuisineId;
  set cuisineId(int cuisineId) => _cuisineId = cuisineId;
  String get name => _name;
  set name(String name) => _name = name;
  String get imageName => _imageName;
  set imageName(String imageName) => _imageName = imageName;
  String get description => _description;
  set description(String description) => _description = description;

  Cuisine.fromJson(Map<String, dynamic> json) {
    _cuisineId = json['cuisine_id'];
    _name = json['name'];
    _imageName = json['image_name'];
    _description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cuisine_id'] = this._cuisineId;
    data['name'] = this._name;
    data['image_name'] = this._imageName;
    data['description'] = this._description;
    return data;
  }
}
