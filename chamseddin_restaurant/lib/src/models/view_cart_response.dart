import 'add_on.dart';
import 'recipe.dart';

class ViewCartResponse {
  ViewCartRes _response;

  ViewCartResponse({ViewCartRes response}) {
    this._response = response;
  }

  ViewCartRes get response => _response;

  set response(ViewCartRes response) => _response = response;

  ViewCartResponse.fromJson(Map<String, dynamic> json) {
    _response = json['response'] != null
        ? new ViewCartRes.fromJson(json['response'])
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

class ViewCartRes {
  String _message;
  ViewCartData _data;
  int _code;

  ViewCartRes({String message, ViewCartData data, int code}) {
    this._message = message;
    this._data = data;
    this._code = code;
  }

  String get message => _message;

  set message(String message) => _message = message;

  ViewCartData get data => _data;

  set data(ViewCartData data) => _data = data;

  int get code => _code;

  set code(int code) => _code = code;

  ViewCartRes.fromJson(Map<String, dynamic> json) {
    _message = json['message'];
    _data =
        json['data'] != null ? new ViewCartData.fromJson(json['data']) : null;
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

class ViewCartData {
  List<RestaurantList> _restaurantList;
  var _grandTotal;
  var _vat;
  var _service_fee;
  var _vat_percentage;
  String _currency_Symbol;

  ViewCartData(
      {RestaurantList meals,
      var grandTotal,
      var vat,
      var service_fee,
      var vat_percentage,
      String currency_symbol}) {
    this._restaurantList = restaurantList;
    this._grandTotal = grandTotal;
    this._vat = vat;
    this._service_fee = service_fee;
    this._vat_percentage = vat_percentage;
    this._currency_Symbol = currency_symbol;
  }

  List<RestaurantList> get restaurantList => _restaurantList;

  set restaurantList(List<RestaurantList> restaurantList) =>
      _restaurantList = restaurantList;

  double get grandTotal => _grandTotal;

  set grandTotal(double grandTotal) => _grandTotal = grandTotal;

  double get vat => _vat;

  set vat(double vat) => _vat = vat;

  get service_fee => _service_fee;

  set service_fee(var service_fee) => _service_fee = service_fee;

  double get vat_percentage => _vat_percentage;

  set vat_percentage(double vatPercentage) => _vat_percentage = vatPercentage;

  String get currency_symbol => _currency_Symbol;

  set currency_symbol(String currencySymbol) =>
      _currency_Symbol = currencySymbol;

  ViewCartData.fromJson(Map<String, dynamic> json) {
    if (json['restaurant_list'] != null) {
      _restaurantList = new List<RestaurantList>();
      json['restaurant_list'].forEach((v) {
        _restaurantList.add(new RestaurantList.fromJson(v));
      });
    }
    _grandTotal = json['grand_total'] is int
        ? (json['grand_total'] as int).toDouble()
        : json['grand_total'];
    _vat = json['vat'] is int ? (json['vat'] as int).toDouble() : json['vat'];
    _service_fee = json['service_fee'] is int
        ? (json['service_fee'] as int).toString()
        : json['service_fee'];
    _vat_percentage = json['vat_percentage'] is int
        ? (json['vat_percentage'] as int).toString()
        : json['vat_percentage'];
    _currency_Symbol = json['currency_symbol'];
//    is int
//        ? (json['service_fee'] as int).toDouble()
//        : json['service_fee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._restaurantList != null) {
      data['restaurant_list'] =
          this._restaurantList.map((v) => v.toJson()).toList();
    }
    data['grand_total'] = this._grandTotal;
    data['vat'] = this._vat;
    data['service_fee'] = this._service_fee;
    data['vat_percentage'] = this._vat_percentage;
    return data;
  }
}

class RestaurantList {
  String _restaurantName;
  int _restaurantId;
  List<ViewCartFoodDetail> _foodDetail;
  double _restTotal;
  String specificInstructions;
  dynamic _discount;
  dynamic _beforeDiscount;
  String _promoResponse;
  dynamic _promoId;
  String _promoCode;

  RestaurantList(
      {int restaurantId,
      String restaurantName,
      List<ViewCartFoodDetail> foodDetail,
      double restTotal,
      String discount,
      String beforeDiscount,
      String promoResponse,
      String promoId,
      String promoCode}) {
    this._restaurantName = restaurantName;
    this._restaurantId = restaurantId;
    this._foodDetail = foodDetail;
    this._restTotal = restTotal;
    this._discount = discount;
    this._beforeDiscount = beforeDiscount;
    this._promoResponse = promoResponse;
    this._promoId = promoId;
    this._promoCode = promoCode;
  }

  String get restaurantName => _restaurantName;

  set restaurantName(String restaurantName) => _restaurantName = restaurantName;

  dynamic get discount => _discount;

  set discount(String discount) => _discount = discount;

  dynamic get beforeDiscount => _beforeDiscount;

  set beforeDiscount(String beforeDiscount) => _beforeDiscount = beforeDiscount;

  String get promoResponse => _promoResponse;

  set promoResponse(String promoResponse) => _promoResponse = promoResponse;

  dynamic get promoId => _promoId;

  set promoId(String promoId) => _promoId = promoId;

  int get restaurantId => _restaurantId;

  set restaurantId(int restaurantId) => _restaurantId = restaurantId;

  String get promoCode => _promoCode;

  set promoCode(String promoCode) => _promoCode = promoCode;

  List<ViewCartFoodDetail> get foodDetail => _foodDetail;

  set foodDetail(List<ViewCartFoodDetail> foodDetail) =>
      _foodDetail = foodDetail;

  double get restTotal => _restTotal;

  set restTotal(double restTotal) => _restTotal = restTotal;

  RestaurantList.fromJson(Map<String, dynamic> json) {
    _restaurantId = json['restaurant_id'];
    _restaurantName = json['restaurant_name'];
    if (json['food-detail'] != null) {
      _foodDetail = new List<ViewCartFoodDetail>();
      json['food-detail'].forEach((v) {
        _foodDetail.add(new ViewCartFoodDetail.fromJson(v));
      });
    }
    _restTotal = json['rest_total'] is int
        ? (json['rest_total'] as int).toDouble()
        : json['rest_total'];
    _discount = json['discount'];
    _beforeDiscount = json['before_discount'];
    _promoResponse = json['promo_response'];
    _promoId = json['promo_id'];
    _promoCode = json['promo_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurant_id'] = this._restaurantId;
    data['restaurant_name'] = this._restaurantName;
    if (this._foodDetail != null) {
      data['food-detail'] = this._foodDetail.map((v) => v.toJson()).toList();
    }
    data['rest_total'] = this._restTotal;
    data['discount'] = this._discount;
    data['before_discount'] = this._beforeDiscount;
    data['promo_response'] = this._promoResponse;
    data['promo_id'] = this._promoId;
    data['promo_code'] = this._promoCode;
    return data;
  }
}

class ViewCartFoodDetail {
  int _cartId;
  int _menuId;
  String _name;
  List<AddOn> _addon;
  List<ViewCartRecipes> _recipe;
  List<ViewCartLists> _lists;
  dynamic _price;
  int _quantity;

  ViewCartFoodDetail(
      {int cartId,
      int menuId,
      String name,
      List<AddOn> addon,
      List<ViewCartRecipes> recipe,
      List<ViewCartLists> lists,
      var price,
      int quantity}) {
    this._cartId = cartId;
    this._menuId = menuId;
    this._name = name;
    this._addon = addon;
    this._recipe = recipe;
    this._lists = lists;
    this._price = price;
    this._quantity = quantity;
  }

  int get cartId => _cartId;

  set cartId(int cartId) => _cartId = cartId;

  int get menuId => _menuId;

  set menuId(int menuId) => _menuId = menuId;

  String get name => _name;

  set name(String name) => _name = name;

  List<AddOn> get addon => _addon;

  set addon(List<AddOn> addon) => _addon = addon;

  List<ViewCartRecipes> get recipe => _recipe;

  set recipe(List<ViewCartRecipes> recipe) => _recipe = recipe;

  List<ViewCartLists> get lists => _lists;

  set lists(List<ViewCartLists> lists) => _lists = lists;

  double get price => _price;

  set price(double price) => _price = price;

  int get quantity => _quantity;

  set quantity(int quantity) => _quantity = quantity;

  ViewCartFoodDetail.fromJson(Map<String, dynamic> json) {
    _cartId = json['cart_id'];
    _menuId = json['menu_id'];
    _name = json['name'];
    if (json['addon'] != null) {
      _addon = new List<AddOn>();
      json['addon'].forEach((v) {
        _addon.add(new AddOn.fromJson(v));
      });
    }
    if (json['recipes'] != null) {
      _recipe = new List<ViewCartRecipes>();
      json['recipes'].forEach((v) {
        _recipe.add(new ViewCartRecipes.fromJson(v));
      });
    }
    if (json['lists'] != null) {
      _lists = new List<ViewCartLists>();
      json['lists'].forEach((v) {
        _lists.add(new ViewCartLists.fromJson(v));
      });
    }
    _price = doubleConvert(json['price']);
    _quantity = json['quantity'];
  }
  double doubleConvert(dynamic value) {
    if (value != null && value.toString() != "") {
      return double.parse(value.toString());
    } else {
      return 0.0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cart_id'] = this._cartId;
    data['menu_id'] = this._menuId;
    data['name'] = this._name;
    data['addon'] = this._addon;
    if (this._recipe != null) {
      data['recipes'] = this._recipe.map((v) => v.toJson()).toList();
    }
    if (this._lists != null) {
      data['lists'] = this._lists.map((v) => v.toJson()).toList();
    }
    data['price'] = this._price;
    data['quantity'] = this._quantity;
    return data;
  }
}

class ViewCartRecipes {
  int item_id;
  List<Recipe> _recipe;

  List<Recipe> get recipe => _recipe;

  set recipe(List<Recipe> recipe) => _recipe = recipe;

  ViewCartRecipes({int item_id, List<Recipe> recipe}) {
    this.item_id = item_id;
    this._recipe = recipe;
  }

  ViewCartRecipes.fromJson(Map<String, dynamic> json) {
    item_id = json['item_id'];
    if (json['recipe'] != null) {
      _recipe = new List<Recipe>();
      json['recipe'].forEach((v) {
        _recipe.add(new Recipe.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_id'] = this.item_id;
    if (this._recipe != null) {
      data['recipe'] = this._recipe.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ViewCartLists {
  String _list_name;
  List<ViewCartListItem> _list;

  ViewCartLists({String list_name, List<ViewCartListItem> list}) {
    this._list_name = list_name;
    this._list = list;
  }

  String get list_name => _list_name;

  set list_name(String list) => _list_name = list_name;

  List<ViewCartListItem> get list => _list;

  set list(List<ViewCartListItem> list) => _list = list;

  ViewCartLists.fromJson(Map<String, dynamic> json) {
    _list_name = json['list_name'];
    if (json['list'] != null) {
      _list = new List<ViewCartListItem>();
      json['list'].forEach((v) {
        _list.add(new ViewCartListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['list_name'] = this._list_name;
    if (this._list != null) {
      data['list'] = this._list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ViewCartListItem {
  String _name;
  int _choice_id;
  dynamic _price;

  ViewCartListItem({String name, dynamic price, int choice_id}) {
    this._name = name;
    this._choice_id = choice_id;
    this._price = price;
  }

  String get name => _name;

  set name(String name) => _name = name;

  int get choice_id => _choice_id;

  set choice_id(int choice_id) => _choice_id = choice_id;

  dynamic get price => _price;

  set price(dynamic price) => _price = price;

  ViewCartListItem.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _choice_id = json['choice_id'];
    _price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['choice_id'] = this._choice_id;
    data['price'] = this._price;
    return data;
  }
}
