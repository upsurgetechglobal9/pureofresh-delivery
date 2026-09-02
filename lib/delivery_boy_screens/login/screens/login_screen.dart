import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/basic_information.dart/screens/otp_verify_screen.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/login/screens/select_type_screen.dart';

import '../../../commons/ConvertText.dart';
import '../../../commons/shared_prefs.dart';
import '../../../commons/show_chuk_notification.dart';
import '../../../commons/url_links.dart';
import '../../../utility/colors_data.dart';
import '../../../utility/internet_handler/logic/internet/internet_cubit.dart';
import '../../../utility/internet_handler/screen/no_internet_screen.dart';
import '../../../utility/text_form_field.dart';
import '../../../utility/widgets/theme_spinner.dart';

class LoginSceen extends StatefulWidget {
  const LoginSceen({super.key});

  @override
  State<LoginSceen> createState() => _LoginSceenState();
}

class _LoginSceenState extends State<LoginSceen> {
  final verifyKey = GlobalKey<FormState>();
  final loginKey = GlobalKey<FormState>();

  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;

  String currentText = "";
  String deviceId = '';
  bool hasError = false;

  bool isSecure = true;
  bool isLoading = false;
  final int _remainingSeconds = 60;
  // late Timer _timer;
  Timer? _timer;
  int _start = 30;
  String seconds = '30';
  // @override
  // void initState() {
  //   // startTimer();

  //   errorController = StreamController<ErrorAnimationType>();
  //   super.initState();
  // }
  // void startTimer() {
  //   _timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     setState(() {
  //       if (_remainingSeconds > 0) {
  //         _remainingSeconds--;
  //       } else {
  //         // Timer has reached 0, you can perform actions like
  //         // re-sending OTP or closing the bottom sheet.
  //         _timer.cancel(); // Stop the timer
  //       }
  //     });
  //   });
  // }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          if (mounted) {
            setState(() {
              _start--;
              if (_start < 10) {
                seconds = '0$_start';
              } else {
                seconds = _start.toString();
              }
            });
          }
        }
      },
    );
  }

  Future<void> doLogin() async {
    Future.delayed(Duration.zero, () async {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? '';
      }
    });
    final FormState? form = loginKey.currentState;
    if (form!.validate()) {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      final formData = FormData.fromMap({
        'username': numberController.text,
      });
      final dio = Dio();
      addChuck(dio);
      final response = await dio
          .post(UrlLinksData.serverUrl + UrlLinksData.loginUrl, data: formData);
      if (response.data['err_code'] == 'valid') {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          // startTimer();
          // showOtpBottomSheet(context, numberController.text.toString());
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpVerifyScreen(
                    mobileNumber: numberController.text.toString(),
                    type: 'login'),
              ));
        }
      } else if (response.data['err_code'] == 'invalid') {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: response.data['message']);
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      if (kDebugMode) {
        print("form invalid");
      }
    }
  }

  Future<void> doVerify() async {
    final FormState? form = verifyKey.currentState;
    if (form!.validate()) {
      final formData = FormData.fromMap({
        'mobile': numberController.text,
        'otp': pincodeController.text,
        'platform_type': 'android',
        'device_id': deviceId,
        'type': 'login'
      });
      final dio = Dio();
      addChuck(dio);
      final response = await dio.post(
          UrlLinksData.serverUrl + UrlLinksData.verifyOtpUrl,
          data: formData);
      if (response.data['err_code'] == 'valid') {
        Constants.prefs!
            .setString("token", response.data['user_details']['access_token']);
        final pendingData = FormData.fromMap({
          'access_token': response.data['user_details']['access_token'],
        });
        // final responseforPending = await dio.post(
        //     UrlLinksData.serverUrl + UrlLinksData.dailyCheckInUrl,
        //     data: pendingData);
      } else {
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
          .showSnackBar(const SnackBar(content: Text("form invalid")));
    }
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   errorController!.close();
  //   pincodeController.clear();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetCubit, InternetState>(
      builder: (context, internetState) {
        if (internetState.connected) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              elevation: 0,
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                          ConvertText.getTitle(
                            'LOGIN!',
                          ),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          )),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        ConvertText.getTitle(
                            'Hi, Welcome Back to the Pure O Fresh'),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Form(
                        key: loginKey,
                        child: DeliveryBoyTextFormField(
                            controller: numberController,
                            isDense: true,
                            hint: ConvertText.getTitle('Phone Number'),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              FilteringTextInputFormatter.deny(RegExp(r'^0+')),
                              LengthLimitingTextInputFormatter(10)
                            ],
                            hintStyle: GoogleFonts.manrope(
                                color: Colors.grey, fontSize: 12),
                            validator: (text) {
                              if (text!.isEmpty || text.length < 10) {
                                return "Please enter phone number";
                              }
                              return null;
                            }),
                      ),

                      // DeliveryBoyTextFormField(
                      //   obscureText: isSecure,
                      //   suffixIcon: IconButton(
                      //       onPressed: () {
                      //         setState(() {
                      //           isSecure = !isSecure;
                      //         });
                      //       },
                      //       icon: !isSecure
                      //           ? Icon(Icons.visibility)
                      //           : Icon(Icons.visibility_off)),
                      //   prefixIcon: Icon(Icons.lock),
                      //   isDense: true,
                      //   hint: "Password",
                      //   hintStyle:
                      //       GoogleFonts.manrope(color: Colors.grey, fontSize: 12),
                      // ),
                      // SizedBox(
                      //   height: 6,
                      // ),
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: TextButton(
                      //     style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                      //     onPressed: () {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (context) => SelectLanguageScreen(),
                      //           ));
                      //     },
                      //     child: Text("Forgot Password?",
                      //         style: GoogleFonts.manrope(
                      //           color: Colors.black,
                      //           fontSize: 12,
                      //         )),
                      //   ),
                      // ),
                      const SizedBox(
                        height: 10,
                      ),
                      isLoading
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 0),
                              child: SizedBox(
                                height: 45,
                                width: double.infinity,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorsData.themeColor,
                                      side: BorderSide(
                                          color: ColorsData.themeColor,
                                          width: 2), // Border color and width
                                      elevation: 0, // Elevation set to 0
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            5), // Border radius
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: const SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 0),
                              child: SizedBox(
                                height: 45,
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorsData.themeColor,
                                    side: BorderSide(
                                        color: ColorsData.themeColor,
                                        width: 2), // Border color and width
                                    elevation: 0, // Elevation set to 0
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          5), // Border radius
                                    ),
                                  ),
                                  onPressed: () {
                                    doLogin();
                                  },
                                  child: Text(
                                    ConvertText.getTitle('Login'),
                                    style: GoogleFonts.manrope(
                                      // letterSpacing: 0.6,
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(ConvertText.getTitle("Didn't have an account?"),
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                color: Colors.grey,
                              )),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SelectRiderTypeScreen(),
                                  ));

                              //  Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) =>
                              //           const EnterMobileNumberScreen(),
                              //     ));

                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              //         const SelectLanguageScreen(
                              //       type: '',
                              //     ),
                              //   ),
                              // );
                            },
                            child: Text(ConvertText.getTitle("Sign Up"),
                                style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.black)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (internetState.disconnected) {
          return const NoInternetScreen();
        }
        return const Center(child: ThemeSpinner());
      },
    );
  }

  void verifyOTPbottm(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      // isScrollControlled: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
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
                    Text(numberController.text),
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
                            // },
                            onChanged: (value) {
                              debugPrint(value);
                              setState(() {
                                currentText = value;
                              });
                            },
                            beforeTextPaste: (text) {
                              debugPrint("Allowing to paste $text");
                              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                              //but you can show anything you want here, like your pop up saying wrong paste format or etc
                              return true;
                            },
                          )),
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
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ("00:$seconds" == '00:00')
                              ? TextButton(
                                  onPressed: () {
                                    // sendingcode(); //api calling function BHAI
                                    // snackBar("OTP Resend successfully");
                                    setState(() {
                                      Timer? timer;

                                      int start = 30;
                                      String seconds = '30';

                                      startTimer();
                                      // print("object.......$Ip");
                                      const oneSec = Duration(seconds: 1);
                                      timer = Timer.periodic(
                                        oneSec,
                                        (Timer timer) {
                                          if (start == 0) {
                                            setState(() {
                                              timer.cancel();
                                            });
                                          } else {
                                            setState(() {
                                              start--;
                                              if (start < 10) {
                                                seconds = '0$start';
                                              } else {
                                                seconds = start.toString();
                                              }
                                            });
                                          }
                                        },
                                      );
                                    });
                                  },
                                  child: Text(
                                    'Resend OTP',
                                    style: GoogleFonts.poppins(
                                        color: ColorsData.themeColor,
                                        fontSize: 16,
                                        decoration: TextDecoration.underline),
                                  ))
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Resend code in ",
                                      style: GoogleFonts.poppins(
                                          // fontFamily: MFONT,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                    Text("00:$seconds",
                                        style: GoogleFonts.poppins(
                                            color: ColorsData.themeColor,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),

                          const Text("Resend OTP"),
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
                            backgroundColor: const Color(0xFF000000),
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
        );
      },
    );
  }
}

class BottomSheetExample extends StatelessWidget {
  const BottomSheetExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text('showModalBottomSheet'),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('Modal BottomSheet'),
                      ElevatedButton(
                        child: const Text('Close BottomSheet'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
