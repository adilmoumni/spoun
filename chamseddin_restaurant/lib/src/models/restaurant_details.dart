class RestaurantDetails {
  Response _response;

  RestaurantDetails({Response response}) {
    this._response = response;
  }

  Response get response => _response;

  set response(Response response) => _response = response;

  RestaurantDetails.fromJson(Map<String, dynamic> json) {
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
  Data _data;
  int _code;

  Response({String message, Data data, int code}) {
    this._message = message;
    this._data = data;
    this._code = code;
  }

  String get message => _message;

  set message(String message) => _message = message;

  Data get data => _data;

  set data(Data data) => _data = data;

  int get code => _code;

  set code(int code) => _code = code;

  Response.fromJson(Map<String, dynamic> json) {
    _message = json['message'];
    _data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    _code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this._message;
    if (this._data != null) {
      data['data'] = this._data.toJson();
    }
    data['code'] = this._code;
    return data;
  }
}

class Data {
  Detail _detail;
  List<Category> _category;

  Data({Detail detail, List<Category> category}) {
    this._detail = detail;
    this._category = category;
  }

  Detail get detail => _detail;

  set detail(Detail detail) => _detail = detail;

  List<Category> get category => _category;

  set category(List<Category> category) => _category = category;

  Data.fromJson(Map<String, dynamic> json) {
    _detail =
        json['detail'] != null ? new Detail.fromJson(json['detail']) : null;
    if (json['category'] != null) {
      _category = new List<Category>();
      json['category'].forEach((v) {
        _category.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._detail != null) {
      data['detail'] = this._detail.toJson();
    }
    if (this._category != null) {
      data['category'] = this._category.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Detail {
  int _restaurantId;
  String _name;
  String _description;
  String _phone;
  String _address;
  String _imageUrl;
  int _diningId;

  Detail(
      {int restaurantId,
      String name,
      String description,
      String phone,
      String address,
      String imageUrl,
      int diningId}) {
    this._restaurantId = restaurantId;
    this._name = name;
    this._description = description;
    this._phone = phone;
    this._address = address;
    this._imageUrl = imageUrl;
    this._diningId = diningId;
  }

  int get restaurantId => _restaurantId;

  set restaurantId(int restaurantId) => _restaurantId = restaurantId;

  String get name => _name;

  set name(String name) => _name = name;

  String get description => _description;

  set description(String description) => _description = description;

  String get phone => _phone;

  set phone(String phone) => _phone = phone;

  String get address => _address;

  set address(String address) => _address = address;

  String get imageUrl => _imageUrl;

  set imageUrl(String imageUrl) => _imageUrl = imageUrl;

  int get diningId => _diningId;

  set dinindId(int diningId) => _diningId = diningId;

  Detail.fromJson(Map<String, dynamic> json) {
    _restaurantId = json['restaurant_id'];
    _name = json['name'];
    _description = json['description'];
    _phone = json['phone'];
    _address = json['address'];
    _imageUrl = json['image_url'];
    _diningId = json['dining_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurant_id'] = this._restaurantId;
    data['name'] = this._name;
    data['description'] = this._description;
    data['phone'] = this._phone;
    data['address'] = this._address;
    data['image_url'] = this._imageUrl;
    data['dining_id'] = this._diningId;
    return data;
  }
}

class Category {
  int _category;
  String _name;

  Category({int category, String name}) {
    this._category = category;
    this._name = name;
  }

  int get category => _category;

  set category(int category) => _category = category;

  String get name => _name;

  set name(String name) => _name = name;

  Category.fromJson(Map<String, dynamic> json) {
    _category = json['category'];
    _name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this._category;
    data['name'] = this._name;
    return data;
  }
}
