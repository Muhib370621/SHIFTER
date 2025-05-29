import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import '../../core/utils/app_colors.dart';
import '../../core/utils/app_text_styles.dart';
import '../components/custom_button.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // backgroundColor: AppColors.purpleGradient,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(
              top: MediaQuery
                  .of(context)
                  .padding
                  .top, bottom: 20),
          child:
             SingleChildScrollView(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: <Widget>[
                   Image.asset(
                     'assets/mobilescreen.png',
                     fit: BoxFit.fill,
                     width: MediaQuery
                         .of(context)
                         .size
                         .width,
                   ),
                   SizedBox(height: 30,),
                   Column(
                     children: [
                       13.h.verticalSpace,
                       Text(
                         "Otp Verification",
                         style: AppTextStyles.w600Style(
                           20.sp,
                         ),
                       ),
                       20.h.verticalSpace,
                       OTPTextField(
                         // controller: forgotPasswordController.otpTextFieldController.value,
                         fieldStyle: FieldStyle.box,
                         otpFieldStyle: OtpFieldStyle(
                           disabledBorderColor: AppColors.kLightBlackBorder,
                           enabledBorderColor: AppColors.kLightBlackBorder,
                           errorBorderColor: AppColors.kLightBlackBorder,
                           focusBorderColor: AppColors.kLightBlackBorder,
                           backgroundColor: AppColors.pureWhite,
                           borderColor: AppColors.kLightBlackBorder,
                         ),
                         length: 6,
                         keyboardType: TextInputType.number,
                         width: MediaQuery
                             .of(context)
                             .size
                             .width,
                         margin: EdgeInsets.symmetric(horizontal: 0.0113.sw),
                         // contentPadding: Ed,
                         // spaceBetween: 0.01.sw,
                         fieldWidth: 0.13.sw,
                         style: TextStyle(
                             fontSize: 22.sp, color: AppColors.purpleGradient, fontWeight: FontWeight.w600),
                         textFieldAlignment: MainAxisAlignment.spaceBetween,
                         onCompleted: (pin) {
                           // G.debubLog(pin);
                           if (pin.length == 6) {
                             // forgotPasswordController.otpText.value = pin;
                             //   if (widget.otpFor == "forSignUp") {
                             //     authController.verifySignUpOtp(
                             //       pin.trim(),
                             //       G.deviceToken,
                             //       G.deviceType(),
                             //       widget.data["email"],
                             //     );
                             //   } else {
                             //     authController.verifyforgetPassOtp(
                             //       pin.trim(),
                             //     );
                             //   }
                             // } else {
                             //   Utils.snackBar(context: context, message: AppString.invalidOTP);
                           }
                         },
                         onChanged: (value) {
                           // G.debubLog('Countdown Started');
                         },
                       ).paddingSymmetric(
                         horizontal: 10.w,
                       ),
                       0.03.sh.verticalSpace,
                       // CircularPercentIndicator(
                       //   radius: 50.r,
                       //   animation: true,
                       //   animationDuration: 60000,
                       //   lineWidth: 0.02.sw,
                       //   percent: 1,
                       //   center: Text(
                       //     seconds.toString(),
                       //     style: AppTextStyles.w800Style(
                       //       15.sp,
                       //     ),
                       //   ),
                       //   circularStrokeCap: CircularStrokeCap.round,
                       //   backgroundColor: AppColors.purpleGradient.withOpacity(0.2),
                       //   progressColor: AppColors.purpleGradient,
                       //   // onPercentValue: (value) {
                       //   //   if (value == 1) {
                       //   //     Get.to(() => PaywallScreen());
                       //   //   }
                       //   // },
                       // ),
                       // 0.03.sh.verticalSpace,
                       //
                       // // 60.h.verticalSpace,
                       // Obx(() {
                       //   return CustomButton(
                       //     // isLoading: forgotPasswordController.isLoading.value,
                       //     onTap: () {
                       //       // forgotPasswordController.verifyOtp();
                       //       // Get.to(()=> OnboardingScreen());
                       //     },
                       //     buttonText: "Submit",
                       //   );
                       // }),
                     ],
                   )


                   // Container(
                   //   padding: EdgeInsets.symmetric(horizontal: 20),
                   //   child: Row(
                   //     children: <Widget>[
                   //       Expanded(
                   //         child: TextFormField(
                   //           controller: loginController.phoneNumberController.value,
                   //
                   //           keyboardType: TextInputType.emailAddress,
                   //           validator: (val) {
                   //             if (val!.length == 0 && !forgetValidation)
                   //               return loc == 'en' ? 'Required' : 'مطلوب';
                   //             else
                   //               return null;
                   //           },
                   //           onChanged: (val) {
                   //             setState(() {
                   //               password = val;
                   //             });
                   //           },
                   //           obscureText: obscure,
                   //           decoration: InputDecoration(
                   //               suffixIcon: GestureDetector(
                   //                   onTap: () {
                   //                     setState(() {
                   //                       obscure = !obscure;
                   //                     });
                   //                   },
                   //                   child: Icon(obscure
                   //                       ? Icons.visibility_off
                   //                       : Icons.visibility)),
                   //               contentPadding: EdgeInsets.symmetric(
                   //                   horizontal: 10, vertical: 10),
                   //               hintText:
                   //                   loc == 'en' ? 'Password' : 'كلمة المرور'),
                   //         ),
                   //       )
                   //     ],
                   //   ),
                   // ),
                   // SizedBox(
                   //   height: 10,
                   // ),

                 ],
               ),
             )
         ,
        ),
      ),
    );
  }
}
