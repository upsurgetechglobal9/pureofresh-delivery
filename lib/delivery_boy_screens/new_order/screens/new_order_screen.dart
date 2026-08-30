import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pure_o_fresh_rider_app/commons/shared_prefs.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/screens/commocoloo.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/new_order/widgets/dashed_painter.dart';
import 'package:pure_o_fresh_rider_app/utility/common_text.dart';

import '../../../commons/ConvertText.dart';
import '../../../utility/colors_data.dart';
import '../../navigation_bar/navigationbar_screen.dart';
import '../logic/new_order_bloc.dart';
import '../widgets/swipe_no_back_widegt.dart';
import 'near_to_pickup_location_screen.dart';

class NewOrderScreen extends StatefulWidget {
  final String orderId;
  String? apptype;
  NewOrderScreen({super.key, required this.orderId, this.apptype});

  static const routeName = "/new_order";

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  String buttonTitle = "Accept the Order";

  @override
  void initState() {
    print("new order screen ${widget.apptype}");
    // TODO: implement initState
    super.initState();
    Constants.prefs!.setString("orderId", widget.orderId);
    context.read<NewOrderBloc>().add(
        NewOrderDetailsEvent(refId: widget.orderId, apptype: widget.apptype));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewOrderBloc, NewOrderState>(
      listener: (context, state) {
        // TODO: implement listener

        if (state is OrderAcceptSuccessState) {
          Navigator.pushReplacementNamed(context, NearToPickUp.routeName,
              arguments: {'ref_id': widget.orderId, 'apptype': widget.apptype});
          // arguments: {'ref_id': widget.orderId});
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => NearToPickUp(
          //         type: '',
          //         refId: widget.orderId,
          //       ),
          //     ));
        }
        if (state is OrderAcceptCabSuccessState) {
          Navigator.pushReplacementNamed(context, NearToPickUp.routeName,
              arguments: {'ref_id': widget.orderId, 'apptype': widget.apptype});
        }
        if (state is OrderAcceptFailedState) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomsNaviScreen(index: 0),
              ),
              (route) => false);
        }
        if (state is OrderAcceptCabFailedState) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomsNaviScreen(index: 0),
              ),
              (route) => false);
        }
      },
      builder: (context, state) {
        return BlocBuilder<NewOrderBloc, NewOrderState>(
            builder: (context, state) {
          if (state is NewOrderDetailsSuccessState) {
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListView(
                    // padding: EdgeInsets.all(0),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 8.0, top: 5, bottom: 5),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  backgroundColor: const Color(0xfffd0502)),
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const BottomsNaviScreen(index: 0),
                                    ),
                                    (route) => false);
                              },
                              icon: const Icon(
                                Icons.close_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                              label: Text(
                                ConvertText.getTitle("Deny"),
                                style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              )),
                        ),
                      ),
                      Center(
                        child: Text(
                          ConvertText.getTitle("New Food Order!"),
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      20.ph,
                      SizedBox(
                        height: 205,
                        width: 205,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CircularCountDownTimer(
                              duration: 60,
                              initialDuration: 0,
                              controller: CountDownController(),
                              width: MediaQuery.of(context).size.width / 2,
                              height: MediaQuery.of(context).size.height / 2,
                              ringColor: Colors.white,
                              fillColor: const Color(0xffFF3D3D),
                              backgroundColor: Colors.grey[200],
                              strokeWidth: 10.0,
                              strokeCap: StrokeCap.round,
                              textFormat: CountdownTextFormat.S,
                              isReverse: false,
                              isReverseAnimation: false,
                              isTimerTextShown: true,
                              autoStart: true,
                              onStart: () {
                                print('Countdown Started');
                              },
                              onComplete: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const BottomsNaviScreen(index: 0),
                                    ),
                                    (route) => false);
                                print('Countdown Ended');
                              },
                            ),
                            Positioned(
                              top: (205 - 96) / 2,
                              left: 0,
                              right: 0,
                              child: Image.asset(
                                widget.apptype == 'cab'
                                    ? 'assets/images/ridenew.png'
                                    : widget.apptype == 'pickupanddrop'
                                        ? 'assets/images/pickdropnew.png'
                                        : "assets/images/box8 [Converted] 1.png",
                                width: 158,
                                height: 96,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          ConvertText.getTitle(
                              "ORDER ID : ${state.newOrderDetailsModel.data.refId}"),
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: ColorsData.themeColor),
                          // border: Border(
                          //     top: BorderSide(width: 1, color: ColorsData.themeColor),
                          //     bottom: BorderSide(width: 1, color: ColorsData.themeColor),
                          //     left: BorderSide(width: 1, color: ColorsData.themeColor),
                          //     right: BorderSide(width: 1, color: ColorsData.themeColor)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Container(
                              // decoration: BoxDecoration(
                              //   border: Border(
                              //       top: BorderSide(
                              //           width: 1, color: ColorsData.themeColor),
                              //       left: BorderSide(
                              //           width: 1, color: ColorsData.themeColor),
                              //       right: BorderSide(
                              //           width: 1, color: ColorsData.themeColor)),
                              //   // borderRadius: BorderRadius.circular(0),
                              // ),
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${ConvertText.getTitle("Expected Earning")}:",
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "₹ ${state.newOrderDetailsModel.data.expectedEarning.toString()}",
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
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            state.newOrderDetailsModel.data
                                                .distanceToStore
                                                .toString(),
                                            style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
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
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            state.newOrderDetailsModel.data
                                                .distanceToCustomerFromStore
                                                .toString(),
                                            style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
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
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: ColorsData.themeColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                  const Dash(
                                      direction: Axis.vertical,
                                      length: 70,
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
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                // color: Colors.amber,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${ConvertText.getTitle("Pickup From")}:",
                                      style: GoogleFonts.manrope(
                                        fontSize: 10,
                                      ),
                                    ),
                                    Text(
                                      state.newOrderDetailsModel.data
                                          .restaurantDetails.restaurantName
                                          .toString(),
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Text(
                                          state.newOrderDetailsModel.data
                                              .restaurantDetails.displayAddress
                                              .toLowerCase(),
                                          style: GoogleFonts.manrope(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Text(
                                        "${ConvertText.getTitle("Deliver To")}:",
                                        style: GoogleFonts.manrope(
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      state.newOrderDetailsModel.data
                                          .customerDetails.customerName
                                          .toString(),
                                      style: GoogleFonts.manrope(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Text(
                                        state.newOrderDetailsModel.data
                                            .customerAddress,
                                        style: GoogleFonts.manrope(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     border: Border.all(width: 1, color: ColorsData.themeColor),
                      //     borderRadius: BorderRadius.circular(8),
                      //   ),
                      //   width: double.infinity,
                      //   child: Padding(
                      //     padding:
                      //         const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           "Pickup from: ",
                      //           style: GoogleFonts.manrope(
                      //             fontWeight: FontWeight.w500,
                      //             fontSize: 10,
                      //           ),
                      //         ),
                      //         const SizedBox(
                      //           height: 2,
                      //         ),
                      //         Text(
                      //           "Burger King",
                      //           style: GoogleFonts.manrope(
                      //             fontWeight: FontWeight.w700,
                      //             fontSize: 14,
                      //           ),
                      //         ),
                      //         const SizedBox(
                      //           height: 2,
                      //         ),
                      //         Text(
                      //           "Opposite Diamond Park, Dondaparthy , Dwaraka Nagar, Visakhapatnam, Andhra Pradesh 530016",
                      //           style: GoogleFonts.manrope(
                      //             fontWeight: FontWeight.w500,
                      //             fontSize: 14,
                      //           ),
                      //         ),
                      //         const SizedBox(
                      //           height: 5,
                      //         ),
                      //         Row(
                      //           children: [
                      //             Icon(
                      //               Icons.access_time_rounded,
                      //               color: ColorsData.greytimeColor,
                      //               size: 12,
                      //             ),
                      //             SizedBox(
                      //               width: 2,
                      //             ),
                      //             Text(
                      //               "05 Mins",
                      //               style: GoogleFonts.manrope(
                      //                   fontWeight: FontWeight.w500,
                      //                   fontSize: 9,
                      //                   color: ColorsData.greytimeColor),
                      //             ),
                      //           ],
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      const SizedBox(
                        height: 10,
                      ),
                      state.newOrderDetailsModel.data.paymentMode ==
                              "Pay On Delivery"
                          ? Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: ColorsData.themeColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Note: ",
                                      style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      "As It was COD Order please make sure you have to Maintain Sufficient Liquid Cash",
                                      style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),

                      // SwipeButtonWidget(
                      //     acceptPoitTransition: 0.7,
                      //     margin: const EdgeInsets.symmetric(horizontal: 10),
                      //     padding: const EdgeInsets.all(6),
                      //     boxShadow: const [
                      //       BoxShadow(
                      //         blurRadius: 4,
                      //         color: Color.fromRGBO(197, 197, 197, 0.25),
                      //         spreadRadius: 1.5,
                      //       ),
                      //     ],
                      //     borderRadius: BorderRadius.circular(30),
                      //     colorBeforeSwipe: ColorsData.themeColor,
                      //     colorAfterSwiped: ColorsData.themeColor,
                      //     height: 50,
                      //     childBeforeSwipe: Container(
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(30),
                      //         color: ColorsData.themeColor,
                      //       ),
                      //       height: double.infinity,
                      //       child: CircleAvatar(
                      //         backgroundColor: Colors.white,
                      //         child: Icon(
                      //           Icons.double_arrow_rounded,
                      //           color: ColorsData.themeColor,
                      //         ),
                      //       ),
                      //     ),
                      //     leftChildren: const [
                      //       Align(
                      //         alignment: Alignment(0, 0),
                      //         child: Text(
                      //           'ACCEPT THE ORDER',
                      //           style: TextStyle(
                      //               fontSize: 16,
                      //               fontWeight: FontWeight.w600,
                      //               color: Colors.white),
                      //         ),
                      //       )
                      //     ],
                      //     childAfterSwiped: Container(
                      //       height: 24,
                      //       width: 24,
                      //       child: const CircularProgressIndicator(
                      //         strokeWidth: 3,
                      //         color: Colors.white,
                      //       ),
                      //     ),
                      //     onHorizontalDragUpdate: (e) {},
                      //     onHorizontalDragRight: (e) async {
                      //       print(
                      //           "its working ${state.newOrderDetailsModel.data.refId}");
                      //       context.read<NewOrderBloc>().add(
                      //           AcceptingOrderEvent(
                      //               refId: state.newOrderDetailsModel.data.refId
                      //                   .toString()));
                      //       return true;
                      //     },
                      //     onHorizontalDragleft: (e) async {
                      //       return false;
                      //     }),

                      // Swipperbuttonwidget(
                      //     onSwipeFun: () {
                      //       print(
                      //           "its working ${state.newOrderDetailsModel.data.refId}");
                      //       context.read<NewOrderBloc>().add(
                      //           AcceptingOrderEvent(
                      //               refId: state
                      //                   .newOrderDetailsModel.data.refId
                      //                   .toString()));
                      //       // Navigator.push(
                      //       //   context,
                      //       //   MaterialPageRoute(
                      //       //     builder: (context) => NearToPickUp(
                      //       //       type: '',
                      //       //     ),
                      //       //   ),
                      //       // );
                      //     },
                      //     buttonTitle: buttonTitle),
                      const SizedBox(
                        height: 65,
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: SwipeButtonWidget(
                    acceptPoitTransition: 0.7,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
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
                          ConvertText.getTitle('ACCEPT THE ORDER'),
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
                      print(
                          "its working ${state.newOrderDetailsModel.data.refId}");
                      context.read<NewOrderBloc>().add(AcceptingOrderEvent(
                          refId: state.newOrderDetailsModel.data.refId
                              .toString()));
                      return true;
                    },
                    onHorizontalDragleft: (e) async {
                      return false;
                    }),
              ),
            );
          } else if (state is NewOrderDetailsCabSuccessState) {
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListView(
                    // padding: EdgeInsets.all(0),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 8.0, top: 5, bottom: 5),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  backgroundColor: const Color(0xfffd0502)),
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const BottomsNaviScreen(index: 0),
                                    ),
                                    (route) => false);
                              },
                              icon: const Icon(
                                Icons.close_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                              label: Text(
                                ConvertText.getTitle("Deny"),
                                style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              )),
                        ),
                      ),
                      Center(
                        child: Text(
                          ConvertText.getTitle(
                            widget.apptype == 'cab'
                                ? "New Ride!"
                                : widget.apptype == 'pickupanddrop'
                                    ? "New Pick & Drop Order!"
                                    : "New Order!",
                          ),
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      20.ph,
                      SizedBox(
                        height: 205,
                        width: 205,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CircularCountDownTimer(
                              duration: 60,
                              initialDuration: 0,
                              controller: CountDownController(),
                              width: MediaQuery.of(context).size.width / 2,
                              height: MediaQuery.of(context).size.height / 2,
                              ringColor: Colors.white,
                              fillColor: const Color(0xffFF3D3D),
                              backgroundColor: Colors.grey[200],
                              strokeWidth: 10.0,
                              strokeCap: StrokeCap.round,
                              textFormat: CountdownTextFormat.S,
                              isReverse: false,
                              isReverseAnimation: false,
                              isTimerTextShown: true,
                              autoStart: true,
                              onStart: () {
                                print('Countdown Started');
                              },
                              onComplete: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const BottomsNaviScreen(index: 0),
                                    ),
                                    (route) => false);
                              },
                            ),
                            Positioned(
                              top: (205 - 96) / 2,
                              left: 0,
                              right: 0,
                              child: Image.asset(
                                widget.apptype == 'cab'
                                    ? 'assets/images/ridenew.png'
                                    : widget.apptype == 'pickupanddrop'
                                        ? 'assets/images/pickdropnew.png'
                                        : "assets/images/box8 [Converted] 1.png",
                                width: 158,
                                height: 96,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          ConvertText.getTitle(
                              "ORDER ID : ${state.newOrderDetailsModel.data.orderId}"),
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      state.newOrderDetailsModel.data.scheduleType == 'yes'
                          ? Center(
                              child: SvgPicture.asset(
                                'assets/images/stopwatch.svg',
                                height: 25,
                                width: 25,
                              ),
                            )
                          : const SizedBox(
                              height: 0,
                              width: 0,
                            ),
                      state.newOrderDetailsModel.data.scheduleType == 'yes'
                          ? const SizedBox(
                              height: 5,
                              width: 0,
                            )
                          : const SizedBox(
                              height: 0,
                              width: 0,
                            ),
                      state.newOrderDetailsModel.data.scheduleType == 'yes'
                          ? Center(
                              child: Text(
                                ConvertText.getTitle(
                                    'Schedule Order Date:${state.newOrderDetailsModel.data.pickupDate} Time:${state.newOrderDetailsModel.data.pickupTime}'),
                                style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          : const SizedBox(
                              height: 0,
                              width: 0,
                            ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
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
                                      "${ConvertText.getTitle("Expected Earning")}:",
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "₹ ${state.newOrderDetailsModel.data.earnings.toString()}",
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
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            '${state.newOrderDetailsModel.data.pickupDistance.toString()} Kms',
                                            style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
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
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            '${state.newOrderDetailsModel.data.droppingDistance.toString()} Kms',
                                            style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: ColorsData.themeColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
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
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 3.0,
                                                          horizontal: 5.0),
                                                      child: Text(
                                                        (entry.key + 1)
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }).toList(), // Ensure to call toList() here
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
                                            colorFilter: const ColorFilter.mode(
                                                Colors.red, BlendMode.srcIn),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
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
                                              maxLines: 3,
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
                                                      .droppingLocations[index]
                                                      .address,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.manrope(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              if (widget.apptype == 'pickupanddrop')
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [
                                      Image.asset('assets/images/goodstype.png',
                                          width: 20, height: 20),
                                      10.pw,
                                      Column(
                                        children: [
                                          const CommonProximaNovaTextWidget(
                                            text: 'Type of Goods:',
                                            fontSize: 12,
                                          ),
                                          CommonProximaNovaTextWidget(
                                            text: state.newOrderDetailsModel
                                                .data.goodsType,
                                            fontSize: 12,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: ColorsData.themeColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Note: ",
                                style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                state.newOrderDetailsModel.data.note,
                                style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 65,
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: SwipeButtonWidget(
                    acceptPoitTransition: 0.7,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
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
                          ConvertText.getTitle('ACCEPT THE TRIP'),
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
                      print(
                          "its working ${state.newOrderDetailsModel.data.id}");
                      context.read<NewOrderBloc>().add(AcceptingOrderCabEvent(
                          refId: state.newOrderDetailsModel.data.id.toString(),
                          apptype: widget.apptype!));
                      return true;
                    },
                    onHorizontalDragleft: (e) async {
                      return false;
                    }),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
      },
    );
  }
}
