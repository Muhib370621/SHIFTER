import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/app_colors.dart';
import '../../core/utils/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    required this.buttonText,
    this.isLoading,
    this.buttonColor,
    this.onTap,
  });

  final String buttonText;
  final bool? isLoading;
  void Function()? onTap;
  final Color? buttonColor;

  // final double width

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 45.h,
        width: 0.85.sw,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(
              100.r,
            ),
          ),
          color: buttonColor??AppColors.pureBlack
          // gradient: LinearGradient(
          //   colors: [
          //     AppColors.purpleGradient,
          //     AppColors.lightPurpleGradient,
          //   ],
          //   stops: [0.32, 1],
          //   begin: FractionalOffset.topCenter,
          //   end: FractionalOffset.bottomCenter,
          //   // tileMode: TileMode.repeated,
          // ),
        ),
        child: Center(
          child: isLoading ?? false
              ? CircularProgressIndicator()
              : Text(
            buttonText,
            style: AppTextStyles.w600Style(
              15.sp,
              fontColor: AppColors.pureWhite,
            ),
          ),
        ),
      ),
    );
  }
}
