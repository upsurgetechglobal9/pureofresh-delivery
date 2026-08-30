import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/login/screens/select_type_screen.dart';
import 'package:pure_o_fresh_rider_app/utility/widgets/theme_spinner.dart';

import '../../../commons/ConvertText.dart';
import '../../../utility/colors_data.dart';
import '../../../utility/internet_handler/logic/internet/internet_cubit.dart';
import '../../../utility/internet_handler/screen/no_internet_screen.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetCubit, InternetState>(
      builder: (context, internetState) {
        if (internetState.connected) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              decoration: const BoxDecoration(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 5, child: Image.asset("assets/images/ON B.png")),
                    Text(
                        ConvertText.getTitle(
                          'Delivering the Best Services',
                        ),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      ConvertText.getTitle(
                          'Seamless Bookings at your Fingertips Your Journey, Your Way'),
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1.0, top: 12),
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
                              borderRadius:
                                  BorderRadius.circular(5), // Border radius
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginSceen(),
                                ));
                          },
                          child: Text(
                            ConvertText.getTitle('LOGIN NOW'),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Background color
                            side: BorderSide(
                                color: ColorsData.themeColor,
                                width: 2), // Border color and width
                            elevation: 0, // Elevation set to 0
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(5), // Border radius
                            ),
                          ),
                          onPressed: () {
                            ///added type screen

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SelectRiderTypeScreen(),
                                ));
                            // /register screen
                            //  Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) =>
                            //           const EnterMobileNumberScreen(),
                            //     ));

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const SelectLanguageScreen(
                            //       type: '',
                            //     ),
                            //   ),
                            // );
                          },
                          child: Text(
                            ConvertText.getTitle('REGISTER FREE'),
                            style: GoogleFonts.manrope(
                              letterSpacing: 0.8,
                              color: ColorsData.themeColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        // child: ElevatedButton(
                        //   style: ElevatedButton.styleFrom(
                        //       backgroundColor: Colors.white,
                        //       side: const BorderSide(color: Colors.white, width: 2)),
                        //   onPressed: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) => const SelectLanguageScreen(
                        //             type: '',
                        //           ),
                        //         ));
                        //   },
                        //   child: Text(
                        //     ConvertText.getTitle('REGISTER FREE'),
                        //     style: GoogleFonts.manrope(
                        //       letterSpacing: 0.8,
                        //       color: Colors.black,
                        //       fontSize: 14,
                        //       fontWeight: FontWeight.w600,
                        //     ),
                        //   ),
                        // ),
                      ),
                    )
                  ],
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
}
