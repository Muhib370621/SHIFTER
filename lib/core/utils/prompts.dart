import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Prompts {
  static successSnackBar(String successMsg) {
    return Get.snackbar(
      duration: Duration(
        milliseconds: 1500,
      ),
      'Success',
      successMsg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.5),
      colorText: Colors.black,
    );
  }

  static errorSnackBar(String errorMsg) {
    return Get.snackbar(
      duration: Duration(
        milliseconds: 1500,
      ),
      'Error',
      errorMsg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.5),
      colorText: Colors.black,
    );
  }
}
