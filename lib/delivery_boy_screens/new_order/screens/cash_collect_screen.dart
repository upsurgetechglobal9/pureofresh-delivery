import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/new_order/screens/verify_otp.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pure_o_fresh_rider_app/commons/ConvertText.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/screens/commocoloo.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/navigationbar_screen.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/new_order/logic/new_order_bloc.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/new_order/screens/trip_summary_screen.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/new_order/widgets/swipe_no_back_widegt.dart';
import 'package:pure_o_fresh_rider_app/utility/colors_data.dart';

import '../widgets/dashed_painter.dart';

class CashCollectedScreen extends StatefulWidget {
  final String? apptype;
  const CashCollectedScreen({super.key, this.apptype});

  @override
  State<CashCollectedScreen> createState() => _CashCollectedScreenState();
}

class _CashCollectedScreenState extends State<CashCollectedScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewOrderBloc, NewOrderState>(
      listener: (context, state) {
        if (state is CompletingOrdeSuccessState) {
          // submitOTP();NewOrderOtpVerify

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const TripSummaryScreen(),
              ));
        }
        if (state is CompletingOrdeCabSuccessState) {
          // submitOTP();NewOrderOtpVerify

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TripSummaryScreen(apptype: widget.apptype),
              ));
        }
      },
      builder: (context, state) {
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
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
              elevation: 0,
              title: Text(
                "Pay Cash",
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: (Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                          "assets/images/cash_collect.png",
                          height: 120,
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<NewOrderBloc, NewOrderState>(
                    builder: (context, state) {
                      if (state is NewOrderDetailsSuccessState) {
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
                            Text(
                              "You Need To Collect Cash Payment",
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                            10.ph,
                            Text(
                              "₹ ${state.newOrderDetailsModel.data.grandTotal}",
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff098B09),
                                fontSize: 17,
                              ),
                            ),
                            10.ph,
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: <Widget>[
                                        Image.asset(
                                          "assets/images/Pickup.png",
                                          height: 20,
                                        ),
                                        const Dash(
                                            direction: Axis.vertical,
                                            length: 60,
                                            dashLength: 5,
                                            dashColor: Colors.grey),
                                        SvgPicture.asset(
                                          "assets/images/pin.svg",
                                          height: 20,
                                          width: 20,
                                          colorFilter: const ColorFilter.mode(
                                              Colors.red, BlendMode.srcIn),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.60,
                                                child: Text(
                                                  state
                                                      .newOrderDetailsModel
                                                      .data
                                                      .restaurantDetails
                                                      .restaurantName,
                                                  style: GoogleFonts.manrope(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: Text(
                                              state
                                                  .newOrderDetailsModel
                                                  .data
                                                  .restaurantDetails
                                                  .displayAddress,
                                              style: GoogleFonts.manrope(
                                                fontSize: 12,
                                              )),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.60,
                                                child: Text(
                                                  ConvertText.getTitle(
                                                      'DELIVER TO'),
                                                  style: GoogleFonts.manrope(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: state
                                                                  .newOrderDetailsModel
                                                                  .data
                                                                  .serviceStatus ==
                                                              'Ready To Pickup'
                                                          ? const Color(
                                                              0xFFfe8000)
                                                          : state.newOrderDetailsModel.data
                                                                      .serviceStatus ==
                                                                  'Out For Delivery'
                                                              ? const Color(
                                                                  0xFFc245bd)
                                                              : ColorsData
                                                                  .themeColor),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          state.newOrderDetailsModel.data
                                              .customerDetails.customerName,
                                          style: GoogleFonts.manrope(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: Text(
                                              state.newOrderDetailsModel.data
                                                  .customerAddress,
                                              style: GoogleFonts.manrope(
                                                fontSize: 12,
                                              )),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            20.ph,
                            SwipeButtonWidget(
                                acceptPoitTransition: 0.7,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                padding: const EdgeInsets.all(6),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 4,
                                    color: Color.fromRGBO(197, 197, 197, 0.25),
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
                                    alignment: const Alignment(0, 0),
                                    child: Text(
                                      ConvertText.getTitle('COD COLLECTED'),
                                      // 'COLLECT COD',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                  )
                                ],
                                childAfterSwiped: const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Colors.white,
                                  ),
                                ),
                                onHorizontalDragUpdate: (e) {},
                                onHorizontalDragRight: (e) async {
                                  /*context
                                      .read<NewOrderBloc>()
                                      .add(const CompleteOrderEvent());*/
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const NewOrderOtpVerify(),
                                      ));
                                  return true;
                                },
                                onHorizontalDragleft: (e) async {
                                  return false;
                                }),
                          ],
                        );
                      }
                      if (state is NewOrderDetailsCabSuccessState) {
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
                            Text(
                              "Please Collect Cash Payment",
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                            10.ph,
                            Text(
                              "₹ ${state.newOrderDetailsModel.data.remainingBalance}",
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff098B09),
                                fontSize: 17,
                              ),
                            ),
                            10.ph,
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Image.asset(
                                          "assets/images/Pickup.png",
                                          height: 20,
                                        ),
                                        // const Dash(
                                        //     direction: Axis.vertical,
                                        //     length: 70,
                                        //     dashLength: 5,
                                        //     dashColor: Colors.grey),
                                        Column(
                                          children: [
                                            if (state.newOrderDetailsModel.data
                                                    .droppingLocations.length >
                                                1)
                                              ...state.newOrderDetailsModel.data
                                                  .droppingLocations
                                                  .asMap()
                                                  .entries
                                                  .take(state
                                                          .newOrderDetailsModel
                                                          .data
                                                          .droppingLocations
                                                          .length -
                                                      1) // Take all but the last item
                                                  .map((entry) {
                                                return Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 42,
                                                      width: 1,
                                                      child: CustomPaint(
                                                        size: const Size(
                                                            1, double.infinity),
                                                        painter:
                                                            DashedLineVerticalPainter(),
                                                      ),
                                                    ),
                                                    Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                              color:
                                                                  Colors.black),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 3.0,
                                                                horizontal:
                                                                    5.0),
                                                        child: Text(
                                                          (entry.key + 1)
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 10),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }), // Ensure to call toList() here
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: 33,
                                              width: 1,
                                              child: CustomPaint(
                                                  size: const Size(
                                                      1, double.infinity),
                                                  painter:
                                                      DashedLineVerticalPainter()),
                                            ),
                                            SvgPicture.asset(
                                              "assets/images/pin.svg",
                                              height: 20,
                                              width: 20,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                      Colors.red,
                                                      BlendMode.srcIn),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      // color: Colors.amber,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${ConvertText.getTitle(
                                              widget.apptype == 'cab'
                                                  ? "Pickup Location"
                                                  : widget.apptype ==
                                                          'pickupanddrop'
                                                      ? "Pickup From"
                                                      : "Pickup From",
                                            )}:",
                                            style: GoogleFonts.manrope(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          1.ph,
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            height: 40,
                                            child: Text(
                                                state.newOrderDetailsModel.data
                                                    .pickupFrom,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.manrope(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: Text(
                                              "${ConvertText.getTitle(
                                                widget.apptype == 'cab'
                                                    ? "Drop Location"
                                                    : widget.apptype ==
                                                            'pickupanddrop'
                                                        ? "Deliver To"
                                                        : "Deliver To",
                                              )}:",
                                              style: GoogleFonts.manrope(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          1.ph,
                                          Column(
                                            children: List.generate(
                                              state.newOrderDetailsModel.data
                                                  .droppingLocations.length,
                                              (index) {
                                                return SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  height: 50,
                                                  child: Text(
                                                    state
                                                        .newOrderDetailsModel
                                                        .data
                                                        .droppingLocations[
                                                            index]
                                                        .address,
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.manrope(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            20.ph,
                            SwipeButtonWidget(
                                acceptPoitTransition: 0.7,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                padding: const EdgeInsets.all(6),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 4,
                                    color: Color.fromRGBO(197, 197, 197, 0.25),
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
                                    alignment: const Alignment(0, 0),
                                    child: Text(
                                      ConvertText.getTitle('COD COLLECTED'),
                                      // 'COLLECT COD',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                  )
                                ],
                                childAfterSwiped: const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Colors.white,
                                  ),
                                ),
                                onHorizontalDragUpdate: (e) {},
                                onHorizontalDragRight: (e) async {
                                  context.read<NewOrderBloc>().add(
                                      CompleteOrderCabEvent(
                                          refId: state
                                              .newOrderDetailsModel.data.id
                                              .toString(),
                                          apptype: widget.apptype!));

                                  return true;
                                },
                                onHorizontalDragleft: (e) async {
                                  return false;
                                }),
                          ],
                        );
                      }
                      return Padding(
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
                    },
                  ),
                ],
              )),
            ));
      },
    );
  }
}
