import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../helpers/custom_trace.dart';
import '../models/filters_list_response.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:http/http.dart' as http;

class FiltersController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;

  FiltersController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  Future<FiltersListResponse> getFilters() async{
    final String url =
        '${GlobalConfiguration().getString('api_base_url')}cuisine_list';
    final client = new http.Client();
    final response = await client.get(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    if (response.statusCode == 200) {
      print(response.body);
      return FiltersListResponse.fromJson(jsonDecode(response.body));
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
      throw new Exception(response.body);
    }
  }


}
