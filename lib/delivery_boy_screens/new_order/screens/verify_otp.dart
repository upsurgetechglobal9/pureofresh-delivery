import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../commons/ConvertText.dart';
import '../../../commons/shared_prefs.dart';
import '../../../utility/colors_data.dart';
import '../logic/new_order_bloc.dart';
import '../widgets/swipe_no_back_widegt.dart';
import '../widgets/swiper_button_widget.dart';
import 'trip_summary_screen.dart';

class NewOrderOtpVerify extends StatefulWidget {
  const NewOrderOtpVerify({super.key});

  @override
  State<NewOrderOtpVerify> createState() => _NewOrderOtpVerifyState();
}

class _NewOrderOtpVerifyState extends State<NewOrderOtpVerify> {
  final otpFinalKey = GlobalKey<FormState>();
  TextEditingController otpCodeController = TextEditingController();
  StreamController<ErrorAnimationType>? errortypeotpController;

  String? currentText;
  String? refrId = '';
  @override
  void initState() {
    refrId = Constants.prefs!.getString("orderId");

    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewOrderBloc>().add(
          NewOrderDetailsEvent(refId: Constants.prefs!.getString("orderId")!));
      // NewOrderDetailsEvent(refId: "2023082190740"));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewOrderBloc, NewOrderState>(
      listener: (context, state) {
        if (state is SendingOTPSuccessState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TripSummaryScreen(),
              ));
        }
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: SizedBox(
              // height: 260,
              child: Container(
                constraints: BoxConstraints(maxHeight: 900, minHeight: 150),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            ConvertText.getTitle(
                                "Enter OTP to mark as Delivered"),
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  "Order ID: $refrId",
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              ConvertText.getTitle("Enter 4 Digit OTP"),
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Form(
                              key: otpFinalKey,
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
                                      selectedColor: Colors.black,
                                      inactiveFillColor: Colors.grey[100],
                                      activeFillColor: Colors.white,
                                      activeColor: Colors.black,
                                      inactiveColor: Colors.grey[300],
                                      shape: PinCodeFieldShape.underline,
                                      borderRadius: BorderRadius.circular(5),
                                      fieldHeight: 50,
                                      fieldWidth: 45,
                                    ),
                                    cursorColor: Colors.black,
                                    animationDuration:
                                        const Duration(milliseconds: 300),
                                    enableActiveFill: true,
                                    errorAnimationController:
                                        errortypeotpController,
                                    controller: otpCodeController,
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
                            BlocBuilder<NewOrderBloc, NewOrderState>(
                              builder: (context, state) {
                                return SwipeButtonWidget(
                                    acceptPoitTransition: 0.7,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    padding: const EdgeInsets.all(6),
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 4,
                                        color:
                                            Color.fromRGBO(197, 197, 197, 0.25),
                                        spreadRadius: 1.5,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(30),
                                    colorBeforeSwipe: ColorsData.themeColor,
                                    colorAfterSwiped: ColorsData.themeColor,
                                    height: 50,
                                    childBeforeSwipe: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: ColorsData.themeColor,
                                      ),
                                      height: double.infinity,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.double_arrow_rounded,
                                          color: ColorsData.themeColor,
                                        ),
                                      ),
                                    ),
                                    leftChildren: [
                                      Align(
                                        alignment: Alignment(0, 0),
                                        child: Text(
                                          ConvertText.getTitle('SUBMIT OTP'),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                      )
                                    ],
                                    childAfterSwiped: Container(
                                      height: 24,
                                      width: 24,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 3,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onHorizontalDragUpdate: (e) {},
                                    onHorizontalDragRight: (e) async {
                                      final FormState? form =
                                          otpFinalKey.currentState;
                                      if (form!.validate()) {
                                        print(
                                            "object ${otpCodeController.text.toString()}");

                                        context.read<NewOrderBloc>().add(
                                            CompleteOrderEvent(otpCodeController.text.toString()));
                                        /*Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TripSummaryScreen(),
                                            ));*/
                                      } else {
                                        print("form invalid");
                                      }
                                      return true;
                                    },
                                    onHorizontalDragleft: (e) async {
                                      return false;
                                    });

                                // Swipperbuttonwidget(
                                //     onSwipeFun: () {
                                //       final FormState? form =
                                //           otpFinalKey.currentState;
                                //       if (form!.validate()) {
                                //         print(
                                //             "object ${otpCodeController.text.toString()}");

                                //         context.read<NewOrderBloc>().add(
                                //             SendingOTPEvent(
                                //                 otp: otpCodeController.text
                                //                     .toString()));
                                //         // Navigator.push(
                                //         //     context,
                                //         //     MaterialPageRoute(
                                //         //       builder: (context) => TripSummaryScreen(),
                                //         //     ));
                                //       } else {
                                //         print("form invalid");
                                //       }
                                //     },
                                //     buttonTitle: "SUBMIT OTP");
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  //   Padding OtpVeryScreenWidget() {
  //   return Padding(
  //     // padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
  //     padding: const EdgeInsets.all(8.0),
  //     child: Center(
  //       child: SingleChildScrollView(
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 23),
  //           child: Container(
  //             decoration: ShapeDecoration(
  //               color: Colors.white,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(15),
  //               ),
  //             ),
  //             child: Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 32),
  //               child: Column(
  //                 children: [
  //                   58.ph,
  //                   SizedBox(height: 60,),
  //                   Image.asset(
  //                     'assets/FoodRestaurant/OTP.png',
  //                     width: 193,
  //                     height: 224.60,
  //                   ),
  //                   13.4.ph,
  //                   SizedBox(height: 13,),
  //                   Text(
  //                     'Verification Code',
  //                     style: TextStyle(
  //                       color: Colors.black,
  //                       fontSize: 20,
  //                       fontFamily: 'Manrope',
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                   13.ph,
  //                   SizedBox(height: 12,),
  //                   Text.rich(
  //                     TextSpan(
  //                       children: [
  //                         TextSpan(
  //                           text:
  //                               'We have sent the code verification to your\nregistered Mobile Number ',
  //                           style: TextStyle(
  //                             color: Color(0xFF3A3A3A),
  //                             fontSize: 12,
  //                             fontFamily: 'Manrope',
  //                             fontWeight: FontWeight.w400,
  //                           ),
  //                         ),
  //                         TextSpan(
  //                           text:
  //                               '+91-${contactNumberController.text.toString()}',
  //                           style: TextStyle(
  //                             color: Color(0xFF3A3A3A),
  //                             fontSize: 12,
  //                             fontFamily: 'Manrope',
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                   27.ph,
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     children: List.generate(
  //                       4,
  //                       (index) => SizedBox(
  //                         width: 54,
  //                         height: 54,
  //                         child: TextFormField(
  //                           controller: _controllers[index],
  //                           style: const TextStyle(
  //                               color: Colors.black,
  //                               fontWeight: FontWeight.w700,
  //                               fontSize: 18),
  //                           focusNode: _focusNodes[index],
  //                           keyboardType: TextInputType.number,
  //                           maxLength: 1,
  //                           obscureText: false,
  //                           onChanged: (value) => _onOtpChanged(value, index),
  //                           decoration: InputDecoration(
  //                             counterStyle: const TextStyle(color: Colors.red),
  //                             counterText: '',
  //                             contentPadding: const EdgeInsets.symmetric(
  //                                 horizontal: 20, vertical: 10),
  //                             border: OutlineInputBorder(
  //                               borderRadius: BorderRadius.circular(5.0),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   17.ph,
  //                   const Align(
  //                       alignment: Alignment.topRight,
  //                       child: Text.rich(
  //                         TextSpan(
  //                           children: [
  //                             TextSpan(
  //                               text: 'Resend OTP ',
  //                               style: TextStyle(
  //                                 color: Color(0xFF3A3A3A),
  //                                 fontSize: 12,
  //                                 fontFamily: 'Manrope',
  //                                 fontWeight: FontWeight.w400,
  //                               ),
  //                             ),
  //                             TextSpan(
  //                               text: '0:59 Sec',
  //                               style: TextStyle(
  //                                 color: Color(0xFF7EC245),
  //                                 fontSize: 12,
  //                                 fontFamily: 'Manrope',
  //                                 fontWeight: FontWeight.w400,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         textAlign: TextAlign.center,
  //                       )),
  //                   13.ph,
  //                   BlocBuilder<RestaurantRegisterBloc,
  //                       RestaurantRegisterState>(
  //                     builder: (context, state) {
  //                       return MaterialButton(
  //                         onPressed: () {
  //                           String otp = _controllers.fold(
  //                               '', (otp, controller) => otp + controller.text);
  //                           context.read<RestaurantRegisterBloc>().add(
  //                                 VerifyOtpEvent(
  //                                   otp: otp,
  //                                   mobileNumber:
  //                                       contactNumberController.text.toString(),
  //                                 ),
  //                               );
  //                           // _pageController.nextPage(
  //                           //   duration: const Duration(milliseconds: 300),
  //                           //   curve: Curves.easeInOut,
  //                           // );
  //                           // Navigator.pushReplacementNamed(context, '/BottomBar');
  //                         },
  //                         color: const Color(0xff7ec245),
  //                         minWidth: double.infinity,
  //                         height: 43,
  //                         shape: OutlineInputBorder(
  //                           borderRadius: BorderRadius.circular(5),
  //                           borderSide: BorderSide.none,
  //                         ),
  //                         child: Text(
  //                           'Verify',
  //                           style: TextStyle(
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                         // state.verifyOTPLoading
  //                         //     ? Container(
  //                         //         height: 20,
  //                         //         width: 20,
  //                         //         child: CircularProgressIndicator(
  //                         //             strokeWidth: 2, color: Colors.white))
  //                         //     : const Text(
  //                         //         'Verify',
  //                         //         style: TextStyle(
  //                         //           color: Colors.white,
  //                         //         ),
  //                         //       ),
  //                       );
  //                     },
  //                   ),
  //                   48.ph,
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
