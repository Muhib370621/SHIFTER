import 'dart:io';

import 'package:get/get.dart';
import 'package:shifter/model/api_models/get_driver_all_orders.dart';
import 'package:shifter/model/api_models/get_driver_new_orders.dart';

import '../../core/utils/prompts.dart';
import '../../services/api_services/app_services.dart';

class OrderController extends GetxController {
  // for handling the loading state in the application
  RxBool isLoading = false.obs;

  RxList<NewOrderDataList> listOfNewOrders = <NewOrderDataList>[].obs;
  RxList<OrderAllDataList> listOfAllOrders = <OrderAllDataList>[].obs;

  getDriverNewOrders() async {
    try {
      isLoading.value = true;
      var result = await AppServices().getDriverNewOrders(
          // phoneNumberController.value.text,
          // otpCode.value,
          );
      listOfNewOrders.value = result.value?.data?.dataList ?? [];
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
  getDriverInProgressOrders() async {
    try {
      isLoading.value = true;
      var result = await AppServices().getDriverInProgressOrders(
          // phoneNumberController.value.text,
          // otpCode.value,
          );
      // listOfNewOrders.value = result.value?.data?.dataList ?? [];
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
  getDriverAllOrders() async {
    try {
      isLoading.value = true;
      var result = await AppServices().getDriverAllOrders(
          // phoneNumberController.value.text,
          // otpCode.value,
          );
      listOfAllOrders.value = result.value?.data?.dataList ?? [];
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

  acceptOrder(String orderID) async {
    try {
      isLoading.value = true;
      var result = await AppServices().acceptDriverOrder(
          // phoneNumberController.value.text,
          // otpCode.value,
          orderID);

      getDriverNewOrders();
      // listOfNewOrders.value = result.value?.data?.dataList??[];
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
