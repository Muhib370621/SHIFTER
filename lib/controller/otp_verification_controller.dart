import 'dart:io';

import 'package:get/get.dart';
import 'package:shifter/controller/main_screen_controllers/front_page_controller.dart';
import 'package:shifter/front_page.dart';
import 'package:shifter/services/local_storage/local_storage.dart';
import 'package:shifter/services/local_storage/local_storage_keys.dart';
import 'package:shifter/user.dart';

import '../core/utils/prompts.dart';
import '../services/api_services/app_services.dart';

class OtpVerificationController extends GetxController {
  // for handling the loading state in the screen
  RxBool isLoading = false.obs;

  RxString otpCode = "".obs;

  verifyDriverOtp() async {
    try {
      isLoading.value = true;
      var result = await AppServices().verifyDriverOtp(
        // phoneNumberController.value.text,
        otpCode.value,
      );
      Prompts.successSnackBar("User Verified Successfully!");
      final User userModel = User(
        id: result["value"]["data"]["id"].toString(),
        firstName: result["value"]["data"]["firstName"].toString(),
        lastName: result["value"]["data"]["lastName"].toString(),
        email: result["value"]["data"]["email"].toString(),
        number: result["value"]["data"]["phone"].toString(),
        photo: result["value"]["data"]["photo"].toString(),
      );
      Get.to(() => FrontPage(
            user: userModel,
            tab: 0,
          ));
      final frontPageController = Get.put(FrontPageController());
      frontPageController.userModel.value = userModel;

      LocalStorage.saveJson(
          key: LocalStorageKeys.accessToken,
          value: result["value"]["data"]["access_token"].toString());
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
