import 'package:get/get.dart';

import '../services/api_services/app_services.dart';

class OtpVerificationController extends GetxController{

  // for handling the loading state in the screen
  RxBool isLoading = false.obs;

  // verifyDriverOtp() async {
  //   try {
  //     isLoading.value = true;
  //     var result = await AppServices().driverLogin(
  //       phoneNumberController.value.text,
  //       "123456",
  //     );
  //     Prompts.successSnackBar("User Logged in Successfully!");
  //     Get.to(()=> OtpVerificationScreen());
  //
  //     isLoading.value = false;
  //     return true;
  //   } on SocketException {
  //     isLoading.value = false;
  //     Prompts.errorSnackBar("Internet Connection Not Available!");
  //   } catch (e) {
  //     Prompts.errorSnackBar(e.toString());
  //
  //     isLoading.value = false;
  //   }
  // }



}