import 'package:flutter/material.dart';

class MediaQ {
  static late double height;
  static late double width;

  static init(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
  }

  static double get getHeight => height;
  static double get getWidth => width;
}
