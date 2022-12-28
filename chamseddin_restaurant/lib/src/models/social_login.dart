class SocialLogin {
  Response response;

  SocialLogin({this.response});

  SocialLogin.fromJson(Map<String, dynamic> json) {
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
  int id;
  String name;
  String email;
  String apiToken;
  String deviceToken;
  String stripeId;
  String cardBrand;
  String cardLastFour;
  String trialEndsAt;
  String braintreeId;
  String paypalEmail;
  String createdAt;
  String updatedAt;
  String vCode;
  String socialName;
  String socialId;
  int code;
  List<dynamic> customFields;
  bool hasMedia;
  List<dynamic> media;

  Response(
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
        this.socialName,
        this.socialId,
        this.code,
        this.customFields,
        this.hasMedia,
        this.media});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
    socialName = json['social_name'];
    socialId = json[''];
    code = json['code'];
    customFields = json['custom_fields'];
    hasMedia = json['has_media'];
    media = json['media'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['api_token'] = this.apiToken;
    data['device_token'] = this.deviceToken;
    data['stripe_id'] = this.stripeId;
    data['card_brand'] = this.cardBrand;
    data['card_last_four'] = this.cardLastFour;
    data['trial_ends_at'] = this.trialEndsAt;
    data['braintree_id'] = this.braintreeId;
    data['paypal_email'] = this.paypalEmail;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['v_code'] = this.vCode;
    data['social_name'] = this.socialName;
    data['social_id'] = this.socialId;
    data['code'] = this.code;

      data['custom_fields'] = this.customFields;

    data['has_media'] = this.hasMedia;
    data['media'] = this.media;

    return data;
  }
}