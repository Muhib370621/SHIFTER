import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;


import '../core/api_helper.dart';
import '../core/app_headers.dart';
import '../core/app_urls.dart';

class AppServices {

  driverLogin(
      String phone,
      String tokenKey,
      ) async {
    // url
    String url = AppUrls.loginDriverUrl;

    //header
    var header = AppHeaders.contentTypeWIthApplicationJsonOnly();

    //body
    var data = {
      "phone": phone,
      "tokenKey": tokenKey
    };
    var response = await http.post(
      Uri.parse(url),
      body: jsonEncode(data),
      headers: header
    );
    if (kDebugMode) {
      print("Called API: $url");
      print("Status Code: ${response.statusCode}");
      print("Sent Body: ${data.toString()}");
      print("Response Body: ${response.body}");
      print("HEADERS: $header");
    }
    return ApiHelper.returnResponse(response);
  }

  verifyDriverOtp(
      String phone,
      String tokenKey,
      ) async {
    // url
    String url = AppUrls.loginDriverUrl;

    //header
    var header = AppHeaders.contentTypeWIthApplicationJsonOnly();

    //body
    var data = {
      "phone": phone,
      "tokenKey": tokenKey
    };
    var response = await http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: header
    );
    if (kDebugMode) {
      print("Called API: $url");
      print("Status Code: ${response.statusCode}");
      print("Sent Body: ${data.toString()}");
      print("Response Body: ${response.body}");
      print("HEADERS: $header");
    }
    return ApiHelper.returnResponse(response);
  }

}
