import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shifter/login.dart';

class ApiHelper {


  static returnResponse(
    http.Response response,
  ) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    if (response.statusCode == 401) {
      Get.offAll(() => Login());
      throw Exception('Not Authorized');
    }
    if (response.statusCode == 400) {
      throw Exception(jsonDecode(response.body)["message"]);
    }
    if (response.statusCode == 404) {
      // Get.offAll(() => LoginScreen());
      throw (jsonDecode(response.body)["data"]["error"].toString());
    }
    if (response.statusCode == 422) {
      throw Exception(jsonDecode(response.body)["data"]["errors"].toString());
    }
    if (response.statusCode == 500) {
      throw Exception('Server Not Responding');
    }
  }
}
