import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  static const routeName = "/no_internet";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            //      Icon(
            //   Icons.wifi_off_outlined,
            //   color: Colors.red,
            //   size: 100,
            // )
            Lottie.asset(
          'assets/images/nointernet1.json',
        ),
        //     Text(
        //   "No Internet",
        //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        // ),
      ),
    );
  }
}
