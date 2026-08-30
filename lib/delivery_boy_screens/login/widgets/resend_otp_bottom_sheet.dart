import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../commons/shared_prefs.dart';
import '../../../commons/show_chuk_notification.dart';
import '../../../commons/url_links.dart';
import '../../../utility/colors_data.dart';
import '../../navigation_bar/navigationbar_screen.dart';

class OtpBottomSheet extends StatefulWidget {
  final String number;
  const OtpBottomSheet({super.key, required this.number});

  @override
  _OtpBottomSheetState createState() => _OtpBottomSheetState();
}

class _OtpBottomSheetState extends State<OtpBottomSheet> {
  final verifyKey = GlobalKey<FormState>();
  final loginKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  StreamController<ErrorAnimationType>? errorController;
  int _remainingSeconds = 60;
  late Timer _timer;
  String seconds = "60";
  String currentText = "";
  bool hasError = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Start the countdown timer when the bottom sheet is created
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          if (mounted) {
            setState(() {
              if (_remainingSeconds < 10) {
                seconds = '0$_remainingSeconds';
              } else {
                seconds = _remainingSeconds.toString();
              }
            });
          }
        } else {
          // Timer has reached 0, you can perform actions like
          // re-sending OTP or closing the bottom sheet.
          _timer.cancel(); // Stop the timer
        }
      });
    });
  }

  doVerify() async {
    final FormState? form = verifyKey.currentState;
    if (form!.validate()) {
      final formData = FormData.fromMap({
        'mobile': widget.number,
        'otp': pincodeController.text,
      });
      final dio = Dio();
      addChuck(dio);
      final response = await dio.post(
          UrlLinksData.serverUrl + UrlLinksData.verifyOtpUrl,
          data: formData);
      if (response.data['err_code'] == 'valid') {
        final pendingData = FormData.fromMap({
          'access_token': response.data['user_details']['access_token'],
        });
        final responseforPending = await dio.post(
            UrlLinksData.serverUrl + UrlLinksData.pendingDetailsUrl,
            data: pendingData);
        if (responseforPending.data['data']['verification_status'] == false) {
          Constants.prefs!.setString(
              "token", response.data['user_details']['access_token']);
          if (mounted) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const BottomsNaviScreen(index: 0)),
                (route) => false);
          }
        } else {
           // ignore: use_build_context_synchronously
           Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const BottomsNaviScreen(index: 0)),
              (route) => false);
          // Constants.prefs!.setString(
          //     "token", response.data['user_details']['access_token']);
          // final dailyCheck = FormData.fromMap({
          //   'access_token': response.data['user_details']['access_token'],
          // });
          // final responseforDailyCheck = await dio.post(
          //     UrlLinksData.serverUrl + UrlLinksData.dailyCheckInUrl,
          //     data: dailyCheck);
          // if (mounted) {
          //   if (responseforDailyCheck.data['checkin_status'] == false) {
          //     Navigator.pop(context);
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => CheckInCheckOutScreen(
          //             type: 'Check In ',
          //           ),
          //         ));
          //   } else {
          //     Navigator.pushAndRemoveUntil(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => const BottomsNaviScreen(index: 0)),
          //         (route) => false);
          //   }
          // }
        }
        // Constants.prefs!
        //     .setString("token", response.data['user_details']['access_token']);
        // Navigator.pop(context);
        // final pendingData = FormData.fromMap({
        //   'access_token': response.data['user_details']['access_token'],
        // });
        // final responseforPending = await dio.post(
        //     UrlLinksData.serverUrl + UrlLinksData.pendingDetailsUrl,
        //     data: pendingData);
        // if (responseforPending.data['data']['vehicle_details'] == false) {
        //   Constants.prefs!.setString(
        //       "token", response.data['user_details']['access_token']);
        //   Fluttertoast.showToast(msg: "Please Complete the Registration Flow");
        //   Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => SelectVehicleScreen(),
        //       ));
        // } else if (responseforPending.data['data']['location_details'] ==
        //     false) {
        //   Constants.prefs!.setString(
        //       "token", response.data['user_details']['access_token']);
        //   Fluttertoast.showToast(msg: "Please Complete the Registration Flow");
        //   Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => SelectCityScreen(),
        //       ));
        // } else if (responseforPending.data['data']['verification_details'] ==
        //     false) {
        //   Constants.prefs!.setString(
        //       "token", response.data['user_details']['access_token']);
        //   Fluttertoast.showToast(msg: "Please Complete the Registration Flow");
        //   Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => DocumentVerificationScreen(),
        //       ));
        // } else if (responseforPending.data['data']['verification_status'] ==
        //     false) {
        //   Navigator.pop(context);

        //   Fluttertoast.showToast(
        //       msg:
        //           "Your Account is under proccesing Please wait for appproval");
        // } else {
        //   Constants.prefs!.setString(
        //       "token", response.data['user_details']['access_token']);
        //   final pendingData = FormData.fromMap({
        //     'access_token': response.data['user_details']['access_token'],
        //   });
        //   final responseforDailyCheck = await dio.post(
        //       UrlLinksData.serverUrl + UrlLinksData.dailyCheckInUrl,
        //       data: pendingData);
        //   if (responseforDailyCheck.data['checkin_status'] == false) {

        //     Navigator.pushReplacement(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => CheckInCheckOutScreen(
        //             type: 'Check In ',
        //           ),
        //         ));
        //   } else {
        //     Navigator.pushAndRemoveUntil(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => const BottomsNaviScreen(index: 0)),
        //         (route) => false);
        //   }
        //   // Navigator.pushAndRemoveUntil(
        //   //     context,
        //   //     MaterialPageRoute(
        //   //         builder: (context) => const BottomsNaviScreen(index: 0)),
        //   //     (route) => false);
        // }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("data")));
        Fluttertoast.showToast(
            msg: "${response.data['message']}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color.fromARGB(255, 166, 9, 43),
            textColor: const Color.fromARGB(255, 255, 255, 255),
            fontSize: 16.0);
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("data")));
    }
  }

  reSendOtp() async {
    // setState(() {
    //   isLoading = true;
    // });
    final formData = FormData.fromMap({
      'mobile': widget.number,
    });
    final dio = Dio();
    addChuck(dio);
    final response = await dio.post(
        UrlLinksData.serverUrl + UrlLinksData.resendOtpUrl,
        data: formData);
    if (response.data['err_code'] == 'valid') {
      Fluttertoast.showToast(msg: "OTP sent successfully");
      // setState(() {
      //   isLoading = false;
      // });
      // startTimer();
      // Constants.prefs!
      //     .setString("token", response.data['data']['access_token']);
      // verifyOTPbottm(context);
      // showOtpBottomSheet(context, numberController.text.toString());
    } else if (response.data['err_code'] == 'invalid') {
      // setState(() {
      //   isLoading = false;
      // });
      Fluttertoast.showToast(msg: response.data['message']);
      // } else {
      //   setState(() {
      //     isLoading = false;
      //   });
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedPadding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              duration: const Duration(milliseconds: 150),
              child: Container(
                // constraints: BoxConstraints(maxHeight: 900, minHeight: 350),
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Enter Your OTP",
                          style: GoogleFonts.manrope(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "An 4 digits code has been send to",
                          style: GoogleFonts.manrope(),
                        ),
                        Text(widget.number.toString()),
                        Form(
                          key: verifyKey,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 30),
                              child: PinCodeTextField(
                                autoDisposeControllers: false,
                                appContext: context,
                                pastedTextStyle: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                                length: 4,
                                // obscureText: true,
                                // obscuringCharacter: '*',
                                // obscuringWidget: const FlutterLogo(
                                //   size: 24,
                                // ),
                                blinkWhenObscuring: true,
                                animationType: AnimationType.fade,
                                // validator: (v) {
                                //   if (v!.length <= 3) {
                                //     return "Please enter valid OTP";
                                //   } else {
                                //     return null;
                                //   }
                                // },
                                pinTheme: PinTheme(
                                  borderWidth: 1,
                                  selectedFillColor: Colors.black12,
                                  inactiveFillColor: Colors.grey[100],
                                  activeFillColor: Colors.white,
                                  activeColor: Colors.grey[400],
                                  inactiveColor: Colors.grey[300],
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(5),
                                  fieldHeight: 50,
                                  fieldWidth: 45,
                                ),
                                cursorColor: Colors.black,
                                animationDuration:
                                    const Duration(milliseconds: 300),
                                enableActiveFill: true,
                                errorAnimationController: errorController,
                                controller: pincodeController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],

                                onCompleted: (v) {
                                  debugPrint("Completed $v");
                                },
                                // onTap: () {
                                //   print("Pressed");
                                // },
                                onChanged: (value) {
                                  if(mounted){
                                    setState(() {
                                      currentText = value;
                                    });
                                  }
                                },
                                beforeTextPaste: (text) {
                                  debugPrint("Allowing to paste $text");
                                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                  return true;
                                },
                              )),
                        ),
                        hasError
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                child: Text(
                                  "*Please fill up all the cells properly",
                                  style: GoogleFonts.poppins(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              )
                            : const SizedBox.shrink(),
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 12.0, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ("00:$seconds" == '00:00')
                                  ? TextButton(
                                      style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(0)),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        showOtpBottomSheet(
                                            context, widget.number);
                                        reSendOtp();
                                        // sendingcode(); //api calling function BHAI
                                        // snackBar("OTP Resend successfully");
                                        // setState(() {
                                        //   Timer? _timer;

                                        //   int _start = 30;
                                        //   String seconds = '30';

                                        //   startTimer();
                                        //   // print("object.......$Ip");
                                        //   const oneSec = Duration(seconds: 1);
                                        //   _timer = Timer.periodic(
                                        //     oneSec,
                                        //     (Timer timer) {
                                        //       if (_start == 0) {
                                        //         setState(() {
                                        //           timer.cancel();
                                        //         });
                                        //       } else {
                                        //         setState(() {
                                        //           _start--;
                                        //           if (_start < 10) {
                                        //             seconds = '0$_start';
                                        //           } else {
                                        //             seconds = _start.toString();
                                        //           }
                                        //         });
                                        //       }
                                        //     },
                                        //   );
                                        // });
                                      },
                                      child: Text(
                                        'Resend OTP',
                                        style: GoogleFonts.poppins(
                                          color: ColorsData.themeColor,
                                          fontSize: 16,
                                        ),
                                      ))
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Resend code in ",
                                          style: GoogleFonts.poppins(
                                              // fontFamily: MFONT,
                                              color: Colors.black,
                                              // fontWeight: FontWeight.w600,
                                              fontSize: 12),
                                        ),
                                        Text("00:$seconds",
                                            style: GoogleFonts.poppins(
                                                color: ColorsData.themeColor,
                                                fontWeight: FontWeight.w500)),
                                      ],
                                    ),

                              // const Text("Resend OTP"),
                              // TextButton(
                              //   onPressed: () => snackBar("OTP resend!!"),
                              //   child: Text(
                              //     "0:59 sec",
                              //     style: TextStyle(
                              //         color: ColorsData.aBtntGreen,
                              //         fontWeight: FontWeight.bold,
                              //         fontSize: 16),
                              //   ),
                              // )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                            height: 45,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7ec245),
                              ),
                              onPressed: () {
                                doVerify();
                                // formKey.currentState!.validate();
                                // // conditions for validating
                                // if (currentText.length != 4) {
                                //   errorController!.add(ErrorAnimationType
                                //       .shake); // Triggering error shake animation
                                //   setState(() => hasError = true);
                                // } else {
                                //   setState(
                                //     () {
                                //       hasError = false;
                                //       // snackBar("OTP Verified!!");
                                //     },
                                //   );
                                // }
                                // Navigator.pushAndRemoveUntil(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             BottomsNaviScreen(index: 0)),
                                //     (route) => false);
                              },
                              child: Text(
                                "Verify",
                                style: GoogleFonts.manrope(
                                  letterSpacing: 0.8,
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Text(
            //   'Enter OTP',
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            // SizedBox(height: 16),
            // Text(
            //   '$seconds seconds remaining',
            //   style: TextStyle(fontSize: 16),
            // ),
            // ElevatedButton(
            //     onPressed: () {
            //       Navigator.pop(context);
            //       showOtpBottomSheet(context);
            //     },
            //     child: Text("data"))
            // Add your OTP input field here
            // Add a button to resend OTP if needed
          ],
        ),
      ),
    );
  }
}

// Function to show the bottom sheet
void showOtpBottomSheet(BuildContext context, String number) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
    ),
    builder: (context) {
      return OtpBottomSheet(
        number: number,
      );
    },
  );
}
