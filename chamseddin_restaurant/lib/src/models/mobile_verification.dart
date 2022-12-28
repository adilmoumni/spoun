import 'package:food_delivery_app/src/helpers/custom_trace.dart';

class MobileVerification {

  String countryCode;
  String mobileNumber;
  String email;
  String vCode;
  var otp;

  MobileVerification();

  MobileVerification.fromJson(Map<String, dynamic> jsonMap){
    try{
      email = jsonMap['email'];
      vCode = jsonMap['vCode'];
      otp = jsonMap['otp'];
      try {
        countryCode = jsonMap['custom_fields']['mobile_number']['view'];
      } catch (e) {
        countryCode = "";
      }
      try {
        mobileNumber = jsonMap['custom_fields']['mobile_number']['view'];
      } catch (e) {
        mobileNumber = "";
      }
    }
    catch (e) {
      print(CustomTrace(StackTrace.current, message : e));
    }
  }

  Map toMap() {
    var map = new Map<String,dynamic>();
    map['country_code'] = countryCode;
    map['mobile_number'] = mobileNumber;
    map['email'] = email;
    map['v_code'] = vCode;
    map['otp'] = otp;
    return map;
  }
}