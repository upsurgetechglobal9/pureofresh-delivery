import 'package:flutter/material.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/new_order/screens/near_to_pickup_location_screen.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/new_order/screens/new_order_screen.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/splash_screen.dart';

import '../internet_handler/screen/no_internet_screen.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    //Home route
    case SplashScreen.routeName:
      return MaterialPageRoute(builder: (_) => const SplashScreen());

    case NearToPickUp.routeName:
      final Map<String, dynamic>? args =
          settings.arguments as Map<String, dynamic>?;
      final String refId = args?['ref_id'] ?? '';
      final String apptype = args?['apptype'] ?? '';
      // final arguments = settings.arguments as Map<String, String>;
      return MaterialPageRoute(
        builder: (_) => NearToPickUp(
          refId: refId,
          apptype: apptype,
          // type: '',
        ),
      );

    case NewOrderScreen.routeName:
      final Map<String, dynamic>? args =
          settings.arguments as Map<String, dynamic>?;
      final String orderId = args?['orderId'] ?? '';
      final String apptype = args?['apptype'] ?? '';
      // final orderId = settings.arguments as String;
      // final apptype = settings.arguments as String;
      return MaterialPageRoute(
        builder: (_) => NewOrderScreen(orderId: orderId, apptype: apptype),
      );

    case NoInternetScreen.routeName:
      return MaterialPageRoute(builder: (_) => const NoInternetScreen());
  }
  return null;
}
