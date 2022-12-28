import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/custom_trace.dart';
import '../models/mobile_verification.dart';
import '../models/otp_response.dart';
import '../models/verify_otp_response.dart';

Future<OtpResponse> sendOTP(MobileVerification mobileVerification) async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}sendOtp';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(mobileVerification.toMap()),
  );
  if (response.statusCode == 200) {
    print(response.body);
    return OtpResponse.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 202) {
    print(response.body);
    return OtpResponse.fromJson(jsonDecode(response.body));
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }
}

Future<VerifyOtpResponse> verifyOtp(
    MobileVerification mobileVerification) async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}verifyOtp';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(mobileVerification.toMap()),
  );
  if (response.statusCode == 200) {
    return VerifyOtpResponse.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 202) {
    print(response.body);
    return VerifyOtpResponse.fromJson(jsonDecode(response.body));
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    return null;
  }
}
