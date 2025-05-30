import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shifter/model/api_models/get_driver_all_orders.dart';
import 'package:shifter/model/api_models/get_driver_by_ID.dart';
import 'package:shifter/model/api_models/get_driver_new_orders.dart';
import 'package:shifter/model/api_models/get_order_by_ID.dart';
import 'package:shifter/services/local_storage/local_storage.dart';
import 'package:shifter/services/local_storage/local_storage_keys.dart';

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
    var data = {"phone": phone, "tokenKey": tokenKey};
    var response = await http.post(Uri.parse(url),
        body: jsonEncode(data), headers: header);
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
    // String customerID,
    String verifyCode,
  ) async {
    // url
    String url = AppUrls.verifyDriverOtpUrl;

    //header
    var header = AppHeaders.contentTypeWIthApplicationJsonOnly();

    //body
    var data = {
      "customerID": LocalStorage.readJson(key: LocalStorageKeys.customerID),
      "verifyCode": verifyCode
    };
    var response = await http.post(Uri.parse(url),
        body: jsonEncode(data), headers: header);
    if (kDebugMode) {
      print("Called API: $url");
      print("Status Code: ${response.statusCode}");
      print("Sent Body: ${data.toString()}");
      print("Response Body: ${response.body}");
      print("HEADERS: $header");
    }
    return ApiHelper.returnResponse(response);
  }

  Future<GetDriverByIdModel> getDriverByID(// String customerID,
      // String verifyCode,
      ) async {
    // url
    String url = AppUrls.getDriverByID;

    //header
    var header = AppHeaders.contentTypeWIthApplicationJsonAndAccessToken(
      LocalStorage.readJson(
        key: LocalStorageKeys.accessToken,
      ),
    );

    //body
    var data = {
      "customerID": LocalStorage.readJson(key: LocalStorageKeys.customerID),
      // "verifyCode": verifyCode
    };
    var response = await http.post(Uri.parse(url),
        body: jsonEncode(data), headers: header);
    if (kDebugMode) {
      print("Called API: $url");
      print("Status Code: ${response.statusCode}");
      print("Sent Body: ${data.toString()}");
      print("Response Body: ${response.body}");
      print("HEADERS: $header");
    }
    return GetDriverByIdModel.fromJson(ApiHelper.returnResponse(response));
  }

   getNotifications(// String customerID,
      // String verifyCode,
      ) async {
    // url
    String url = AppUrls.getNotifications;

    //header
    var header = AppHeaders.contentTypeWIthApplicationJsonAndAccessToken(
      LocalStorage.readJson(
        key: LocalStorageKeys.accessToken,
      ),
    );

    //body
    var data = {
      "customerID": LocalStorage.readJson(key: LocalStorageKeys.customerID),
      // "verifyCode": verifyCode
    };
    var response = await http.post(Uri.parse(url),
        body: jsonEncode(data), headers: header);
    if (kDebugMode) {
      print("Called API: $url");
      print("Status Code: ${response.statusCode}");
      print("Sent Body: ${data.toString()}");
      print("Response Body: ${response.body}");
      print("HEADERS: $header");
    }
    return ApiHelper.returnResponse(response);
  }

  updateDriver(
      String firstName,
      String lastName,
      String email,
      ) async {
    // url
    String url = AppUrls.updateDriver;

    //header
    var header = AppHeaders.contentTypeWIthApplicationJsonAndAccessToken(
      LocalStorage.readJson(
        key: LocalStorageKeys.accessToken,
      ),
    );

    //body
    var data = {
      "id": LocalStorage.readJson(key: LocalStorageKeys.customerID),
      "firstName": firstName,
      "lastName": lastName,
      "email": email
    };
    var response = await http.post(Uri.parse(url),
        body: jsonEncode(data), headers: header);
    if (kDebugMode) {
      print("Called API: $url");
      print("Status Code: ${response.statusCode}");
      print("Sent Body: ${data.toString()}");
      print("Response Body: ${response.body}");
      print("HEADERS: $header");
    }
    return ApiHelper.returnResponse(response);
  }

  Future<GetDriverNewOrders> getDriverNewOrders(// String customerID,
      // String verifyCode,
      ) async {
    // url
    String url = AppUrls.getDriverNewOrders;

    //header
    var header = AppHeaders.contentTypeWIthApplicationJsonAndAccessToken(
      LocalStorage.readJson(
        key: LocalStorageKeys.accessToken,
      ),
    );

    //body
    var data = {
      "customerID": LocalStorage.readJson(key: LocalStorageKeys.customerID),
      // "verifyCode": verifyCode
    };
    var response = await http.post(Uri.parse(url),
        body: jsonEncode(data), headers: header);
    if (kDebugMode) {
      print("Called API: $url");
      print("Status Code: ${response.statusCode}");
      print("Sent Body: ${data.toString()}");
      print("Response Body: ${response.body}");
      print("HEADERS: $header");
    }
    return GetDriverNewOrders.fromJson(ApiHelper.returnResponse(response));
  }

  getDriverInProgressOrders(// String customerID,
      // String verifyCode,
      ) async {
    // url
    String url = AppUrls.getDriverCurrentOrders;

    //header
    var header = AppHeaders.contentTypeWIthApplicationJsonAndAccessToken(
      LocalStorage.readJson(
        key: LocalStorageKeys.accessToken,
      ),
    );

    //body
    var data = {
      "customerID": LocalStorage.readJson(key: LocalStorageKeys.customerID),
      // "verifyCode": verifyCode
    };
    var response = await http.post(Uri.parse(url),
        body: jsonEncode(data), headers: header);
    if (kDebugMode) {
      print("Called API: $url");
      print("Status Code: ${response.statusCode}");
      print("Sent Body: ${data.toString()}");
      print("Response Body: ${response.body}");
      print("HEADERS: $header");
    }
    return (ApiHelper.returnResponse(response));
  }

  Future<GetDriverAllOrders>getDriverAllOrders(// String customerID,
      // String verifyCode,
      ) async {
    // url
    String url = AppUrls.getDriverAllOrders;

    //header
    var header = AppHeaders.contentTypeWIthApplicationJsonAndAccessToken(
      LocalStorage.readJson(
        key: LocalStorageKeys.accessToken,
      ),
    );

    //body
    var data = {
      "customerID": LocalStorage.readJson(key: LocalStorageKeys.customerID),
      // "verifyCode": verifyCode
    };
    var response = await http.post(Uri.parse(url),
        body: jsonEncode(data), headers: header);
    if (kDebugMode) {
      print("Called API: $url");
      print("Status Code: ${response.statusCode}");
      print("Sent Body: ${data.toString()}");
      print("Response Body: ${response.body}");
      print("HEADERS: $header");
    }
    return GetDriverAllOrders.fromJson(ApiHelper.returnResponse(response));
  }


  changeOrderStatus(String orderID, int orderStatus
      ) async {
    // url
    String url = AppUrls.changeOrderStatus;

    //header
    var header = AppHeaders.contentTypeWIthApplicationJsonAndAccessToken(
      LocalStorage.readJson(
        key: LocalStorageKeys.accessToken,
      ),
    );

    //body
    var data = {
      "driverID": LocalStorage.readJson(key: LocalStorageKeys.customerID),
      "orderID": orderID,
      "status": orderStatus
      // "verifyCode": verifyCode
    };
    var response = await http.post(Uri.parse(url),
        body: jsonEncode(data), headers: header);
    if (kDebugMode) {
      print("Called API: $url");
      print("Status Code: ${response.statusCode}");
      print("Sent Body: ${data.toString()}");
      print("Response Body: ${response.body}");
      print("HEADERS: $header");
    }
    return (ApiHelper.returnResponse(response));
  }

  Future<GetOrderById>driverGetByOrderID(String orderID
      ) async {
    // url
    String url = AppUrls.driverGetOrderByID;

    //header
    var header = AppHeaders.contentTypeWIthApplicationJsonAndAccessToken(
      LocalStorage.readJson(
        key: LocalStorageKeys.accessToken,
      ),
    );

    //body
    var data = {
      "customerID": LocalStorage.readJson(key: LocalStorageKeys.customerID),
      "orderID": orderID
      // "verifyCode": verifyCode
    };
    var response = await http.post(Uri.parse(url),
        body: jsonEncode(data), headers: header);
    if (kDebugMode) {
      print("Called API: $url");
      print("Status Code: ${response.statusCode}");
      print("Sent Body: ${data.toString()}");
      print("Response Body: ${response.body}");
      print("HEADERS: $header");
    }
    return GetOrderById.fromJson(ApiHelper.returnResponse(response));
  }

   acceptDriverOrder(String orderID,
      ) async {
    // url
    String url = AppUrls.acceptOrder;

    //header
    var header = AppHeaders.contentTypeWIthApplicationJsonAndAccessToken(
      LocalStorage.readJson(
        key: LocalStorageKeys.accessToken,
      ),
    );

    //body
    var data = {
      "driverID":  LocalStorage.readJson(key: LocalStorageKeys.customerID),
      "orderID": orderID,
      "accept": true
    };
    var response = await http.post(Uri.parse(url),
        body: jsonEncode(data), headers: header);
    if (kDebugMode) {
      print("Called API: $url");
      print("Status Code: ${response.statusCode}");
      print("Sent Body: ${data.toString()}");
      print("Response Body: ${response.body}");
      print("HEADERS: $header");
    }
    return (ApiHelper.returnResponse(response));
  }
}
