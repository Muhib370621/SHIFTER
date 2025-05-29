import 'dart:io';

import 'package:get/get.dart';

import '../../core/utils/prompts.dart';
import '../../services/api_services/app_services.dart';

class NotificationController extends GetxController{

  // for handling loading state in the application
  RxBool isLoading = false.obs;

  getNotifications() async {
    try {
      isLoading.value = true;
      var result = await AppServices().getNotifications(
        // phoneNumberController.value.text,
        // otpCode.value,
      );
      // Prompts.successSnackBar("User Verified Successfully!");
      // final User userModel = User(
      //   id: result.value?.data?.id.toString(),
      //   firstName: result.value?.data?.firstName.toString(),
      //   lastName: result.value?.data?.lastName.toString(),
      //   email: result.value?.data?.email.toString(),
      //   number: result.value?.data?.phone.toString(),
      //   photo: result.value?.data?.photo.toString(),
      // );
      // // Get.to(() => FrontPage(
      // //   user: userModel,
      // //   tab: 0,
      // // ));
      // final frontPageController = Get.put(FrontPageController());
      // frontPageController.userModel.value = userModel;
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