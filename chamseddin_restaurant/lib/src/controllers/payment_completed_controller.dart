import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class PaymentCompletedController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;

  PaymentCompletedController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }
}
