import 'dart:convert';

import 'package:pure_o_fresh_rider_app/commons/LangaugesData.dart';

mixin ConvertText {
  static String getTitle(String Text) {
    if (LangaugesData.titles.containsKey(Text)) {
      return LangaugesData.titles[Text];
    }
    return Text;
  }
}
