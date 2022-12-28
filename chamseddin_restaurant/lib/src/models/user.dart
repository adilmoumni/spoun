import '../helpers/custom_trace.dart';
import '../models/media.dart';

class User {
  String id;
  String name;
  String email;
  String password;
  String oldPassword;
  String familyName;
  String country;
  String apiToken;
  String deviceToken;
  String countryCode;
  String birthDate;
  String mobileNumber;
  String address;
  String vCode;
  String stripeId;
  String cardBrand;
  String cardLastFour;
  String trialEndsAt;
  String braintreeId;
  String paypalEmail;
  String createdAt;
  String updatedAt;
  String socialId;
  String socialName;
  int code;
  List<String> customFields;
  bool hasMedia;
  List<String> media;

//  String bio;
  Media image;

  // used for indicate if client logged in or not
  bool auth;

//  String role;

  User(
      {this.id,
      this.name,
      this.email,
      this.apiToken,
      this.deviceToken,
      this.stripeId,
      this.cardBrand,
      this.cardLastFour,
      this.trialEndsAt,
      this.braintreeId,
      this.paypalEmail,
      this.createdAt,
      this.updatedAt,
      this.vCode,
      this.code,
      this.customFields,
      this.hasMedia,
      this.media,
      this.socialId,
      this.socialName});

  User.fromJSON(Map<String, dynamic> json) {
    try {
      id = json['id'] is int ? json['id'].toString() : json['id'];
      name = json['name'];
      email = json['email'];
      apiToken = json['api_token'];
      deviceToken = json['device_token'];
      stripeId = json['stripe_id'];
      cardBrand = json['card_brand'];
      cardLastFour = json['card_last_four'];
      trialEndsAt = json['trial_ends_at'];
      braintreeId = json['braintree_id'];
      paypalEmail = json['paypal_email'];
      createdAt = json['created_at'];
      updatedAt = json['updated_at'];
      vCode = json['v_code'];
      code = json['code'];
      hasMedia = json['has_media'];
      socialId = json['social_id'];
      socialName = json['social_name'];
      countryCode = json['country_code'];
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;
    map["password"] = password;
    map["old_password"] = oldPassword;
    map["family_name"] = familyName;
    map["birth_date"] = birthDate;
    map["country_code"] = countryCode;
    map["api_token"] = apiToken;
    if (deviceToken != null) {
      map["device_token"] = deviceToken;
    }
    map["mobile_number"] = mobileNumber;
    map["address"] = address;
    map["v_code"] = vCode;
    map['stripe_id'] = stripeId;
    map['card_brand'] = this.cardBrand;
    map['card_last_four'] = this.cardLastFour;
    map['trial_ends_at'] = this.trialEndsAt;
    map['braintree_id'] = this.braintreeId;
    map['paypal_email'] = this.paypalEmail;
    map['created_at'] = this.createdAt;
    map['updated_at'] = this.updatedAt;
    map['v_code'] = this.vCode;
    map['code'] = this.code;
    map['custom_fields'] = this.customFields;
    map['has_media'] = this.hasMedia;
    map['media'] = this.media;
    map['social_id'] = this.socialId;
    map['social_name'] = this.socialName;
    map['country_code'] = countryCode;

//    map["bio"] = bio;
    map["media"] = image?.toMap();
    return map;
  }

  @override
  String toString() {
    var map = this.toMap();
    map["auth"] = this.auth;
    return map.toString();
  }

  bool profileCompleted() {
    return address != null &&
        address != '' &&
        mobileNumber != null &&
        mobileNumber != '';
  }
}
