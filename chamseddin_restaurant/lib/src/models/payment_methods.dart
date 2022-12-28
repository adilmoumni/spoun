class PaymentMethods {
  String _object;
  List<Data> _data;
  bool _hasMore;
  String _url;

  PaymentMethods({String object, List<Data> data, bool hasMore, String url}) {
    this._object = object;
    this._data = data;
    this._hasMore = hasMore;
    this._url = url;
  }

  String get object => _object;
  set object(String object) => _object = object;
  List<Data> get data => _data;
  set data(List<Data> data) => _data = data;
  bool get hasMore => _hasMore;
  set hasMore(bool hasMore) => _hasMore = hasMore;
  String get url => _url;
  set url(String url) => _url = url;

  PaymentMethods.fromJson(Map<String, dynamic> json) {
    _object = json['object'];
    if (json['data'] != null) {
      _data = new List<Data>();
      json['data'].forEach((v) { _data.add(new Data.fromJson(v)); });
    }
    _hasMore = json['has_more'];
    _url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['object'] = this._object;
    if (this._data != null) {
      data['data'] = this._data.map((v) => v.toJson()).toList();
    }
    data['has_more'] = this._hasMore;
    data['url'] = this._url;
    return data;
  }
}

class Data {
  String _id;
  String _object;
  BillingDetails _billingDetails;
  Card _card;
  int _created;
  String _customer;
  bool _livemode;
  String _type;

  Data({String id, String object, BillingDetails billingDetails, Card card, int created, String customer, bool livemode, String type}) {
    this._id = id;
    this._object = object;
    this._billingDetails = billingDetails;
    this._card = card;
    this._created = created;
    this._customer = customer;
    this._livemode = livemode;
    this._type = type;
  }

  String get id => _id;
  set id(String id) => _id = id;
  String get object => _object;
  set object(String object) => _object = object;
  BillingDetails get billingDetails => _billingDetails;
  set billingDetails(BillingDetails billingDetails) => _billingDetails = billingDetails;
  Card get card => _card;
  set card(Card card) => _card = card;
  int get created => _created;
  set created(int created) => _created = created;
  String get customer => _customer;
  set customer(String customer) => _customer = customer;
  bool get livemode => _livemode;
  set livemode(bool livemode) => _livemode = livemode;
  String get type => _type;
  set type(String type) => _type = type;

  Data.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _object = json['object'];
    _billingDetails = json['billing_details'] != null ? new BillingDetails.fromJson(json['billing_details']) : null;
    _card = json['card'] != null ? new Card.fromJson(json['card']) : null;
    _created = json['created'];
    _customer = json['customer'];
    _livemode = json['livemode'];
    _type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['object'] = this._object;
    if (this._billingDetails != null) {
      data['billing_details'] = this._billingDetails.toJson();
    }
    if (this._card != null) {
      data['card'] = this._card.toJson();
    }
    data['created'] = this._created;
    data['customer'] = this._customer;
    data['livemode'] = this._livemode;
    data['type'] = this._type;
    return data;
  }
}

class BillingDetails {
  Address _address;
  Null _email;
  Null _name;
  Null _phone;

  BillingDetails({Address address, Null email, Null name, Null phone}) {
    this._address = address;
    this._email = email;
    this._name = name;
    this._phone = phone;
  }

  Address get address => _address;
  set address(Address address) => _address = address;
  Null get email => _email;
  set email(Null email) => _email = email;
  Null get name => _name;
  set name(Null name) => _name = name;
  Null get phone => _phone;
  set phone(Null phone) => _phone = phone;

  BillingDetails.fromJson(Map<String, dynamic> json) {
    _address = json['address'] != null ? new Address.fromJson(json['address']) : null;
    _email = json['email'];
    _name = json['name'];
    _phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._address != null) {
      data['address'] = this._address.toJson();
    }
    data['email'] = this._email;
    data['name'] = this._name;
    data['phone'] = this._phone;
    return data;
  }
}

class Address {
  Null city;
  String country;
  Null line1;
  Null line2;
  Null postalCode;
  Null state;

  Address(
      {this.city,
        this.country,
        this.line1,
        this.line2,
        this.postalCode,
        this.state});

  Address.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    country = json['country'];
    line1 = json['line1'];
    line2 = json['line2'];
    postalCode = json['postal_code'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['country'] = this.country;
    data['line1'] = this.line1;
    data['line2'] = this.line2;
    data['postal_code'] = this.postalCode;
    data['state'] = this.state;
    return data;
  }
}

class Card {
  String _brand;
  Checks _checks;
  String _country;
  int _expMonth;
  int _expYear;
  String _fingerprint;
  String _funding;
  Null _generatedFrom;
  String _last4;
  Networks _networks;
  ThreeDSecureUsage _threeDSecureUsage;
  Null _wallet;

  Card({String brand, Checks checks, String country, int expMonth, int expYear, String fingerprint, String funding, Null generatedFrom, String last4, Networks networks, ThreeDSecureUsage threeDSecureUsage, Null wallet}) {
    this._brand = brand;
    this._checks = checks;
    this._country = country;
    this._expMonth = expMonth;
    this._expYear = expYear;
    this._fingerprint = fingerprint;
    this._funding = funding;
    this._generatedFrom = generatedFrom;
    this._last4 = last4;
    this._networks = networks;
    this._threeDSecureUsage = threeDSecureUsage;
    this._wallet = wallet;
  }

  String get brand => _brand;
  set brand(String brand) => _brand = brand;
  Checks get checks => _checks;
  set checks(Checks checks) => _checks = checks;
  String get country => _country;
  set country(String country) => _country = country;
  int get expMonth => _expMonth;
  set expMonth(int expMonth) => _expMonth = expMonth;
  int get expYear => _expYear;
  set expYear(int expYear) => _expYear = expYear;
  String get fingerprint => _fingerprint;
  set fingerprint(String fingerprint) => _fingerprint = fingerprint;
  String get funding => _funding;
  set funding(String funding) => _funding = funding;
  Null get generatedFrom => _generatedFrom;
  set generatedFrom(Null generatedFrom) => _generatedFrom = generatedFrom;
  String get last4 => _last4;
  set last4(String last4) => _last4 = last4;
  Networks get networks => _networks;
  set networks(Networks networks) => _networks = networks;
  ThreeDSecureUsage get threeDSecureUsage => _threeDSecureUsage;
  set threeDSecureUsage(ThreeDSecureUsage threeDSecureUsage) => _threeDSecureUsage = threeDSecureUsage;
  Null get wallet => _wallet;
  set wallet(Null wallet) => _wallet = wallet;

  Card.fromJson(Map<String, dynamic> json) {
    _brand = json['brand'];
    _checks = json['checks'] != null ? new Checks.fromJson(json['checks']) : null;
    _country = json['country'];
    _expMonth = json['exp_month'];
    _expYear = json['exp_year'];
    _fingerprint = json['fingerprint'];
    _funding = json['funding'];
    _generatedFrom = json['generated_from'];
    _last4 = json['last4'];
    _networks = json['networks'] != null ? new Networks.fromJson(json['networks']) : null;
    _threeDSecureUsage = json['three_d_secure_usage'] != null ? new ThreeDSecureUsage.fromJson(json['three_d_secure_usage']) : null;
    _wallet = json['wallet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brand'] = this._brand;
    if (this._checks != null) {
      data['checks'] = this._checks.toJson();
    }
    data['country'] = this._country;
    data['exp_month'] = this._expMonth;
    data['exp_year'] = this._expYear;
    data['fingerprint'] = this._fingerprint;
    data['funding'] = this._funding;
    data['generated_from'] = this._generatedFrom;
    data['last4'] = this._last4;
    if (this._networks != null) {
      data['networks'] = this._networks.toJson();
    }
    if (this._threeDSecureUsage != null) {
      data['three_d_secure_usage'] = this._threeDSecureUsage.toJson();
    }
    data['wallet'] = this._wallet;
    return data;
  }
}

class Checks {
  Null _addressLine1Check;
  Null _addressPostalCodeCheck;
  String _cvcCheck;

  Checks({Null addressLine1Check, Null addressPostalCodeCheck, String cvcCheck}) {
    this._addressLine1Check = addressLine1Check;
    this._addressPostalCodeCheck = addressPostalCodeCheck;
    this._cvcCheck = cvcCheck;
  }

  Null get addressLine1Check => _addressLine1Check;
  set addressLine1Check(Null addressLine1Check) => _addressLine1Check = addressLine1Check;
  Null get addressPostalCodeCheck => _addressPostalCodeCheck;
  set addressPostalCodeCheck(Null addressPostalCodeCheck) => _addressPostalCodeCheck = addressPostalCodeCheck;
  String get cvcCheck => _cvcCheck;
  set cvcCheck(String cvcCheck) => _cvcCheck = cvcCheck;

  Checks.fromJson(Map<String, dynamic> json) {
    _addressLine1Check = json['address_line1_check'];
    _addressPostalCodeCheck = json['address_postal_code_check'];
    _cvcCheck = json['cvc_check'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_line1_check'] = this._addressLine1Check;
    data['address_postal_code_check'] = this._addressPostalCodeCheck;
    data['cvc_check'] = this._cvcCheck;
    return data;
  }
}

class Networks {
  List<String> _available;
  Null _preferred;

  Networks({List<String> available, Null preferred}) {
    this._available = available;
    this._preferred = preferred;
  }

  List<String> get available => _available;
  set available(List<String> available) => _available = available;
  Null get preferred => _preferred;
  set preferred(Null preferred) => _preferred = preferred;

  Networks.fromJson(Map<String, dynamic> json) {
    _available = json['available'].cast<String>();
    _preferred = json['preferred'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['available'] = this._available;
    data['preferred'] = this._preferred;
    return data;
  }
}

class ThreeDSecureUsage {
  bool _supported;

  ThreeDSecureUsage({bool supported}) {
    this._supported = supported;
  }

  bool get supported => _supported;
  set supported(bool supported) => _supported = supported;

  ThreeDSecureUsage.fromJson(Map<String, dynamic> json) {
    _supported = json['supported'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['supported'] = this._supported;
    return data;
  }
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  return data;
}
