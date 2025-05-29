import 'package:flutter/material.dart';

import 'app_colors.dart';


class AppTextStyles {

  static TextStyle w100Style(double fontSize, {Color? fontColor}) {
    return TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w100,
        color: fontColor ?? AppColors.pureBlack);
  }

  static TextStyle w200Style(double fontSize, {Color? fontColor}) {
    return TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w200,
        color: fontColor ?? AppColors.pureBlack);
  }

  static TextStyle w300Style(double fontSize, {Color? fontColor}) {
    return TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w300,
        color: fontColor ?? AppColors.pureBlack,
        // fontFamily: "Inter"

    );
  }

  static TextStyle w400Style(double fontSize,
      {Color? fontColor, FontStyle? fontStyle}) {
    return TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        color: fontColor ?? AppColors.pureBlack,
        fontStyle: fontStyle ?? FontStyle.normal,
        // fontFamily: "Inter"
    );
  }

  static TextStyle w500Style(double fontSize, {Color? fontColor}) {
    return TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: fontColor ?? AppColors.pureBlack,
        // fontFamily: "Inter"

    );
  }

  static TextStyle w600Style(double fontSize, {Color? fontColor}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: fontColor ?? AppColors.pureBlack,
      // fontFamily: "Inter",
    );
  }

  static TextStyle w700Style(double fontSize, {Color? fontColor}) {
    return TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: fontColor ?? AppColors.pureBlack,
        // fontFamily: "Inter"

    );
  }

  static TextStyle w800Style(double fontSize, {Color? fontColor}) {
    return TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
        color: fontColor ?? AppColors.pureBlack,
        // fontFamily: "Inter"

    );
  }

  static TextStyle w900Style(double fontSize, {Color? fontColor}) {
    return TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
        color: fontColor ?? AppColors.pureBlack,
        // fontFamily: "Inter"

    );
  }
}