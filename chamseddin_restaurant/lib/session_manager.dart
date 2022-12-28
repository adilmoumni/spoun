import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SessionManager {
  static String FIRST_NAME = "firstName";
  static String LAST_NAME = "lastName";
  static String ADDRESS = "address";
  static String COUNTRY = "country";
  static String BIRTHDATE = "birthdate";
  static String COUNTRY_CODE = "countryCode";
  static String MOBILE_NUMBER = "mobileNumber";
  static String EMAIL = "email";
  static String PASSWORD = "password";
  static String VCODE = "vCode";
  static String SOCIAL_ID = 'socialId';
  static String SOCIAL_NAME = 'socialName';
  static String DEVICE_TOKEN = 'deviceToken';

  static SharedPreferences _prefs;

  /* static  setRefreshAccessToken(String accessToken) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(USER_ACCESS_TOKEN, accessToken);
    prefs.commit();
  }*/

  static setLoginCredentials(
      String firstName,
      String lastName,
      String address,
      String country,
      String birthdate,
      String countryCode,
      String mobileNumber,
      String email,
      String password,
      String deviceToken,
     ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(FIRST_NAME, firstName);
    prefs.setString(LAST_NAME, lastName);
    prefs.setString(ADDRESS, address);
    prefs.setString(COUNTRY, country);
    prefs.setString(BIRTHDATE, birthdate);
    prefs.setString(COUNTRY_CODE, countryCode);
    prefs.setString(MOBILE_NUMBER, mobileNumber);
    prefs.setString(EMAIL, email);
    prefs.setString(PASSWORD, password);
    prefs.setString(DEVICE_TOKEN, deviceToken);
//    prefs.setString(SOCIAL_ID, socialId);
//    prefs.setString(SOCIAL_NAME, socialName);
    prefs.commit();
  }

  static setIsRated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isPreviouslyRated', true);
    prefs.setBool('isRated', true);
    prefs.commit();
    bool isRated = await SessionManager.getIsRated();
    print(isRated);
  }
//payment page to here
  static setRating() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    //DateTime now = DateTime.now().add(const Duration(hours: 1));
    DateTime now = await DateTime.now().add(const Duration(hours: 1));
    int popupTime = now.millisecondsSinceEpoch;
    prefs.setInt('popupTime', popupTime);
    prefs.setBool('isPreviouslyRated', false);
    prefs.setBool('isRated', false);

    prefs.commit();
  }
//home check
  static getIsRated() async {
    if(_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs.getBool('isRated');
  }

  static getpopupTime() async {
    if(_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs.getInt('popupTime');
  }

  static isPreviouslyRated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isPreviouslyRated', true);
    prefs.commit();
  }

  static getIsPreviouslyRated() async {
    if(_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs.getBool('isPreviouslyRated');
  }

  static setMobile(String countryCode, String mobileNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(COUNTRY_CODE, countryCode);
    prefs.setString(MOBILE_NUMBER, mobileNumber);
    prefs.commit();
  }

  static setSocialId(String socialId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(SOCIAL_ID, socialId);
    prefs.commit();
  }

  static setSocialName(String socialName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(SOCIAL_NAME, socialName);
    prefs.commit();
  }

  static Future<bool> isLoggedIn() async {
    String email = await SessionManager.getEmail();
    String password = await SessionManager.getPassword();
    return email != null && password != null;
  }

  static getFirstName() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs.getString(FIRST_NAME);
  }

  static getLastName() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs.getString(LAST_NAME);
  }


  static getDeviceToken() async {
    if(_prefs == null) {

      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs.getString(DEVICE_TOKEN);
  }

  static getAddress() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs.getString(ADDRESS);
  }

  static getCountry() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs.getString(COUNTRY);
  }

  static getBirthdate() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs.getString(BIRTHDATE);
  }

  static getCountryCode() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs.getString(COUNTRY_CODE);
  }

  static getMobileNumber() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs.getString(MOBILE_NUMBER);
  }

  static getEmail() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs.getString(EMAIL);
  }

  static getPassword() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs.getString(PASSWORD);
  }

  static getSocialId() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs.getString(SOCIAL_ID);
  }

  static getSocialName() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs.getString(SOCIAL_NAME);
  }

  static Future<void> clearSession() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    _prefs.clear();
  }
}
