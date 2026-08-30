import 'dart:ui';
import 'package:flutter/material.dart';

mixin TrimmitThemeData {
  static const String manropeFontFamily = 'Manrope';
  static const String poppinsFontFamily = 'Poppins';
  static const Color mainColor = Color(0xff169948);
  static const Color backgroundColor = Color(0xffffffff);
  static const Color darkColor = Color(0xff000000);
  static const Color liteColor = Color(0xffffffff);
  static const Color forgotPasswordScreenBg = Color(0xffecf6be);
  static const Color whiteColor = Color(0xffffffff);
  static const Color blackColor = Color(0xffffffff);
}

extension padding on num {
  SizedBox get ph => SizedBox(
        height: toDouble(),
      );
  SizedBox get pw => SizedBox(
        width: toDouble(),
      );
}
