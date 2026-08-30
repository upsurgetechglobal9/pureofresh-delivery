import 'package:flutter/material.dart';

import '../delivery_boy_screens/new_order/screens/new_order_screen.dart';
import 'dart:async';
import '../main.dart';

mixin NavigateScreen {
  static Future<void> newOrderScreen({Map<String, String?>? data}) async {
    // BuildContext? context = navigatorKey?.currentContext;
    // debugPrint('Puneet Super ⭐ $context');
    // if (context != null) {
    //   navigatorKey?.currentState?.pushNamedAndRemoveUntil(NewOrderScreen.routeName,
    //       (route) => (route.settings.name != NewOrderScreen.routeName) || route.isFirst,
    //       arguments: {
    //         'orderId': data?['operation_id'] ?? '',
    //         'apptype': data?['apptype'] ?? '',
    //       });
    // }
  }
}
