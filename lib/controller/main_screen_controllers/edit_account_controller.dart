import 'dart:io';

import 'package:get/get.dart';

import '../../core/utils/prompts.dart';
import '../../services/api_services/app_services.dart';
import '../../user.dart';
import 'front_page_controller.dart';

class EditAccountController extends GetxController {
  // made for the loading state
  RxBool isLoading = false.obs;

  getDriverByID() async {
    try {
      isLoading.value = true;
      var result = await AppServices().getDriverByID(
          // phoneNumberController.value.text,
          // otpCode.value,
          );
      // Prompts.successSnackBar("User Verified Successfully!");
      final User userModel = User(
        id: result.value?.data?.id.toString(),
        firstName: result.value?.data?.firstName.toString(),
        lastName: result.value?.data?.lastName.toString(),
        email: result.value?.data?.email.toString(),
        number: result.value?.data?.phone.toString(),
        photo: result.value?.data?.photo.toString(),
      );
      // Get.to(() => FrontPage(
      //   user: userModel,
      //   tab: 0,
      // ));
      final frontPageController = Get.put(FrontPageController());
      frontPageController.userModel.value = userModel;
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

  updateDriver(
    String firstName,
    String lastName,
    String email,
  ) async {
    try {
      isLoading.value = true;
      var result = await AppServices().updateDriver(firstName, lastName, email);
      await getDriverByID();

      Get.back();
      Prompts.successSnackBar("Profile Updated Successfully!");
      // final User userModel = User(
      //   id: result.value?.data?.id.toString(),
      //   firstName: result.value?.data?.firstName.toString(),
      //   lastName: result.value?.data?.lastName.toString(),
      //   email: result.value?.data?.email.toString(),
      //   number: result.value?.data?.phone.toString(),
      //   photo: result.value?.data?.photo.toString(),
      // );
      // Get.to(() => FrontPage(
      //   user: userModel,
      //   tab: 0,
      // ));
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
