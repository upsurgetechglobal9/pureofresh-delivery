import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pure_o_fresh_rider_app/commons/ConvertText.dart';
import 'package:pure_o_fresh_rider_app/commons/show_chuk_notification.dart';
import 'package:pure_o_fresh_rider_app/commons/url_links.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/basic_information.dart/logic/bloc/basic_details_bloc.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/navigationbar_screen.dart';
import 'package:pure_o_fresh_rider_app/utility/colors_data.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String mobileNumber, type;
  const OtpVerifyScreen(
      {super.key, required this.mobileNumber, required this.type});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  String seconds = "30";
  int _remainingSeconds = 30;
  late Timer _timer;
  final formKey = GlobalKey<FormState>();
  StreamController<ErrorAnimationType>? errorController;
  TextEditingController pincodeController = TextEditingController();
  String currentText = "";
  bool hasError = false;

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

  Future<void> reSendOtp() async {
    final formData = FormData.fromMap({
      'mobile': widget.mobileNumber,
    });
    final dio = Dio();
    addChuck(dio);
    final response = await dio.post(
        UrlLinksData.serverUrl + UrlLinksData.resendOtpUrl,
        data: formData);
    if (response.data['err_code'] == 'valid') {
      Fluttertoast.showToast(msg: "OTP sent successfully");
      setState(() {
        _remainingSeconds = 30;
        seconds = "30";
      });
      startTimer();
    } else if (response.data['err_code'] == 'invalid') {
      Fluttertoast.showToast(msg: response.data['message']);
    }
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
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade300,
                ),
                child: Center(
                    child: Icon(
                  Icons.arrow_back_ios,
                  color: ColorsData.themeColor,
                  size: 15,
                )),
              ),
            ),
          ),
          body: Column(
            children: [
              const Text(
                'Verification!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'ProximaNova',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text:
                          'We have sent the code verification to your registered \nMobile Number ',
                      style: TextStyle(
                        color: Color(0xFF3A3A3A),
                        fontSize: 12,
                        fontFamily: 'ProximaNova',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: '+91 ${widget.mobileNumber}',
                      style: const TextStyle(
                        color: Color(0xFF3A3A3A),
                        fontSize: 12,
                        fontFamily: 'ProximaNova',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                  child: PinCodeTextField(
                    autoDisposeControllers: false,
                    appContext: context,
                    pastedTextStyle: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 4,

                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    validator: (v) {
                      if (v!.length <= 3) {
                        return "Please enter valid OTP";
                      } else {
                        return null;
                      }
                    },
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
                      debugPrint(value);
                      if (mounted) {
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
                  hasError ? "*Please fill up all the cells properly" : "",
                  style: GoogleFonts.poppins(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: BlocBuilder<BasicDetailsBloc, BasicDetailsState>(
                    builder: (context, state) {
                      if (state is VerifyOtpLoading) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsData.themeColor,
                          ),
                          onPressed: () {},
                          child: const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      } else {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsData.themeColor,
                          ),
                          onPressed: () {
                            if (pincodeController.text.isEmpty) {
                              Fluttertoast.showToast(msg: "Please enter OTP");
                            } else {
                              context
                                  .read<BasicDetailsBloc>()
                                  .add(VerifyOtpEvent(
                                    mobileNumber:
                                        widget.mobileNumber.toString(),
                                    otp: pincodeController.text.toString(),
                                    type: widget.type,
                                  ));
                            }

                            // context.read<BasicDetailsBloc>().add(VerifyOtpEvent(
                            //     mobileNumber: widget.mobileNumber.toString(),
                            //     otp: pincodeController.text.toString(),
                            //     type: widget.type));
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
                        );
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0, bottom: 5, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ("00:$seconds" == '00:00')
                        ? TextButton(
                            style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(0)),
                            onPressed: () {
                              reSendOtp();
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
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
