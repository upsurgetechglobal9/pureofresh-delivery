import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/screens/commocoloo.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/new_order/screens/cash_collect_screen.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/new_order/screens/verify_otp.dart';
import 'package:pure_o_fresh_rider_app/utility/common_text.dart';
import 'package:pure_o_fresh_rider_app/utility/text_form_field.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../commons/ConvertText.dart';
import '../../../commons/shared_prefs.dart';
import '../../../utility/colors_data.dart';
import '../logic/new_order_bloc.dart';
import '../widgets/audio_player_widget.dart';
import '../widgets/dashed_painter.dart';
import '../widgets/swipe_no_back_widegt.dart';
import 'trip_summary_screen.dart';

class OredreReviewScrren extends StatefulWidget {
  final String? refId;
  final String? apptype;
  const OredreReviewScrren({super.key, this.refId, this.apptype});

  @override
  State<OredreReviewScrren> createState() => _OredreReviewScrrenState();
}

class _OredreReviewScrrenState extends State<OredreReviewScrren> {
  final AudioManager audioManager = AudioManager();
  final otpFinalKey = GlobalKey<FormState>();
  final alternatKey = GlobalKey<FormState>();

  TextEditingController exchange1controller = TextEditingController();
  TextEditingController exchange2controller = TextEditingController();
  TextEditingController exchange3controller = TextEditingController();
  TextEditingController otpCodeController = TextEditingController();
  TextEditingController cashController = TextEditingController();
  TextEditingController reEnterCashController = TextEditingController();
  StreamController<ErrorAnimationType>? errortypeotpController;
  double duration = 0;

  var currentText;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewOrderBloc>().add(NewOrderDetailsEvent(
          //  Constants.prefs!.getString("orderId")!
          refId: Constants.prefs!.getString("orderId")!,
          apptype: widget.apptype));
      // NewOrderDetailsEvent(refId: "2023082190740"));
    });
    super.initState();
  }

  @override
  void dispose() {
    audioManager.dispose();
    super.dispose();
  }

// void launchMapByAddress(String address) async {
//   // Use geocoding service to convert address to coordinates
//   List<Coords> coords = await MapLauncher.geocodeQuery(address);

//   if (coords.isNotEmpty) {
//     Coords coord = coords.first;

//     // Show marker on map
//     MapLauncher.showMarker(
//       mapType: MapType.google, // Use Google Maps
//       coords: coord,
//       title: address,
//       description: "Delivery Point",
//     );
//   } else {
//     print('Address not found');
//   }
// }

  Future<void> _makePhoneCall(String phoneNumber) async {
    print("phoneNumber $phoneNumber");
    phoneNumber = phoneNumber.replaceAll(" ", "");

    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewOrderBloc, NewOrderState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is ReachedPickupSuccessState) {
          print("object  AAA SSS ${state.refId}");
          context.read<NewOrderBloc>().add(NewOrderDetailsEvent(
              refId: Constants.prefs!.getString("orderId")!));
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => NearToPickUp(
          //         type: '',
          //         refId: Constants.prefs!.getString("orderId")!,
          //       ),
          //     ));
        }
        if (state is ReachedDeliverySuccessState) {
          context.read<NewOrderBloc>().add(NewOrderDetailsEvent(
              refId: Constants.prefs!.getString("orderId")!));
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => NearToPickUp(
          //         type: '',
          //         refId: Constants.prefs!.getString("orderId")!,
          //       ),
          //     ));
        }

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
        if (state is PickUpRestrantFailedState) {
          context.read<NewOrderBloc>().add(NewOrderDetailsEvent(
              refId: Constants.prefs!.getString("orderId")!));
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => OredreReviewScrren(
          //         refId: Constants.prefs!.getString("orderId")!,
          //       ),
          //     ));
        }
        if (state is PickUpRestrantcompleteFailedState) {
          context.read<NewOrderBloc>().add(NewOrderDetailsEvent(
              refId: Constants.prefs!.getString("orderId")!));
          // Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => const BottomsNaviScreen(
          //               index: 0,
          //             )),
          //     (route) => false);
        }
        if (state is CompletingOrdeCabFailState) {
          Fluttertoast.showToast(
              msg: "Dropping Location not updated",
              backgroundColor: Colors.red);
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OredreReviewScrren(
                  refId: Constants.prefs!.getString("orderId")!,
                  apptype: widget.apptype,
                ),
              ));
        }
        if (state is CompletingStopCabSuccessState) {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OredreReviewScrren(
                  refId: Constants.prefs!.getString("orderId")!,
                  apptype: widget.apptype,
                ),
              ));
        }
        if (state is CompletingStopCabFailState) {
          Fluttertoast.showToast(
              msg: "Please start your ride", backgroundColor: Colors.red);
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OredreReviewScrren(
                  refId: Constants.prefs!.getString("orderId")!,
                  apptype: widget.apptype,
                ),
              ));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xfff1f0f5),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleSpacing: 4,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black,
                  size: 16,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              ConvertText.getTitle('Order Review'),
              style: GoogleFonts.manrope(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: BlocBuilder<NewOrderBloc, NewOrderState>(
              builder: (context, state) {
                if (state is NewOrderDetailsSuccessState) {
                  cashController.text =
                      state.newOrderDetailsModel.data.grandTotal;
                  return ListView(
                    physics: const BouncingScrollPhysics(),
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Order ID: ${state.newOrderDetailsModel.data.refId}",
                        style: GoogleFonts.manrope(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
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
                                    length: 80,
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.60,
                                        child: Text(
                                          state.newOrderDetailsModel.data
                                              .restaurantDetails.restaurantName,
                                          style: GoogleFonts.manrope(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          MapsLauncher.launchQuery(state
                                              .newOrderDetailsModel
                                              .data
                                              .restaurantDetails
                                              .displayAddress);
                                        },
                                        child: CircleAvatar(
                                            radius: 14,
                                            backgroundColor:
                                                const Color(0xffF29D00),
                                            child: Image.asset(
                                                "assets/images/navigation.png",
                                                height: 12,
                                                width: 12)),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          await _makePhoneCall(state
                                              .newOrderDetailsModel
                                              .data
                                              .restaurantDetails
                                              .mobile);
                                        },
                                        child: const CircleAvatar(
                                          radius: 14,
                                          backgroundColor: Color(0xff098B09),
                                          child: Icon(
                                            Icons.phone_in_talk_outlined,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                      state.newOrderDetailsModel.data
                                          .restaurantDetails.displayAddress,
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                      )),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.60,
                                        child: Text(
                                          ConvertText.getTitle(
                                            widget.apptype == 'cab'
                                                ? "DROP LOCATION"
                                                : widget.apptype ==
                                                        'pickupanddrop'
                                                    ? "DELIVER TO"
                                                    : "DELIVER TO",
                                          ),
                                          style: GoogleFonts.manrope(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: state.newOrderDetailsModel
                                                          .data.serviceStatus ==
                                                      'Ready To Pickup'
                                                  ? const Color(0xFFfe8000)
                                                  : state.newOrderDetailsModel.data
                                                              .serviceStatus ==
                                                          'Out For Delivery'
                                                      ? const Color(0xFFc245bd)
                                                      : ColorsData.themeColor),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          MapsLauncher.launchQuery(state
                                              .newOrderDetailsModel
                                              .data
                                              .customerAddress);
                                        },
                                        child: CircleAvatar(
                                            radius: 14,
                                            backgroundColor:
                                                const Color(0xffF29D00),
                                            child: Image.asset(
                                                "assets/images/navigation.png",
                                                height: 12,
                                                width: 12)),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          await _makePhoneCall(state
                                              .newOrderDetailsModel
                                              .data
                                              .customerDetails
                                              .mobile);
                                        },
                                        child: const CircleAvatar(
                                          radius: 14,
                                          backgroundColor: Color(0xff098B09),
                                          child: Icon(
                                            Icons.phone_in_talk_outlined,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      )
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
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
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.text_snippet_outlined),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  state.newOrderDetailsModel.data.paymentMode,
                                  style: GoogleFonts.manrope(
                                    color: Colors.black,
                                    // fontWeight: FontWeight.w00,
                                    fontSize: 16,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.text_snippet_outlined,
                                  color: Colors.transparent,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  state.newOrderDetailsModel.data.serviceDate,
                                  style: GoogleFonts.manrope(
                                    color: Colors.black54,
                                    // fontWeight: FontWeight.w00,
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      state.newOrderDetailsModel.data.specialInstructions == ''
                          ? const SizedBox.shrink()
                          : Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ConvertText.getTitle(
                                        'Special Delivery Instructions'),
                                    style: GoogleFonts.manrope(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  if (state.newOrderDetailsModel.data
                                      .specialInstructions
                                      .contains("Leave at door"))
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/door.svg",
                                          width: 18,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          ConvertText.getTitle('Leave at Door'),
                                          style: GoogleFonts.manrope(
                                            // fontWeight: FontWeight.w00,
                                            fontSize: 13,
                                          ),
                                        )
                                      ],
                                    ),
                                  if (state.newOrderDetailsModel.data
                                      .specialInstructions
                                      .contains("Avoid Call"))
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6.0),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/images/avoid_call.svg",
                                            width: 18,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            ConvertText.getTitle("Avoid Call"),
                                            style: GoogleFonts.manrope(
                                              // fontWeight: FontWeight.w00,
                                              fontSize: 13,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  if (state.newOrderDetailsModel.data
                                      .specialInstructions
                                      .contains("Ring No Bell"))
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/no_bell.svg",
                                          width: 18,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          ConvertText.getTitle("Ring No Bell"),
                                          style: GoogleFonts.manrope(
                                            // fontWeight: FontWeight.w00,
                                            fontSize: 13,
                                          ),
                                        )
                                      ],
                                    ),
                                  if (state.newOrderDetailsModel.data
                                      .specialInstructions
                                      .contains("Beware of Dog"))
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/images/beware_dog.svg",
                                            width: 20,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            ConvertText.getTitle(
                                                "Beware of Dog"),
                                            style: GoogleFonts.manrope(
                                              // fontWeight: FontWeight.w00,
                                              fontSize: 13,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  // (state.newOrderDetailsModel.data
                                  //             .specialInstructions)
                                  //         .contains("Leave at door")
                                  //     ? Row(
                                  //         children: [
                                  //           const Icon(
                                  //             Icons.door_back_door,
                                  //             color: Colors.black54,
                                  //             size: 18,
                                  //           ),
                                  //           Text(
                                  //             ConvertText.getTitle(
                                  //                 'Leave at door'),
                                  //             style: GoogleFonts.manrope(
                                  //               color: Colors.black54,
                                  //               // fontWeight: FontWeight.w00,
                                  //               fontSize: 12,
                                  //             ),
                                  //           )
                                  //         ],
                                  //       )
                                  //     : state.newOrderDetailsModel.data
                                  //             .specialInstructions
                                  //             .contains('Avoid Call')
                                  //         ? Padding(
                                  //             padding:
                                  //                 const EdgeInsets.symmetric(
                                  //                     vertical: 4.0),
                                  //             child: Row(
                                  //               children: [
                                  //                 const Icon(
                                  //                   Icons.mobile_off_rounded,
                                  //                   size: 18,
                                  //                   color: Colors.black54,
                                  //                 ),
                                  //                 Text(
                                  //                   ConvertText.getTitle(
                                  //                       "Avoid Call"),
                                  //                   style: GoogleFonts.manrope(
                                  //                     color: Colors.black54,
                                  //                     // fontWeight: FontWeight.w00,
                                  //                     fontSize: 12,
                                  //                   ),
                                  //                 )
                                  //               ],
                                  //             ),
                                  //           )
                                  //         : state.newOrderDetailsModel.data
                                  //                     .specialInstructions ==
                                  //                 'Ring No Bell'
                                  //             ? Row(
                                  //                 children: [
                                  //                   const Icon(
                                  //                     Icons
                                  //                         .notifications_off_outlined,
                                  //                     size: 18,
                                  //                     color: Colors.black54,
                                  //                   ),
                                  //                   Text(
                                  //                     ConvertText.getTitle(
                                  //                         "Ring No Bell"),
                                  //                     style:
                                  //                         GoogleFonts.manrope(
                                  //                       color: Colors.black54,
                                  //                       // fontWeight: FontWeight.w00,
                                  //                       fontSize: 12,
                                  //                     ),
                                  //                   )
                                  //                 ],
                                  //               )
                                  //             : Text(
                                  //                 ConvertText.getTitle(
                                  //                     "${state.newOrderDetailsModel.data.specialInstructions}"),
                                  //                 style: GoogleFonts.manrope(
                                  //                   color: Colors.black54,
                                  //                   // fontWeight: FontWeight.w00,
                                  //                   fontSize: 12,
                                  //                 ),
                                  //               )
                                ],
                              ),
                            ),
                      const SizedBox(
                        height: 4,
                      ),
                      state.newOrderDetailsModel.data.audioInstructions == ''
                          ? const SizedBox.shrink()
                          : AudioPlayerWidget(
                              audioUrl: state
                                  .newOrderDetailsModel.data.audioInstructions,
                            ),
                      // Container(
                      //         padding: EdgeInsets.all(10),
                      //         decoration: BoxDecoration(
                      //             border:
                      //                 Border.all(color: Colors.grey.shade300),
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: Column(
                      //           mainAxisAlignment: MainAxisAlignment.start,
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Text(
                      //               ConvertText.getTitle(
                      //                   "Navigation Instructions"),
                      //               style: GoogleFonts.manrope(
                      //                 color: Colors.black,
                      //                 fontWeight: FontWeight.bold,
                      //                 fontSize: 14,
                      //               ),
                      //             ),
                      //             SizedBox(
                      //               height: 8,
                      //             ),
                      //             Row(
                      //               // mainAxisAlignment: MainAxisAlignment.start,
                      //               children: [
                      //                 IconButton(
                      //                   icon: Icon(audioManager._isPlaying
                      //                       ? Icons.pause
                      //                       : Icons.play_arrow),
                      //                   onPressed: () {
                      //                     print("object");
                      //                     audioManager.playAudio(state
                      //                         .newOrderDetailsModel
                      //                         .data
                      //                         .audioInstructions);
                      //                     setState(
                      //                         () {}); // Update the UI to change the icon
                      //                   },
                      //                   iconSize: 34,
                      //                   color: ColorsData.themeColor,
                      //                 ),
                      //                 // Icon(
                      //                 //   Icons.play_arrow,
                      //                 //   size: 34,
                      //                 //   color: ColorsData.themeColor,
                      //                 // ),
                      //                 Expanded(
                      //                   child: SliderTheme(
                      //                     data: SliderThemeData(
                      //                         // overlayShape: SliderComponentShape.noOverlay,
                      //                         thumbColor: ColorsData.themeColor,
                      //                         overlayShape:
                      //                             RoundSliderOverlayShape(
                      //                                 overlayRadius: 10.0),
                      //                         thumbShape: RoundSliderThumbShape(
                      //                             enabledThumbRadius: 3)),
                      //                     child: Padding(
                      //                       padding: const EdgeInsets.all(0),
                      //                       child: Slider(
                      //                           max: 10,
                      //                           value: duration,
                      //                           inactiveColor:
                      //                               Colors.grey.shade300,
                      //                           onChanged: (v) {
                      //                             print("jhg$v");
                      //                             // final player = AudioPlayer();
                      //                             // player.play(UrlSource(state
                      //                             //     .newOrderDetailsModel
                      //                             //     .data
                      //                             //     .audioInstructions));
                      //                             setState(() {
                      //                               duration = v;
                      //                             });
                      //                           }),
                      //                     ),
                      //                   ),
                      //                 ),
                      //                 // Text(
                      //                 //   "00:15",
                      //                 //   // "${duration.round()}",
                      //                 //   style: GoogleFonts.manrope(
                      //                 //     color: Colors.black54,
                      //                 //     // fontWeight: FontWeight.w00,
                      //                 //     fontSize: 12,
                      //                 //   ),
                      //                 // )
                      //               ],
                      //             ),
                      //           ],
                      //         ),
                      //       ),

                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ConvertText.getTitle("Order Details"),
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    "${ConvertText.getTitle("Total Bill")}: ₹ ${state.newOrderDetailsModel.data.grandTotal}",
                                    style: GoogleFonts.manrope(
                                        color: ColorsData.themeColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            ListView.builder(
                              itemCount: state
                                  .newOrderDetailsModel.data.cartItems.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Text(
                                  "${state.newOrderDetailsModel.data.cartItems[index].restaurantFoodItemsName}  X  ${state.newOrderDetailsModel.data.cartItems[index].qty}",
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      state.newOrderDetailsModel.data.serviceStatus ==
                              'Reached Delivery'
                          ? BlocBuilder<NewOrderBloc, NewOrderState>(
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
                                        alignment: const Alignment(0, 0),
                                        child: Text(
                                          ConvertText.getTitle(
                                              'COMPLETE ORDER'),
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
                                      // collectCash();
                                      if (state
                                          is NewOrderDetailsSuccessState) {
                                        print(state.newOrderDetailsModel.data
                                            .paymentMode);
                                        if (state.newOrderDetailsModel.data
                                                .paymentMode ==
                                            "Pay On Delivery") {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const CashCollectedScreen(),
                                              ));
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const NewOrderOtpVerify(),
                                              ));
                                          /*context
                                              .read<NewOrderBloc>()
                                              .add(const CompleteOrderEvent());*/
                                        }
                                      }

                                      return true;
                                    },
                                    onHorizontalDragleft: (e) async {
                                      return false;
                                    });
                                // Swipperbuttonwidget(
                                //     onSwipeFun: () {
                                //       collectCash();
                                //     },
                                //     buttonTitle: "COLLECT COD");
                              },
                            )
                          : state.newOrderDetailsModel.data.serviceStatus ==
                                  'Out For Delivery'
                              ? BlocBuilder<NewOrderBloc, NewOrderState>(
                                  builder: (context, state) {
                                    return SwipeButtonWidget(
                                        acceptPoitTransition: 0.7,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        padding: const EdgeInsets.all(6),
                                        boxShadow: const [
                                          BoxShadow(
                                            blurRadius: 4,
                                            color: Color.fromRGBO(
                                                197, 197, 197, 0.25),
                                            spreadRadius: 1.5,
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(30),
                                        colorBeforeSwipe: ColorsData.themeColor,
                                        colorAfterSwiped: ColorsData.themeColor,
                                        height: 50,
                                        childBeforeSwipe: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
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
                                              ConvertText.getTitle(
                                                  'REACHED DELIVERY LOCATION'),
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
                                              ReachedDeliveryLocationEvent(
                                                  refId:
                                                      widget.refId.toString()));

                                          return true;
                                        },
                                        onHorizontalDragleft: (e) async {
                                          return false;
                                        });

                                    // Swipperbuttonwidget(
                                    //     onSwipeFun: () {
                                    //       // collectCash();
                                    //       context.read<NewOrderBloc>().add(
                                    //           const ReachedDeliveryLocationEvent(
                                    //               refId: "2023082190740"));
                                    //     },
                                    //     buttonTitle:
                                    //         "REACHED DELIVERY LOCATION");
                                  },
                                )
                              : BlocBuilder<NewOrderBloc, NewOrderState>(
                                  builder: (context, state) {
                                    return SwipeButtonWidget(
                                        acceptPoitTransition: 0.7,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        padding: const EdgeInsets.all(6),
                                        boxShadow: const [
                                          BoxShadow(
                                            blurRadius: 4,
                                            color: Color.fromRGBO(
                                                197, 197, 197, 0.25),
                                            spreadRadius: 1.5,
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(30),
                                        colorBeforeSwipe: ColorsData.themeColor,
                                        colorAfterSwiped: ColorsData.themeColor,
                                        height: 50,
                                        childBeforeSwipe: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
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
                                              ConvertText.getTitle(
                                                  'YES. CONFIRM ORDER'),
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
                                              PickupfromRestrantLocationAndOutforDeliveryEvent(
                                                  refId:
                                                      widget.refId.toString(),
                                                  exchange1: '',
                                                  exchange2: '',
                                                  exchange3: ''));

                                          return true;
                                        },
                                        onHorizontalDragleft: (e) async {
                                          return false;
                                        });

                                    // Swipperbuttonwidget(
                                    //     onSwipeFun: () {
                                    //       context.read<NewOrderBloc>().add(
                                    //           const PickupfromRestrantLocationEvent(
                                    //               refId: "2023082190740"));
                                    //     },
                                    //     buttonTitle: "YES. CONFIRM ORDER");
                                  },
                                ),
                      // state.newOrderDetailsModel.data.serviceStatus ==
                      //         "Ready To Pickup"
                      //     ? Row(
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Text(
                      //             ConvertText.getTitle(
                      //                 "Alternate the Food Items"),
                      //             style: GoogleFonts.manrope(
                      //               fontSize: 13,
                      //             ),
                      //           ),
                      //           TextButton(
                      //             onPressed: () {
                      //               alternateFood();
                      //             },
                      //             child: Text(
                      //               ConvertText.getTitle("Click Here!"),
                      //               style: GoogleFonts.manrope(
                      //                   color: ColorsData.themeColor,
                      //                   fontSize: 14,
                      //                   fontWeight: FontWeight.bold),
                      //             ),
                      //           )
                      //         ],
                      //       )
                      //     : const SizedBox.shrink(),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  );
                }

                if (state is NewOrderDetailsCabSuccessState) {
                  cashController.text =
                      state.newOrderDetailsModel.data.grandTotal;
                  return ListView(
                    physics: const BouncingScrollPhysics(),
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Order ID: ${state.newOrderDetailsModel.data.orderId}",
                        style: GoogleFonts.manrope(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/images/Pickup.png",
                                      height: 20,
                                    ),
                                    Column(
                                      children: [
                                        ...state.newOrderDetailsModel.data
                                            .droppingLocations
                                            .asMap()
                                            .entries
                                            .take(state
                                                .newOrderDetailsModel
                                                .data
                                                .droppingLocations
                                                .length) // Take all but the last item
                                            .map((entry) {
                                          return Column(
                                            children: [
                                              SizedBox(
                                                height: (widget.apptype ==
                                                        'pickupanddrop')
                                                    ? (entry.key + 1) !=
                                                            state
                                                                .newOrderDetailsModel
                                                                .data
                                                                .droppingLocations
                                                                .length
                                                        ? 100
                                                        : state
                                                                    .newOrderDetailsModel
                                                                    .data
                                                                    .droppingLocations
                                                                    .length >
                                                                1
                                                            ? 100
                                                            : 70
                                                    : (entry.key + 1) !=
                                                            state
                                                                .newOrderDetailsModel
                                                                .data
                                                                .droppingLocations
                                                                .length
                                                        ? 80
                                                        : state
                                                                    .newOrderDetailsModel
                                                                    .data
                                                                    .droppingLocations
                                                                    .length >
                                                                1
                                                            ? 70
                                                            : 50,
                                                width: 1,
                                                child: CustomPaint(
                                                  size: const Size(
                                                      1, double.infinity),
                                                  painter:
                                                      DashedLineVerticalPainter(),
                                                ),
                                              ),
                                              if ((entry.key + 1) !=
                                                  state
                                                      .newOrderDetailsModel
                                                      .data
                                                      .droppingLocations
                                                      .length)
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.black),
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
                                        }), // Ensure to call toList() here
                                      ],
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
                                const SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: const Color(0xFF45B3C2),
                                            ),
                                            child: Text(
                                              ConvertText.getTitle(
                                                  "PICKUP LOCATION"),
                                              style: GoogleFonts.manrope(
                                                  fontSize: 10,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    if (widget.apptype == 'pickupanddrop')
                                      Text(
                                        state.newOrderDetailsModel.data
                                            .customerName,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Text(
                                          state.newOrderDetailsModel.data
                                              .pickupFrom,
                                          style: GoogleFonts.manrope(
                                            fontSize: 12,
                                          )),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
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
                                                widget.apptype == 'cab'
                                                    ? "DROP LOCATION"
                                                    : widget.apptype ==
                                                            'pickupanddrop'
                                                        ? "DELIVER TO"
                                                        : "DELIVER TO",
                                              ),
                                              style: GoogleFonts.manrope(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: state.newOrderDetailsModel
                                                              .data.status ==
                                                          'Rider Reached to your location'
                                                      ? const Color(0xFFfe8000)
                                                      : state.newOrderDetailsModel
                                                                  .data.status ==
                                                              'Started'
                                                          ? const Color(
                                                              0xFFc245bd)
                                                          : ColorsData
                                                              .themeColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: List.generate(
                                          state
                                              .newOrderDetailsModel
                                              .data
                                              .droppingLocations
                                              .length, (index) {
                                        return Column(
                                          crossAxisAlignment: state
                                                      .newOrderDetailsModel
                                                      .data
                                                      .droppingLocations[index]
                                                      .status ==
                                                  false
                                              ? CrossAxisAlignment.center
                                              : CrossAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  if (widget.apptype ==
                                                      'pickupanddrop')
                                                    Text(
                                                      state
                                                          .newOrderDetailsModel
                                                          .data
                                                          .droppingLocations[
                                                              index]
                                                          .personName!,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          height: 1.5),
                                                    ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        SizedBox(
                                                          width: (widget.apptype ==
                                                                  'pickupanddrop')
                                                              ? MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.6
                                                              : MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.7,
                                                          child: state
                                                                      .newOrderDetailsModel
                                                                      .data
                                                                      .droppingLocations[
                                                                          index]
                                                                      .address ==
                                                                  ''
                                                              ? Text(
                                                                  'N/A',
                                                                  style: GoogleFonts.manrope(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                )
                                                              : Text(
                                                                  state
                                                                      .newOrderDetailsModel
                                                                      .data
                                                                      .droppingLocations[
                                                                          index]
                                                                      .address,
                                                                  maxLines: 3,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: GoogleFonts.manrope(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            InkWell(
                                                              onTap: () async {
                                                                MapsLauncher.launchQuery(state
                                                                    .newOrderDetailsModel
                                                                    .data
                                                                    .droppingLocations[
                                                                        index]
                                                                    .address);
                                                              },
                                                              child: CircleAvatar(
                                                                  radius: 14,
                                                                  backgroundColor:
                                                                      const Color(
                                                                          0xffF29D00),
                                                                  child: Image.asset(
                                                                      "assets/images/navigation.png",
                                                                      height:
                                                                          12,
                                                                      width:
                                                                          12)),
                                                            ),
                                                            if (widget
                                                                    .apptype ==
                                                                'pickupanddrop')
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8.0),
                                                                child: InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    await _makePhoneCall(state
                                                                        .newOrderDetailsModel
                                                                        .data
                                                                        .droppingLocations[
                                                                            index]
                                                                        .personNumber!);
                                                                  },
                                                                  child:
                                                                      const CircleAvatar(
                                                                    radius: 14,
                                                                    backgroundColor:
                                                                        Color(
                                                                            0xff098B09),
                                                                    child: Icon(
                                                                      Icons
                                                                          .phone_in_talk_outlined,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 14,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (state.newOrderDetailsModel.data
                                                    .droppingLocations.length >
                                                1)
                                              (state
                                                          .newOrderDetailsModel
                                                          .data
                                                          .droppingLocations[
                                                              index]
                                                          .status ==
                                                      false)
                                                  ? (index > 0 &&
                                                          state
                                                                  .newOrderDetailsModel
                                                                  .data
                                                                  .droppingLocations[
                                                                      index - 1]
                                                                  .status ==
                                                              true)
                                                      ? SwipeButtonWidget(
                                                          width: 250,
                                                          acceptPoitTransition:
                                                              0.7,
                                                          padding: const EdgeInsets.symmetric(
                                                              horizontal: 6,
                                                              vertical: 6),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              blurRadius: 4,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      197,
                                                                      197,
                                                                      197,
                                                                      0.25),
                                                              spreadRadius: 1.5,
                                                            ),
                                                          ],
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  30),
                                                          colorBeforeSwipe:
                                                              ColorsData
                                                                  .themeColor,
                                                          colorAfterSwiped:
                                                              ColorsData
                                                                  .themeColor,
                                                          height: 45,
                                                          childBeforeSwipe:
                                                              Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: ColorsData
                                                                  .themeColor,
                                                            ),
                                                            height:
                                                                double.infinity,
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              child: Icon(
                                                                Icons
                                                                    .arrow_forward,
                                                                color: ColorsData
                                                                    .themeColor,
                                                              ),
                                                            ),
                                                          ),
                                                          leftChildren: [
                                                            Align(
                                                              alignment:
                                                                  const Alignment(
                                                                      0, 0),
                                                              child: Text(
                                                                ConvertText
                                                                    .getTitle(
                                                                        'Reached'),
                                                                // 'COLLECT COD',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            )
                                                          ],
                                                          childAfterSwiped:
                                                              const SizedBox(
                                                            height: 24,
                                                            width: 24,
                                                            child:
                                                                CircularProgressIndicator(
                                                              strokeWidth: 3,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          onHorizontalDragUpdate:
                                                              (e) {},
                                                          onHorizontalDragRight:
                                                              (e) async {
                                                            if (index != 0) {
                                                              if (state
                                                                      .newOrderDetailsModel
                                                                      .data
                                                                      .droppingLocations[
                                                                          index -
                                                                              1]
                                                                      .status ==
                                                                  true) {
                                                                context.read<NewOrderBloc>().add(CompleteStopCabEvent(
                                                                    refId: state
                                                                        .newOrderDetailsModel
                                                                        .data
                                                                        .orderId
                                                                        .toString(),
                                                                    apptype: widget
                                                                        .apptype!,
                                                                    locationId: state
                                                                        .newOrderDetailsModel
                                                                        .data
                                                                        .droppingLocations[
                                                                            index]
                                                                        .id));
                                                                return true;
                                                              } else {
                                                                Fluttertoast.showToast(
                                                                    msg:
                                                                        "Please complete previous stop first",
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red);
                                                                return false;
                                                              }
                                                            } else {
                                                              context.read<NewOrderBloc>().add(CompleteStopCabEvent(
                                                                  refId: state
                                                                      .newOrderDetailsModel
                                                                      .data
                                                                      .orderId
                                                                      .toString(),
                                                                  apptype: widget
                                                                      .apptype!,
                                                                  locationId: state
                                                                      .newOrderDetailsModel
                                                                      .data
                                                                      .droppingLocations[
                                                                          index]
                                                                      .id));
                                                              return true;
                                                            }
                                                          },
                                                          onHorizontalDragleft:
                                                              (e) async {
                                                            return false;
                                                          })
                                                      : index == 0
                                                          ? SwipeButtonWidget(
                                                              width: 250,
                                                              acceptPoitTransition:
                                                                  0.7,
                                                              padding: const EdgeInsets.symmetric(
                                                                  horizontal: 6,
                                                                  vertical: 6),
                                                              boxShadow: const [
                                                                BoxShadow(
                                                                  blurRadius: 4,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          197,
                                                                          197,
                                                                          197,
                                                                          0.25),
                                                                  spreadRadius:
                                                                      1.5,
                                                                ),
                                                              ],
                                                              borderRadius: BorderRadius.circular(30),
                                                              colorBeforeSwipe: ColorsData.themeColor,
                                                              colorAfterSwiped: ColorsData.themeColor,
                                                              height: 45,
                                                              childBeforeSwipe: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color: ColorsData
                                                                      .themeColor,
                                                                ),
                                                                height: double
                                                                    .infinity,
                                                                child:
                                                                    CircleAvatar(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  child: Icon(
                                                                    Icons
                                                                        .arrow_forward,
                                                                    color: ColorsData
                                                                        .themeColor,
                                                                  ),
                                                                ),
                                                              ),
                                                              leftChildren: [
                                                                Align(
                                                                  alignment:
                                                                      const Alignment(
                                                                          0, 0),
                                                                  child: Text(
                                                                    ConvertText
                                                                        .getTitle(
                                                                            'Reached'),
                                                                    // 'COLLECT COD',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                )
                                                              ],
                                                              childAfterSwiped: const SizedBox(
                                                                height: 24,
                                                                width: 24,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  strokeWidth:
                                                                      3,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              onHorizontalDragUpdate: (e) {},
                                                              onHorizontalDragRight: (e) async {
                                                                if (index !=
                                                                    0) {
                                                                  if (state
                                                                          .newOrderDetailsModel
                                                                          .data
                                                                          .droppingLocations[index -
                                                                              1]
                                                                          .status ==
                                                                      true) {
                                                                    context.read<NewOrderBloc>().add(CompleteStopCabEvent(
                                                                        refId: state
                                                                            .newOrderDetailsModel
                                                                            .data
                                                                            .orderId
                                                                            .toString(),
                                                                        apptype:
                                                                            widget
                                                                                .apptype!,
                                                                        locationId: state
                                                                            .newOrderDetailsModel
                                                                            .data
                                                                            .droppingLocations[index]
                                                                            .id));
                                                                    return true;
                                                                  } else {
                                                                    Fluttertoast.showToast(
                                                                        msg:
                                                                            "Please complete previous stop first",
                                                                        backgroundColor:
                                                                            Colors.red);
                                                                    return false;
                                                                  }
                                                                } else {
                                                                  context.read<NewOrderBloc>().add(CompleteStopCabEvent(
                                                                      refId: state
                                                                          .newOrderDetailsModel
                                                                          .data
                                                                          .orderId
                                                                          .toString(),
                                                                      apptype:
                                                                          widget
                                                                              .apptype!,
                                                                      locationId: state
                                                                          .newOrderDetailsModel
                                                                          .data
                                                                          .droppingLocations[
                                                                              index]
                                                                          .id));
                                                                  return true;
                                                                }
                                                              },
                                                              onHorizontalDragleft: (e) async {
                                                                return false;
                                                              })
                                                          : const SizedBox(height: 40)
                                                  : const SizedBox(
                                                      height: 45,
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text("Reached",
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                    ),
                                            10.ph,
                                          ],
                                        );
                                      }),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            if (widget.apptype == 'pickupanddrop')
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          text: state.newOrderDetailsModel.data
                                              .goodsType,
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
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.text_snippet_outlined),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Ordered On",
                                  style: GoogleFonts.manrope(
                                    color: Colors.black,
                                    // fontWeight: FontWeight.w00,
                                    fontSize: 16,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.text_snippet_outlined,
                                  color: Colors.transparent,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                CommonProximaNovaTextWidget(
                                  text: state
                                      .newOrderDetailsModel.data.pickupDate
                                      .toString(),
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      // state.newOrderDetailsModel.data.specialInstructions == ''
                      //     ? const SizedBox.shrink()
                      //     : Container(
                      //         padding: const EdgeInsets.all(10),
                      //         decoration: BoxDecoration(
                      //             color: Colors.white,
                      //             border:
                      //                 Border.all(color: Colors.grey.shade300),
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: Column(
                      //           mainAxisAlignment: MainAxisAlignment.start,
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Text(
                      //               ConvertText.getTitle(
                      //                   'Special Delivery Instructions'),
                      //               style: GoogleFonts.manrope(
                      //                 color: Colors.black,
                      //                 fontWeight: FontWeight.bold,
                      //                 fontSize: 16,
                      //               ),
                      //             ),
                      //             const SizedBox(
                      //               height: 8,
                      //             ),
                      //             if (state.newOrderDetailsModel.data
                      //                 .specialInstructions
                      //                 .contains("Leave at door"))
                      //               Row(
                      //                 children: [
                      //                   SvgPicture.asset(
                      //                     "assets/images/door.svg",
                      //                     width: 18,
                      //                   ),
                      //                   const SizedBox(
                      //                     width: 5,
                      //                   ),
                      //                   Text(
                      //                     ConvertText.getTitle('Leave at Door'),
                      //                     style: GoogleFonts.manrope(
                      //                       // fontWeight: FontWeight.w00,
                      //                       fontSize: 13,
                      //                     ),
                      //                   )
                      //                 ],
                      //               ),
                      //             if (state.newOrderDetailsModel.data
                      //                 .specialInstructions
                      //                 .contains("Avoid Call"))
                      //               Padding(
                      //                 padding: const EdgeInsets.symmetric(
                      //                     vertical: 6.0),
                      //                 child: Row(
                      //                   children: [
                      //                     SvgPicture.asset(
                      //                       "assets/images/avoid_call.svg",
                      //                       width: 18,
                      //                     ),
                      //                     const SizedBox(
                      //                       width: 5,
                      //                     ),
                      //                     Text(
                      //                       ConvertText.getTitle("Avoid Call"),
                      //                       style: GoogleFonts.manrope(
                      //                         // fontWeight: FontWeight.w00,
                      //                         fontSize: 13,
                      //                       ),
                      //                     )
                      //                   ],
                      //                 ),
                      //               ),
                      //             if (state.newOrderDetailsModel.data
                      //                 .specialInstructions
                      //                 .contains("Ring No Bell"))
                      //               Row(
                      //                 children: [
                      //                   SvgPicture.asset(
                      //                     "assets/images/no_bell.svg",
                      //                     width: 18,
                      //                   ),
                      //                   const SizedBox(
                      //                     width: 5,
                      //                   ),
                      //                   Text(
                      //                     ConvertText.getTitle("Ring No Bell"),
                      //                     style: GoogleFonts.manrope(
                      //                       // fontWeight: FontWeight.w00,
                      //                       fontSize: 13,
                      //                     ),
                      //                   )
                      //                 ],
                      //               ),
                      //             if (state.newOrderDetailsModel.data
                      //                 .specialInstructions
                      //                 .contains("Beware of Dog"))
                      //               Padding(
                      //                 padding: const EdgeInsets.only(top: 6.0),
                      //                 child: Row(
                      //                   children: [
                      //                     SvgPicture.asset(
                      //                       "assets/images/beware_dog.svg",
                      //                       width: 20,
                      //                     ),
                      //                     const SizedBox(
                      //                       width: 5,
                      //                     ),
                      //                     Text(
                      //                       ConvertText.getTitle(
                      //                           "Beware of Dog"),
                      //                       style: GoogleFonts.manrope(
                      //                         // fontWeight: FontWeight.w00,
                      //                         fontSize: 13,
                      //                       ),
                      //                     )
                      //                   ],
                      //                 ),
                      //               ),
                      //           ],
                      //         ),
                      //       ),

                      const SizedBox(
                        height: 4,
                      ),

                      // Container(
                      //   padding: const EdgeInsets.all(10),
                      //   decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       border: Border.all(color: Colors.grey.shade300),
                      //       borderRadius: BorderRadius.circular(10)),
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text(
                      //             ConvertText.getTitle("Order Details"),
                      //             style: GoogleFonts.manrope(
                      //               fontSize: 14,
                      //               fontWeight: FontWeight.w700,
                      //             ),
                      //           ),
                      //           Padding(
                      //             padding:
                      //                 const EdgeInsets.symmetric(vertical: 4.0),
                      //             child: Text(
                      //               "${ConvertText.getTitle("Total Bill")}: ₹ ${state.newOrderDetailsModel.data.earnings}",
                      //               style: GoogleFonts.manrope(
                      //                   color: ColorsData.themeColor,
                      //                   fontSize: 16,
                      //                   fontWeight: FontWeight.bold),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       const SizedBox(
                      //         height: 6,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 4,
                      // ),

                      if (widget.apptype == 'cab')
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.person),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Customer Details",
                                    style: GoogleFonts.manrope(
                                      color: Colors.black,
                                      // fontWeight: FontWeight.w00,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image(
                                          image: NetworkImage(state
                                              .newOrderDetailsModel.data.image),
                                          height: 23,
                                          width: 23,
                                          fit: BoxFit.cover,
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                            // Here you can return any widget you want to show in case of an error
                                            // For example, a local asset image
                                            return Image.asset(
                                              'assets/images/default.png', // Path to your asset image
                                              height: 23,
                                              width: 23,
                                            );
                                          },
                                        ),
                                      ),
                                      5.pw,
                                      Text(
                                          state.newOrderDetailsModel.data
                                              .customerName,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await _makePhoneCall(state
                                          .newOrderDetailsModel.data.mobile);
                                    },
                                    child: const CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Color(0xff098B09),
                                      child: Icon(
                                        Icons.phone_in_talk_outlined,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              if (state.newOrderDetailsModel.data.forWhom !=
                                  'myself')
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          state.newOrderDetailsModel.data
                                              .someoneName,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600)),
                                      InkWell(
                                        onTap: () async {
                                          await _makePhoneCall(state
                                              .newOrderDetailsModel
                                              .data
                                              .someoneMobile);
                                        },
                                        child: const CircleAvatar(
                                          radius: 12,
                                          backgroundColor: Color(0xff098B09),
                                          child: Icon(
                                            Icons.phone_in_talk_outlined,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),

                      const SizedBox(
                        height: 8,
                      ),
                      state.newOrderDetailsModel.data.status == 'Started'
                          ? BlocBuilder<NewOrderBloc, NewOrderState>(
                              builder: (context, state) {
                                if (state is NewOrderDetailsCabSuccessState) {
                                  return SwipeButtonWidget(
                                      acceptPoitTransition: 0.7,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      padding: const EdgeInsets.all(6),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 4,
                                          color: Color.fromRGBO(
                                              197, 197, 197, 0.25),
                                          spreadRadius: 1.5,
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(30),
                                      colorBeforeSwipe: ColorsData.themeColor,
                                      colorAfterSwiped: ColorsData.themeColor,
                                      height: 50,
                                      childBeforeSwipe: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
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
                                            ConvertText.getTitle(
                                                'TRIP COMPLETED'),
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
                                        // collectCash();

                                        if (double.parse(state
                                                .newOrderDetailsModel
                                                .data
                                                .remainingBalance) >
                                            0) {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CashCollectedScreen(
                                                        apptype:
                                                            widget.apptype),
                                              ));
                                        } else {
                                          context.read<NewOrderBloc>().add(
                                              CompleteOrderCabEvent(
                                                  refId: state
                                                      .newOrderDetailsModel
                                                      .data
                                                      .id
                                                      .toString(),
                                                  apptype: widget.apptype!));
                                        }

                                        return true;
                                      },
                                      onHorizontalDragleft: (e) async {
                                        return false;
                                      });
                                }
                                return const SizedBox(
                                  height: 8,
                                );
                              },
                            )
                          : const SizedBox(
                              height: 8,
                            ),
                    ],
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        );
      },
    );
  }

  void collectCash() {
    showModalBottomSheet<void>(
      isDismissible: false,
      context: context,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          // height: 260,
          child: AnimatedPadding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            duration: const Duration(milliseconds: 150),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 900, minHeight: 150),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Collect Cash from Customer",
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, bottom: 10),
                      child: Column(
                        children: [
                          Form(
                              key: otpFinalKey,
                              child: Column(
                                children: [
                                  DeliveryBoyTextFormField(
                                      readOnly: true,
                                      hint: "Enter amount",
                                      controller: cashController,
                                      isDense: true,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        // FilteringTextInputFormatter.allow(
                                        //     RegExp(r'[0-9\s]')),
                                        FilteringTextInputFormatter.deny(
                                            RegExp(r'^0+')),
                                        // LengthLimitingTextInputFormatter(2)
                                      ],
                                      validator: (text) {
                                        if (text!.isEmpty) {
                                          return "Please enter amount";
                                        }
                                        return null;
                                      }),
                                  DeliveryBoyTextFormField(
                                      controller: reEnterCashController,
                                      isDense: true,
                                      hint: "Re Enter amount",
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        // FilteringTextInputFormatter.allow(
                                        //     RegExp(r'[0-9\s]')),
                                        FilteringTextInputFormatter.deny(
                                            RegExp(r'^0+')),
                                        // LengthLimitingTextInputFormatter(2)
                                      ],
                                      validator: (text) {
                                        if (text!.isEmpty) {
                                          return "Please re-enter amount";
                                        }
                                        // if (reEnterCashController !=
                                        //     cashController) {
                                        //   return "Both are not same!";
                                        // }
                                        return null;
                                      }),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ],
                              )),
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
                              leftChildren: const [
                                Align(
                                  alignment: Alignment(0, 0),
                                  child: Text(
                                    'COLLECT COD',
                                    style: TextStyle(
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
                                final FormState? form =
                                    otpFinalKey.currentState;
                                if (form!.validate()) {
                                  print("form valid");
                                  Navigator.pop(context);
                                  context.read<NewOrderBloc>().add(
                                      CollectingCashEvent(
                                          amount:
                                              cashController.text.toString()));
                                } else {
                                  print("form invalid");
                                }

                                return true;
                              },
                              onHorizontalDragleft: (e) async {
                                return false;
                              })

                          // Swipperbuttonwidget(
                          //     onSwipeFun: () {
                          //       final FormState? form =
                          //           otpFinalKey.currentState;
                          //       if (form!.validate()) {
                          //         print("form valid");
                          //         Navigator.pop(context);
                          //         context.read<NewOrderBloc>().add(
                          //             CollectingCashEvent(
                          //                 amount:
                          //                     cashController.text.toString()));
                          //       } else {
                          //         print("form invalid");
                          //       }
                          //     },
                          //     buttonTitle: "COLLECT COD"),
                        ],
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

  void alternateFood() {
    showModalBottomSheet<void>(
      context: context,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          // height: 260,
          child: AnimatedPadding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            duration: const Duration(milliseconds: 150),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 900, minHeight: 150),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Alternate Food Items",
                              style: GoogleFonts.manrope(
                                fontSize: 16,
                                color: ColorsData.themeColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              "Please Enter Alternate Orders",
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, bottom: 10),
                      child: Column(
                        children: [
                          Form(
                              key: alternatKey,
                              child: Column(
                                children: [
                                  DeliveryBoyTextFormField(
                                    controller: exchange1controller,
                                    isDense: true,
                                    hint: "Exchange Item1",
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
                                    validator: (text) {
                                      if (text!.isEmpty) {
                                        return " exchange items atleast one";
                                      }
                                      return null;
                                    },
                                  ),
                                  DeliveryBoyTextFormField(
                                    controller: exchange2controller,
                                    isDense: true,
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
                                    hint: "Exchange Item2",
                                  ),
                                  DeliveryBoyTextFormField(
                                    controller: exchange3controller,
                                    isDense: true,
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
                                    hint: "Exchange Item3",
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ],
                              )),

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
                              leftChildren: const [
                                Align(
                                  alignment: Alignment(0, 0),
                                  child: Text(
                                    'Yes, Confirm Order',
                                    style: TextStyle(
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
                                final FormState? form =
                                    alternatKey.currentState;
                                if (form!.validate()) {
                                  // Navigator.pop(context);

                                  context.read<NewOrderBloc>().add(
                                      PickupfromRestrantLocationAndOutforDeliveryEvent(
                                          refId: widget.refId.toString(),
                                          exchange1: exchange1controller.text
                                              .toString(),
                                          exchange2: exchange2controller.text
                                              .toString(),
                                          exchange3: exchange3controller.text
                                              .toString()));
                                } else {
                                  print("form invalid");
                                  return false;
                                }
                                return true;
                              },
                              onHorizontalDragleft: (e) async {
                                return false;
                              })

                          // Swipperbuttonwidget(
                          //     onSwipeFun: () {
                          //       Navigator.pop(context);
                          //       submitOTP();
                          //       setState(() {
                          //         // buttonTitle = "Order Accepted";
                          //       });
                          //       // Navigator.push(
                          //       //     context,
                          //       //     MaterialPageRoute(
                          //       //       builder: (context) => NearToPickUp(
                          //       //         type: 'submitOTP',
                          //       //       ),
                          //       //     ));
                          //     },
                          //     buttonTitle: "Yes, Confirm Order"),
                        ],
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

  // void submitOTP() {
  //   showModalBottomSheet<void>(
  //     isDismissible: false,
  //     context: context,
  //     enableDrag: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(20),
  //         topRight: Radius.circular(20),
  //       ),
  //     ),
  //     builder: (BuildContext context) {
  //       return SizedBox(
  //         // height: 260,
  //         child: AnimatedPadding(
  //           padding: EdgeInsets.only(
  //               bottom: MediaQuery.of(context).viewInsets.bottom),
  //           duration: const Duration(milliseconds: 150),
  //           child: Container(
  //             constraints: const BoxConstraints(maxHeight: 900, minHeight: 150),
  //             child: SingleChildScrollView(
  //               physics: const BouncingScrollPhysics(),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: <Widget>[
  //                   const SizedBox(
  //                     height: 10,
  //                   ),
  //                   Align(
  //                     alignment: Alignment.centerLeft,
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: Text(
  //                         "Enter OTP to mark as Delivered",
  //                         style: GoogleFonts.manrope(
  //                           fontSize: 14,
  //                           color: Colors.black87,
  //                           fontWeight: FontWeight.w500,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   const Divider(),
  //                   Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Column(
  //                       children: [
  //                         Container(
  //                             padding: const EdgeInsets.all(10),
  //                             decoration: BoxDecoration(
  //                                 color: Colors.grey.shade200,
  //                                 borderRadius: BorderRadius.circular(10)),
  //                             child: Text(
  //                               "Order ID: 5432123",
  //                               style: GoogleFonts.manrope(
  //                                 fontSize: 14,
  //                                 fontWeight: FontWeight.w700,
  //                               ),
  //                             )),
  //                         const SizedBox(
  //                           height: 10,
  //                         ),
  //                         Text(
  //                           "Enter 4 Digit OTP ",
  //                           style: GoogleFonts.manrope(
  //                             fontSize: 12,
  //                           ),
  //                         ),
  //                         const SizedBox(
  //                           height: 10,
  //                         ),
  //                         Form(
  //                           key: otpFinalKey,
  //                           child: Padding(
  //                               padding: const EdgeInsets.symmetric(
  //                                   vertical: 8.0, horizontal: 30),
  //                               child: PinCodeTextField(
  //                                 autoDisposeControllers: false,
  //                                 appContext: context,
  //                                 pastedTextStyle: GoogleFonts.poppins(
  //                                   color: Colors.grey,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                                 length: 4,
  //                                 // obscureText: true,
  //                                 // obscuringCharacter: '*',
  //                                 // obscuringWidget: const FlutterLogo(
  //                                 //   size: 24,
  //                                 // ),
  //                                 blinkWhenObscuring: true,
  //                                 animationType: AnimationType.fade,
  //                                 // validator: (v) {
  //                                 //   if (v!.length <= 3) {
  //                                 //     return "Please enter valid OTP";
  //                                 //   } else {
  //                                 //     return null;
  //                                 //   }
  //                                 // },
  //                                 pinTheme: PinTheme(
  //                                   borderWidth: 1,
  //                                   selectedFillColor: Colors.black12,
  //                                   selectedColor: Colors.black,
  //                                   inactiveFillColor: Colors.grey[100],
  //                                   activeFillColor: Colors.white,
  //                                   activeColor: Colors.black,
  //                                   inactiveColor: Colors.grey[300],
  //                                   shape: PinCodeFieldShape.underline,
  //                                   borderRadius: BorderRadius.circular(5),
  //                                   fieldHeight: 50,
  //                                   fieldWidth: 45,
  //                                 ),
  //                                 cursorColor: Colors.black,
  //                                 animationDuration:
  //                                     const Duration(milliseconds: 300),
  //                                 enableActiveFill: true,
  //                                 errorAnimationController:
  //                                     errortypeotpController,
  //                                 controller: otpCodeController,
  //                                 keyboardType: TextInputType.number,
  //                                 inputFormatters: [
  //                                   FilteringTextInputFormatter.digitsOnly,
  //                                 ],

  //                                 onCompleted: (v) {
  //                                   debugPrint("Completed $v");
  //                                 },
  //                                 // onTap: () {
  //                                 //   print("Pressed");
  //                                 // },
  //                                 onChanged: (value) {
  //                                   debugPrint(value);
  //                                   setState(() {
  //                                     currentText = value;
  //                                   });
  //                                 },
  //                                 beforeTextPaste: (text) {
  //                                   debugPrint("Allowing to paste $text");
  //                                   //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
  //                                   //but you can show anything you want here, like your pop up saying wrong paste format or etc
  //                                   return true;
  //                                 },
  //                               )),
  //                         ),

  //                         SwipeButtonWidget(
  //                             acceptPoitTransition: 0.7,
  //                             margin:
  //                                 const EdgeInsets.symmetric(horizontal: 10),
  //                             padding: const EdgeInsets.all(6),
  //                             boxShadow: const [
  //                               BoxShadow(
  //                                 blurRadius: 4,
  //                                 color: Color.fromRGBO(197, 197, 197, 0.25),
  //                                 spreadRadius: 1.5,
  //                               ),
  //                             ],
  //                             borderRadius: BorderRadius.circular(30),
  //                             colorBeforeSwipe: ColorsData.themeColor,
  //                             colorAfterSwiped: ColorsData.themeColor,
  //                             height: 50,
  //                             childBeforeSwipe: Container(
  //                               decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(30),
  //                                 color: ColorsData.themeColor,
  //                               ),
  //                               height: double.infinity,
  //                               child: CircleAvatar(
  //                                 backgroundColor: Colors.white,
  //                                 child: Icon(
  //                                   Icons.double_arrow_rounded,
  //                                   color: ColorsData.themeColor,
  //                                 ),
  //                               ),
  //                             ),
  //                             leftChildren: const [
  //                               Align(
  //                                 alignment: Alignment(0, 0),
  //                                 child: Text(
  //                                   'SUBMIT OTP',
  //                                   style: TextStyle(
  //                                       fontSize: 16,
  //                                       fontWeight: FontWeight.w600,
  //                                       color: Colors.white),
  //                                 ),
  //                               )
  //                             ],
  //                             childAfterSwiped: const SizedBox(
  //                               height: 24,
  //                               width: 24,
  //                               child: CircularProgressIndicator(
  //                                 strokeWidth: 3,
  //                                 color: Colors.white,
  //                               ),
  //                             ),
  //                             onHorizontalDragUpdate: (e) {},
  //                             onHorizontalDragRight: (e) async {
  //                               context.read<NewOrderBloc>().add(
  //                                   SendingOTPEvent(
  //                                       otp:
  //                                           otpCodeController.text.toString()));

  //                               return true;
  //                             },
  //                             onHorizontalDragleft: (e) async {
  //                               return false;
  //                             })

  //                         // Swipperbuttonwidget(
  //                         //     onSwipeFun: () {
  //                         //       setState(() {
  //                         //         // buttonTitle = "Order Accepted";
  //                         //       });
  //                         //       context.read<NewOrderBloc>().add(
  //                         //           SendingOTPEvent(
  //                         //               otp:
  //                         //                   otpCodeController.text.toString()));
  //                         //       // Navigator.push(
  //                         //       //     context,
  //                         //       //     MaterialPageRoute(
  //                         //       //       builder: (context) => TripSummaryScreen(),
  //                         //       //     ));
  //                         //     },
  //                         //     buttonTitle: "SUBMIT OTP"),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;

  AudioManager._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  Future<void> playAudio(String audioUrl) async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      _isPlaying = false;
    } else {
      await _audioPlayer.play(UrlSource(audioUrl));
      _isPlaying = true;
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
