import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../commons/ConvertText.dart';
import '../../../login/screens/welcome_screen.dart';
import '../../../navigation_bar/navigationbar_screen.dart';

class RegistrationSuccessScreen extends StatefulWidget {
  const RegistrationSuccessScreen({super.key});

  @override
  State<RegistrationSuccessScreen> createState() =>
      _RegistrationSuccessScreenState();
}

class _RegistrationSuccessScreenState extends State<RegistrationSuccessScreen> {
  DateTime? currentBackPressTime;

  Future<bool> onWillPop() {
    print("object");
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;

      Fluttertoast.showToast(msg: 'Tap back again to leave');

      return Future.value(false);
    }
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()));

    // Navigator.pop(context, true);
    // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomSheet: Container(
            color: Colors.white,
            child: Image.asset(
              'assets/images/sucesslotti.png',
              height: 200,
              width: double.infinity,
              fit: BoxFit.fill,
            )),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/sucess.png',
                height: 100,
                width: 100,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                ConvertText.getTitle("Your Registration has been"),
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(ConvertText.getTitle("Completed "),
                      style: GoogleFonts.manrope(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      )),
                  Text(ConvertText.getTitle("Successfully!"),
                      style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF000000))),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: .0, horizontal: 30),
                child: Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              ConvertText.getTitle(
                                  "Team Pure O Fresh will Approach"),
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                              )),
                          Text(ConvertText.getTitle(" Once verification"),
                              style: GoogleFonts.manrope(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Text(ConvertText.getTitle(" is done..."),
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                          )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF000000),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const BottomsNaviScreen(index: 0)),
                          (route) => false);
                    },
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 12),
                        child: Text(
                          ConvertText.getTitle("Open DashBoard"),
                          style: GoogleFonts.manrope(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
