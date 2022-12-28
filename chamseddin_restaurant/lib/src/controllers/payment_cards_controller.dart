import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/place_order_request.dart';
import 'package:food_delivery_app/src/models/place_order_response.dart';
import 'package:http/http.dart' as http;
import 'package:mvc_pattern/mvc_pattern.dart';

import '../constants.dart';
import '../models/customers.dart';
import '../models/payment_intent_response.dart';
import '../models/payment_methods.dart';
import '../repository/user_repository.dart' as repository;

class PaymentCardController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  GlobalKey<FormState> loginFormKey;
  OverlayEntry loader;

  PaymentCardController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  Future<PaymentMethods> getPaymentMethods(Customer customer) async {
    var url = 'https://api.stripe.com/v1/payment_methods?customer=' +
        customer.id +
        '&type=card';

    String username = Constants.stripe_current_secret;
    String password = '';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'authorization': basicAuth
      },
    );
    Map<String, dynamic> decodedJSON = {};
    decodedJSON = json.decode(response.body) as Map<String, dynamic>;
    return PaymentMethods.fromJson(decodedJSON);
  }

  Future<Data> attachPaymentMethodToCustomer(String paymentId,
      String customerId, GlobalKey<ScaffoldState> scaffoldKey) async {
    var url =
        'https://api.stripe.com/v1/payment_methods/' + paymentId + '/attach';
    var map = new Map<String, dynamic>();
    map['customer'] = customerId;

    String username = Constants.stripe_current_secret;
    String password = '';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'authorization': basicAuth
      },
      body: map,
    );
    Map<String, dynamic> decodedJSON = {};
    if (response.statusCode == 200) {
      decodedJSON = json.decode(response.body) as Map<String, dynamic>;
      return Data.fromJson(decodedJSON);
    } else {
      scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(json.decode(response.body)["error"]["message"])));
      return null;
    }
  }

  Future<Data> detachPaymentMethodFromCustomer(String paymentId) async {
    var url =
        'https://api.stripe.com/v1/payment_methods/' + paymentId + '/detach';

    String username = Constants.stripe_current_secret;
    String password = '';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'authorization': basicAuth
      },
    );
    Map<String, dynamic> decodedJSON = {};
    decodedJSON = json.decode(response.body) as Map<String, dynamic>;
    return Data.fromJson(decodedJSON);
  }

  Future<http.Response> createPaymentIntent(
      double amount, String paymentId, String customerId) async {
    var url = 'https://api.stripe.com/v1/payment_intents';
    var map = new Map<String, dynamic>();
    map['amount'] = '${(amount * 100).toInt()}';
    map['currency'] = 'usd';
    map['payment_method'] = paymentId;
    map['customer'] = customerId;

    String username = Constants.stripe_current_secret;
    String password = '';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);

    var response = await http.post(
      url,
      headers: <String, String>{'authorization': basicAuth},
      body: map,
    );
    return response;
  }

  Future<http.Response> confirmPaymentIntent(String payment_id) async {
    var url = 'https://api.stripe.com/v1/payment_intents/' + payment_id + '/confirm';

    print('Stripe' + url);
    String username = Constants.stripe_current_secret;
    String password = '';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);

    var response = await http.post(url, headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
      'authorization': basicAuth
    });

    return response;
  }

  void payByCard(String paymentId, double amount, String customerId,
      PaymentCompletedCallback paymentCompletedCallback) async {
    if (paymentId != null) {
      createPaymentIntent(amount, paymentId, customerId).then((response) {
        if (response.statusCode == 200) {
          PaymentIntentResponse paymentIntentResponse =
              PaymentIntentResponse.fromJson(jsonDecode(response.body));
//          print('Stripe::::'+response.body);
          confirmPaymentIntent(paymentIntentResponse.id)
              .then((paymentConfirmationResponse) => {
                    if (paymentConfirmationResponse.statusCode == 200)
                      {paymentCompletedCallback.successCallBack(),
                        print("Payment:::" +paymentConfirmationResponse.body.toString())}
                    else
                      {
                        paymentCompletedCallback
                            .error(paymentConfirmationResponse.reasonPhrase)
                      }
                  });
        } else {
          paymentCompletedCallback.error(response.reasonPhrase);
        }
      });
    }
  }

  void getCustomer(String customerId, GetCustomerCallback getCustomerCallback) {
    findCustomer(customerId).then((customer) {
      if (customer != null) {
        getCustomerCallback.onCustomerFetched(customer);
      } else {
        createCustomer(customerId).then((customer) {
          getCustomerCallback.onCustomerFetched(customer);
        });
      }
    });
  }

  Future<Customer> createCustomer(String customerId) async {
    var url = 'https://api.stripe.com/v1/customers';

    String username = Constants.stripe_current_secret;
    String password = '';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);

    var map = new Map<String, dynamic>();
    map['id'] = customerId;

    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'authorization': basicAuth
        },
        body: map);

    Map<String, dynamic> decodedJSON = {};
    decodedJSON = json.decode(response.body) as Map<String, dynamic>;
    return Customer.fromJson(decodedJSON);
  }

  Future<Customer> findCustomer(String customerId) async {
    var url = 'https://api.stripe.com/v1/customers/' + customerId;

    String username = Constants.stripe_current_secret;
    String password = '';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);

    var response = await http.post(url, headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
      'authorization': basicAuth
    });

    Map<String, dynamic> decodedJSON = {};
    decodedJSON = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      return Customer.fromJson(decodedJSON);
    } else {
      return null;
    }
  }

  Future<PlaceOrderResponse> placeOrder(PlaceOrderRequest placeOrderRequest) {
   return repository.placeOrder(placeOrderRequest);

  }
}

abstract class PaymentCompletedCallback {
  successCallBack();

  error(message);
}

abstract class GetCustomerCallback {
  onCustomerFetched(Customer customer);

  error(message);
}
