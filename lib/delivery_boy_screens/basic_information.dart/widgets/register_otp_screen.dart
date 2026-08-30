import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../commons/ConvertText.dart';
import '../../../commons/show_chuk_notification.dart';
import '../../../commons/url_links.dart';
import '../../../utility/colors_data.dart';
import '../../navigation_bar/navigationbar_screen.dart';
import '../logic/bloc/basic_details_bloc.dart';

class RegisterOtpBottomSheet extends StatefulWidget {
  final String number;
  const RegisterOtpBottomSheet({super.key, required this.number});

  @override
  State<RegisterOtpBottomSheet> createState() => _RegisterOtpBottomSheetState();
}

class _RegisterOtpBottomSheetState extends State<RegisterOtpBottomSheet> {
  StreamController<ErrorAnimationType>? errorController;
  final formKey = GlobalKey<FormState>();
  TextEditingController pincodeController = TextEditingController();
  String currentText = "";
  bool hasError = false;
  String seconds = "60";
  int _remainingSeconds = 60;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Start the countdown timer when the bottom sheet is created
    startTimer();
  }

  Future<void> reSendOtp() async {
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

  // dailyCheckIn() async {
  //   String? token = Constants.prefs!.getString("token");
  //   final dailycheckData = FormData.fromMap({
  //     'access_token': token,
  //   });
  //   final dio = Dio();
  //   await dio
  //       .post(UrlLinksData.serverUrl + UrlLinksData.dailyCheckInUrl,
  //           data: dailycheckData)
  //       .then((value) {
  //     if (value.data['checkin_status'] == false) {
  //       Navigator.pop(context);
  //       Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => CheckInCheckOutScreen(
  //               type: 'Check In ',
  //             ),
  //           ));
  //     } else {
  //       Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => const BottomsNaviScreen(index: 0)),
  //           (route) => false);
  //     }
  //   });
  // }

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

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BasicDetailsBloc, BasicDetailsState>(
      listener: (context, state) {
        if (state is VerifyOtpSuccess) {
          // dailyCheckIn();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const BottomsNaviScreen(index: 0)),
              (route) => false);
        }
      },
      builder: (context, state) {
        return AnimatedPadding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          duration: const Duration(milliseconds: 150),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 900, minHeight: 150),
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      ConvertText.getTitle('Enter Your OTP'),
                      style: GoogleFonts.manrope(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      ConvertText.getTitle('An 4 digits code has been send to'),
                      style: GoogleFonts.manrope(),
                    ),
                    Text(widget.number),
                    Form(
                      key: formKey,
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
                          animationDuration: const Duration(milliseconds: 300),
                          enableActiveFill: true,
                          errorAnimationController: errorController,
                          controller: pincodeController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],

                          onCompleted: (v) {
                            debugPrint("Completed ");
                          },
                          // onTap: () {
                          // },
                          onChanged: (value) {
                            if(mounted){
                              setState(() {
                                currentText = value;
                              });
                            }
                          },
                          beforeTextPaste: (text) {
                            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                            //but you can show anything you want here, like your pop up saying wrong paste format or etc
                            return true;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        hasError
                            ? "*Please fill up all the cells properly"
                            : "",
                        style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ("00:$seconds" == '00:00')
                              ? TextButton(
                                  style: TextButton.styleFrom(
                                      padding: const EdgeInsets.all(0)),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    showRegisterOtpBottomSheet(
                                        context, widget.number);
                                    reSendOtp();
                                    // sendingcode(); //api calling function BHAI
                                    // snackBar("OTP Resend successfully");
                                    // setState(() {
                                    //   Timer? _timer;

                                    //   int _start = 30;
                                    //   String seconds = '30';

                                    //   startTimer();
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                    const SizedBox(
                      height: 10,
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
                            context.read<BasicDetailsBloc>().add(VerifyOtpEvent(
                                mobileNumber: widget.number.toString(),
                                otp: pincodeController.text.toString(),
                                type: 'register'));
                          },
                          child: Text(
                            ConvertText.getTitle("Verify"),
                            style: GoogleFonts.manrope(
                              letterSpacing: 0.8,
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          //  BlocBuilder<BasicDetailsBloc,
                          //     BasicDetailsState>(
                          //   builder: (context, state) {
                          //     if (state is VerifyOtpLoading) {
                          //       return CircularProgressIndicator();
                          //     }
                          //     if (state is ShowVerifyOtpState) {
                          //       return Text(
                          //         "Verify",
                          //         style: GoogleFonts.manrope(
                          //           letterSpacing: 0.8,
                          //           color: Colors.white,
                          //           fontSize: 14,
                          //           fontWeight: FontWeight.w600,
                          //         ),
                          //       );
                          //     }
                          //     return SizedBox.shrink();
                          //   },
                          // ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

void showRegisterOtpBottomSheet(BuildContext context, String number) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
    ),
    builder: (context) {
      return RegisterOtpBottomSheet(
        number: number,
      );
    },
  );
}
