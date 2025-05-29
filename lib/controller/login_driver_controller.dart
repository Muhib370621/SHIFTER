import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shifter/home.dart';
import 'package:shifter/home_language.dart';
import 'package:shifter/services/api_services/app_services.dart';
import 'package:shifter/services/local_storage/local_storage.dart';
import 'package:shifter/services/local_storage/local_storage_keys.dart';
import 'package:shifter/view/auth/otp_verification_screen.dart';

import '../core/utils/prompts.dart';

class LoginDriverController extends GetxController {
  // for loading state
  RxBool isLoading = false.obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;

  // Rx<TextEditingController> tokenCodeController = TextEditingController().obs;

  login() async {
    try {
      isLoading.value = true;
      var result = await AppServices().driverLogin(
        phoneNumberController.value.text,
        "123456",
      );
      Prompts.successSnackBar("User Logged in Successfully!");
      Get.to(() => OtpVerificationScreen());
      LocalStorage.saveJson(
          key: LocalStorageKeys.customerID,
          value: result["value"]["data"]["id"].toString());

      isLoading.value = false;
      return true;
    } on SocketException {
      isLoading.value = false;
      Prompts.errorSnackBar("Internet Connection Not Available!");
    } catch (e) {
      Prompts.errorSnackBar(e.toString());

      isLoading.value = false;
    }
  }
}
