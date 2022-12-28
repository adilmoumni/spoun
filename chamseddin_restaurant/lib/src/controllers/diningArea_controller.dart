import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../helpers/helper.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class DiningAreaController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  OverlayEntry loader;
  GlobalKey<FormState> loginFormKey;

  DiningAreaController() {
    loader = Helper.overlayLoader(context);
  }
}
