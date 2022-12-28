class GetFavoritesResponse {
  Response _response;

  GetFavoritesResponse({Response response}) {
    this._response = response;
  }

  Response get response => _response;
  set response(Response response) => _response = response;

  GetFavoritesResponse.fromJson(Map<String, dynamic> json) {
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
  List<Favourite> _data;
  int _code;

  Response({String message, List<Favourite> data, int code}) {
    this._message = message;
    this._data = data;
    this._code = code;
  }

  String get message => _message;
  set message(String message) => _message = message;
  List<Favourite> get data => _data;
  set data(List<Favourite> data) => _data = data;
  int get code => _code;
  set code(int code) => _code = code;

  Response.fromJson(Map<String, dynamic> json) {
    _message = json['message'];
    if (json['data'] != null) {
      _data = new List<Favourite>();
      json['data'].forEach((v) {
        _data.add(new Favourite.fromJson(v));
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

class Favourite {
  int _restaurantId;
  String _type;
  int _id;
  String _imageName;
  String _name;
  String _category;
  String _price;
  String _flag;

  Favourite(
      {int restaurantId,
        String type,
        int id,
        String imageName,
        String name,
        String category,
        String price,
        String flag}) {
    this._restaurantId = restaurantId;
    this._type = type;
    this._id = id;
    this._imageName = imageName;
    this._name = name;
    this._category = category;
    this._price = price;
    this._flag = flag;
  }

  int get restaurantId => _restaurantId;
  set restaurantId(int restaurantId) => _restaurantId = restaurantId;
  String get type => _type;
  set type(String type) => _type = type;
  int get id => _id;
  set id(int id) => _id = id;
  String get imageName => _imageName;
  set imageName(String imageName) => _imageName = imageName;
  String get name => _name;
  set name(String name) => _name = name;
  String get category => _category;
  set category(String category) => _category = category;
  String get price => _price;
  set price(String price) => _price = price;
  String get flag => _flag;
  set flag(String flag) => _flag = flag;

  Favourite.fromJson(Map<String, dynamic> json) {
    _restaurantId = json['restaurant_id'];
    _type = json['type'];
    _id = json['id'];
    _imageName = json['image_name'];
    _name = json['name'];
    _category = json['category'];
    _price = json['price'];
    _flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurant_id'] = this._restaurantId;
    data['type'] = this._type;
    data['id'] = this._id;
    data['image_name'] = this._imageName;
    data['name'] = this._name;
    data['category'] = this._category;
    data['price'] = this._price;
    data['flag'] = this._flag;
    return data;
  }
}
