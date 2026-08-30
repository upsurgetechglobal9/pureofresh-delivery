import 'package:flutter/material.dart';

import '../../main.dart';

class NavigationController {
  static void navigateToPage(BuildContext context, Widget page) {
    MyApp.navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static void navigateBack(BuildContext context) {
    MyApp.navigatorKey.currentState!.pop();
  }
}
