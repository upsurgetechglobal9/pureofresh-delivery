import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/screens/commocoloo.dart';
import 'package:pure_o_fresh_rider_app/utility/widgets/theme_spinner.dart';

import '../../../commons/ConvertText.dart';
import '../../../commons/shared_prefs.dart';
import '../../../utility/colors_data.dart';
import '../../navigation_bar/navigationbar_screen.dart';
import '../logic/new_order_bloc.dart';

class TripSummaryScreen extends StatefulWidget {
  final String? apptype;
  const TripSummaryScreen({super.key, this.apptype});

  @override
  State<TripSummaryScreen> createState() => _TripSummaryScreenState();
}

class _TripSummaryScreenState extends State<TripSummaryScreen> {
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewOrderBloc>().add(NewOrderDetailsEvent(
          refId: Constants.prefs!.getString("orderId")!,
          apptype: widget.apptype));
      // NewOrderDetailsEvent(refId: "2023082190740"));
    });
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomsNaviScreen(index: 0),
          ));

      return Future.value(false);
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BottomsNaviScreen(
                      index: 0,
                    ),
                  ),
                  (route) => false);
            },
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.black,
            ),
          ),
          titleSpacing: 0,
          title: Text(
            "Trip Summary",
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              decoration: const BoxDecoration(
                  // color: Color(0xFFebf5e3),
                  // borderRadius: BorderRadius.only(
                  //     bottomLeft: Radius.elliptical(400, 280),
                  //     bottomRight: Radius.elliptical(400, 280)),
                  ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/smile.png",
                    height: 120,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Good Job! You had Perfect Trip",
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  )
                ],
              ),
            ),
            BlocBuilder<NewOrderBloc, NewOrderState>(
              builder: (context, state) {
                if (state is NewOrderLoadingState) {
                  return const Center(
                    child: ThemeSpinner(
                      size: 50,
                    ),
                  );
                } else if (state is NewOrderDetailsSuccessState) {
                  return Column(
                    children: [
                      Center(
                        child: Text(
                          ConvertText.getTitle(
                              "ORDER ID : ${state.newOrderDetailsModel.data.refId}"),
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      10.ph,
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: ColorsData.themeColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Your Earning on this Trip:",
                                        style: GoogleFonts.manrope(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '₹ ${state.newOrderDetailsModel.data.expectedEarning}',
                                        style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                              width: 1,
                                              color: ColorsData.themeColor),
                                          right: BorderSide(
                                              width: 1,
                                              color: ColorsData.themeColor),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${ConvertText.getTitle("Pickup")}:",
                                              style: GoogleFonts.manrope(
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              state.newOrderDetailsModel.data
                                                  .distanceToStore,
                                              style: GoogleFonts.manrope(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                              width: 1,
                                              color: ColorsData.themeColor),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${ConvertText.getTitle("Dropping")}:",
                                              style: GoogleFonts.manrope(
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              state.newOrderDetailsModel.data
                                                  .distanceToCustomerFromStore,
                                              style: GoogleFonts.manrope(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (state is NewOrderDetailsCabSuccessState) {
                  return Column(
                    children: [
                      Center(
                        child: Text(
                          ConvertText.getTitle(
                              "ORDER ID : ${state.newOrderDetailsModel.data.orderId}"),
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      10.ph,
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: ColorsData.themeColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Your Earning on this Trip:",
                                        style: GoogleFonts.manrope(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        "₹ ${state.newOrderDetailsModel.data.earnings}",
                                        style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                              width: 1,
                                              color: ColorsData.themeColor),
                                          right: BorderSide(
                                              width: 1,
                                              color: ColorsData.themeColor),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${ConvertText.getTitle("Pickup")}:",
                                              style: GoogleFonts.manrope(
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              '${state.newOrderDetailsModel.data.pickupDistance} Kms',
                                              style: GoogleFonts.manrope(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                              width: 1,
                                              color: ColorsData.themeColor),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${ConvertText.getTitle("Dropping")}:",
                                              style: GoogleFonts.manrope(
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              '${state.newOrderDetailsModel.data.droppingDistance} Kms',
                                              style: GoogleFonts.manrope(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 1, color: ColorsData.themeColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${ConvertText.getTitle("Expecting Earning")}:",
                                    style: GoogleFonts.manrope(
                                      fontSize: 14,
                                    ),
                                  ),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey.shade200,
                                    highlightColor: Colors.white,
                                    child: Text(
                                      "     ",
                                      style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                          width: 1,
                                          color: ColorsData.themeColor),
                                      right: BorderSide(
                                          width: 1,
                                          color: ColorsData.themeColor),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${ConvertText.getTitle("Pickup")}:",
                                          style: GoogleFonts.manrope(
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          "       ",
                                          style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                          width: 1,
                                          color: ColorsData.themeColor),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${ConvertText.getTitle("Dropping")}:",
                                          style: GoogleFonts.manrope(
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          "    ",
                                          style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(
              width: 0,
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                        shape: MaterialStateProperty
                            .all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17),
                                side: const BorderSide(color: Colors.black)))),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BottomsNaviScreen(
                              index: 0,
                            ),
                          ),
                          (route) => false);
                    },
                    child: Text("Go Home".toUpperCase(),
                        style: const TextStyle(fontSize: 14))),
              ),
            ),
            //  Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10),
            //   child: ThemeElevatedButton(

            //     buttonName: 'Go Home',onPressed: (){

            //   },),
            // ),
          ],
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: ListTile(
        //   leading: SizedBox(
        //     height: 44,
        //     width: 44,
        //     child: CircularCountDownTimer(
        //       textStyle: TextStyle(
        //         fontSize: 16,
        //         color: ColorsData.themeColor,
        //         fontWeight: FontWeight.bold,
        //       ),
        //       duration: 45,
        //       initialDuration: 0,
        //       controller: CountDownController(),
        //       width: MediaQuery.of(context).size.width / 2,
        //       height: MediaQuery.of(context).size.height / 2,
        //       ringColor: Colors.white,
        //       fillColor: Colors.black,
        //       backgroundColor: Colors.grey[200],
        //       strokeWidth: 3.0,
        //       strokeCap: StrokeCap.round,
        //       textFormat: CountdownTextFormat.S,
        //       isReverse: false,
        //       isReverseAnimation: false,
        //       isTimerTextShown: true,
        //       autoStart: true,
        //       onStart: () {
        //       },
        //       onComplete: () {
        //       },
        //     ),
        //   ),
        //   tileColor: ColorsData.themeColor,
        //   title: Text(
        //     ConvertText.getTitle("New Order!"),
        //     style: GoogleFonts.manrope(
        //       fontWeight: FontWeight.w600,
        //       color: Colors.white,
        //       fontSize: 16,
        //     ),
        //   ),
        //   subtitle: Text(
        //     ConvertText.getTitle("Tap to see details and accept"),
        //     style: GoogleFonts.manrope(
        //       color: Colors.white,
        //       fontSize: 12,
        //     ),
        //   ),
        //   trailing: Icon(
        //     Icons.keyboard_arrow_up_outlined,
        //     color: Colors.white,
        //   ),
        // )
      ),
    );
  }
}
