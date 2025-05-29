import 'package:flutter/material.dart';

class WeeklySeries {
  final String day;
  final double earning; // Change this to double to match chart data requirements
  final Color barColor;

  WeeklySeries({
    required this.barColor,
    required this.day,
    required this.earning,
  });
}
