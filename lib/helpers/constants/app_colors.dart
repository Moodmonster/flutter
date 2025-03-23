import 'package:flutter/material.dart';

@immutable
class AppColors {
  const AppColors._();

  /// Main Black 333333
  static const Color black = Color(0xFF333333);

  /// Light Black 555555
  static const Color lightBlack = Color(0xFF555555);

  /// custom white
  static const Color white = Color(0xFFFDFDFD);

  /// light Grey
  static const Color lightGrey = Color(0xFFF3F3F3);

  /// Dark Grey
  static const Color darkGrey = Color(0xFF777777);

  /// deactive color
  static const Color deactive = Color(0xFFC5C5BF);

  /// deactive Gray color
  static const Color deActiveGray = Color(0xFFC2C2C2);

  //static const Color background = Color.fromARGB(255, 31, 31, 31);
  static const Color background = Color.fromARGB(255, 250, 250, 250);

  //static const Color mainTextColor = Color.fromARGB(255, 255, 255, 255);
  static const Color mainTextColor = Color.fromARGB(255, 31, 31, 31);

  static const Color descTextColor = Color.fromARGB(255, 78, 78, 78);

  static const Color dialogBackground = Color.fromARGB(255, 241, 241, 241);
  static const Color dialogTextField = Color.fromARGB(255, 255, 255, 255);

  /// primary
  //static const Color primary = Color(0xFFF7E172);
  static const Color primary = Color.fromARGB(255, 48, 61, 130);
  static const Color lightPrimary = Color.fromARGB(255, 208, 216, 246);

  /// light primary
  //static const Color lightPrimary = Color(0xFFFCF4CE);

  /// secondary
  static const Color secondary = Color(0xFFCAE734);
}
