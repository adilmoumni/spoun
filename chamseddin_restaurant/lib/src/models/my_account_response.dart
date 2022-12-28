class MyAccountResponse {
  Response response;

  MyAccountResponse({this.response});

  MyAccountResponse.fromJson(Map<String, dynamic> json) {
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
  List<MyAccountUser> data;
  int code;

  Response({this.message, this.data, this.code});

  Response.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = new List<MyAccountUser>();
      json['data'].forEach((v) {
        data.add(new MyAccountUser.fromJson(v));
      });
    }
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['code'] = this.code;
    return data;
  }
}

class MyAccountUser {
  int userId;
  String name;
  String familyName;
  String email;
  String countryCode;
  String phone;
  String image;

  MyAccountUser(
      {this.userId,
        this.name,
        this.familyName,
        this.email,
        this.countryCode,
        this.phone,
        this.image});

  MyAccountUser.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    familyName = json['family_name'];
    email = json['email'];
    countryCode = json['country_code'];
    phone = json['phone'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['family_name'] = this.familyName;
    data['email'] = this.email;
    data['country_code'] = this.countryCode;
    data['phone'] = this.phone;
    data['image'] = this.image;
    return data;
  }
}