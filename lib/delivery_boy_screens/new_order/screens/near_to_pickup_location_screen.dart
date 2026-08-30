import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/screens/commocoloo.dart';
import 'package:pure_o_fresh_rider_app/utility/colors_data.dart';
import 'package:pure_o_fresh_rider_app/utility/common_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../commons/ConvertText.dart';
import '../../../commons/shared_prefs.dart';
import '../../navigation_bar/home/notifications/logic/cubit/ongoing_rides_data_cubit.dart';
import '../../navigation_bar/more/profile/logic/bloc/profile_details_bloc.dart';
import '../../navigation_bar/navigationbar_screen.dart';
import '../logic/new_order_bloc.dart';
import '../widgets/dashed_painter.dart';
import '../widgets/swipe_no_back_widegt.dart';
import 'order_review_screen.dart';

class NearToPickUp extends StatefulWidget {
  // final String type;
  final String refId;
  final String? apptype;
  const NearToPickUp({
    super.key,
    // required this.type,
    required this.refId,
    this.apptype,
  });

  static const routeName = "/near_to_pickup";

  @override
  State<NearToPickUp> createState() => _NearToPickUpState();
}

class _NearToPickUpState extends State<NearToPickUp> {
  final otpKey = GlobalKey<FormState>();

  final alternateKey = GlobalKey<FormState>();
  bool _isNavigating = false;
  TextEditingController otpCodeController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  StreamController<ErrorAnimationType>? errorotpController;

  String currentText = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Constants.prefs!.setString("orderId", widget.refId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileDetailsBloc>().add(ProfileDetailsFetchingEvent(
          accessToken: (Constants.prefs!.getString("token"))!));
      context.read<NewOrderBloc>().add(NewOrderDetailsEvent(
          // Constants.prefs!.getString("orderId")!
          refId: Constants.prefs!.getString("orderId")!,
          apptype: widget.apptype));
      removeRideView();
      // NewOrderDetailsEvent(refId: "2023082190740"));
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    print("phoneNumber $phoneNumber");
    phoneNumber = phoneNumber.replaceAll(" ", "");

    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    await launchUrl(launchUri);
  }

  void openGoogleMapsDirections(double originLat, double originLng,
      double destLat, double destLng) async {
    print('${originLat},${originLng},${destLat},${destLng}');
    String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&origin=$originLat,$originLng&destination=$destLat,$destLng";

    if (await canLaunchUrlString(googleMapsUrl)) {
      await launchUrlString(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  removeRideView() async {
    await Constants.prefs?.remove('isrideviewed');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    removeRideView();
    super.dispose();
  }

  Future<bool> onWillPop() async {
    context.read<OngoingRidesDataCubit>().fetchSingleOrderData(isLoading: true);
    removeRideView();
    print("I am Bottom near1");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomsNaviScreen(index: 0),
        ),
        (route) => false);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OngoingRidesDataCubit, OngoingRidesDataState>(
      listener: (context, ongoingRidesDataState) {
        if (!_isNavigating &&
            ongoingRidesDataState.singleOngoingOrderModel != null &&
            ongoingRidesDataState.singleOngoingOrderModel!.data.isEmpty) {
          if (mounted) {
            if (mounted) {
              setState(() {
                _isNavigating = true;
              }); // Set flag to true before navigation
            }
            removeRideView();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const BottomsNaviScreen(index: 0)),
                (route) => false).then((_) {
              // Reset flag when navigation is complete
              if (mounted) {
                setState(() {
                  _isNavigating = false;
                });
              }
            });
          }
        }

        // TODO: implement listener
      },
      child: WillPopScope(
        onWillPop: onWillPop,
        child: BlocConsumer<NewOrderBloc, NewOrderState>(
          listener: (context, state) {
            // TODO: implement listener
            if (state is ReachedtoRestarentSuccessState) {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NearToPickUp(
                      // type: '',
                      apptype: widget.apptype,
                      refId: Constants.prefs!.getString("orderId")!,
                    ),
                  ));
            } else if (state is CabReachedtoRestarentSuccessState) {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NearToPickUp(
                      // type: '',
                      apptype: widget.apptype,
                      refId: Constants.prefs!.getString("orderId")!,
                    ),
                  ));
            } else if (state is CabReachedRastrauntFailedState) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BottomsNaviScreen(index: 0),
                  ));
            }
            if (state is SendingOTPFailureState) {
              // Navigator.pop(context);
              Fluttertoast.showToast(msg: "Invalid PIN, Please try again");
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NearToPickUp(
                      // type: '',
                      apptype: widget.apptype,
                      refId: Constants.prefs!.getString("orderId")!,
                    ),
                  ));
            }
            if (state is SendingOTPSuccessState) {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NearToPickUp(
                      // type: '',
                      apptype: widget.apptype,
                      refId: Constants.prefs!.getString("orderId")!,
                    ),
                  ));
            }
            if (state is ReachedRastrauntFailedState) {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NearToPickUp(
                      // type: '',
                      apptype: widget.apptype,
                      refId: Constants.prefs!.getString("orderId")!,
                    ),
                  ));
            }
          },
          builder: (context, state) {
            return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  leading: Padding(
                      padding: const EdgeInsets.only(
                        left: 6.0,
                        top: 6.0,
                      ),
                      child:
                          BlocBuilder<ProfileDetailsBloc, ProfileDetailsState>(
                        builder: (context, profileState) {
                          if (profileState is ProfileLoadingState) {
                            return CircleAvatar(
                              backgroundColor: ColorsData.themeColor,
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            );
                          }
                          if (profileState is ProfileDetailsLoadedState) {
                            return profileState.profileDetailsModeldata
                                        .deliveryPersonDetails.profilePhoto ==
                                    ''
                                ? CircleAvatar(
                                    backgroundColor: ColorsData.themeColor,
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundColor: ColorsData.themeColor,
                                    backgroundImage: NetworkImage(profileState
                                        .profileDetailsModeldata
                                        .deliveryPersonDetails
                                        .profilePhoto),
                                  );
                          }
                          return const SizedBox(
                            height: 20,
                            width: 20,
                          );
                        },
                      )

                      // ),
                      ),
                  title: Transform.translate(
                    offset: const Offset(-10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          ConvertText.getTitle("Welcome"),
                          style: GoogleFonts.manrope(
                            color: Colors.black87,
                            fontSize: 12,
                          ),
                        ),
                        BlocBuilder<ProfileDetailsBloc, ProfileDetailsState>(
                          builder: (context, profileState) {
                            if (profileState is ProfileLoadingState) {
                              return Text(
                                ConvertText.getTitle("Delivery Boy!"),
                                style: GoogleFonts.manrope(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }

                            if (profileState is ProfileDetailsLoadedState) {
                              return Text(
                                ConvertText.getTitle(
                                    '${profileState.profileDetailsModeldata.deliveryPersonDetails.personName}!'),
                                style: GoogleFonts.manrope(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }
                            return SizedBox(
                              width: 100.0,
                              height: 40.0,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade200,
                                highlightColor: Colors.white,
                                child: Container(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
                body: BlocBuilder<NewOrderBloc, NewOrderState>(
                    builder: (context, state) {
                  if (state is NewOrderLoadingState) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 12),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16)),
                        width: 300.0,
                        height: 200.0,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey.shade200,
                          highlightColor: Colors.white,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                    );
                  } else if (state is NewOrderDetailsSuccessState) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (state.newOrderDetailsModel.data.serviceStatus ==
                                "Waiting For Pickup")
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "ORDER ID: ${state.newOrderDetailsModel.data.refId}",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      10.ph,
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Image.asset(
                                                "assets/images/Pickup.png",
                                                height: 20,
                                              ),
                                              const Dash(
                                                  direction: Axis.vertical,
                                                  length: 90,
                                                  dashLength: 5,
                                                  dashColor: Colors.grey),
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
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              nearToPickupLocation(state
                                                  .newOrderDetailsModel
                                                  .data
                                                  .refId);
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
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
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            color: const Color(
                                                                0xFF45B3C2),
                                                          ),
                                                          child: Text(
                                                            ConvertText.getTitle(
                                                                "NEAR TO PICKUP LOCATION"),
                                                            style: GoogleFonts
                                                                .manrope(
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                        // InkWell(
                                                        //   onTap: () {
                                                        //     nearToPickupLocation();
                                                        //   },
                                                        //   child: Container(
                                                        //     padding:
                                                        //         const EdgeInsets.all(2),
                                                        //     decoration: BoxDecoration(
                                                        //         color:
                                                        //             ColorsData.themeColor,
                                                        //         shape: BoxShape.circle),
                                                        //     child: const Icon(
                                                        //       Icons
                                                        //           .keyboard_arrow_right_outlined,
                                                        //       color: Colors.white,
                                                        //     ),
                                                        //   ),
                                                        // )
                                                      ],
                                                    )),
                                                state
                                                            .newOrderDetailsModel
                                                            .data
                                                            .restaurantDetails
                                                            .restaurantName ==
                                                        ''
                                                    ? Text(
                                                        "N/A",
                                                        style:
                                                            GoogleFonts.manrope(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      )
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.60,
                                                                child: Text(
                                                                  state
                                                                      .newOrderDetailsModel
                                                                      .data
                                                                      .restaurantDetails
                                                                      .restaurantName,
                                                                  style: GoogleFonts
                                                                      .manrope(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap:
                                                                    () async {
                                                                  MapsLauncher.launchQuery(state
                                                                      .newOrderDetailsModel
                                                                      .data
                                                                      .restaurantDetails
                                                                      .displayAddress);
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
                                                              InkWell(
                                                                onTap:
                                                                    () async {
                                                                  await _makePhoneCall(state
                                                                      .newOrderDetailsModel
                                                                      .data
                                                                      .restaurantDetails
                                                                      .mobile);
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
                                                                    size: 18,
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  child: state
                                                              .newOrderDetailsModel
                                                              .data
                                                              .restaurantDetails
                                                              .displayAddress ==
                                                          ''
                                                      ? Text("N/A",
                                                          style: GoogleFonts
                                                              .manrope(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ))
                                                      : Text(
                                                          state
                                                              .newOrderDetailsModel
                                                              .data
                                                              .restaurantDetails
                                                              .displayAddress,
                                                          style: GoogleFonts
                                                              .manrope(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
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
                                                  child: Text(
                                                      ConvertText.getTitle(
                                                          "DELIVER TO"),
                                                      style:
                                                          GoogleFonts.manrope(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: const Color(
                                                            0xFF45B3C2),
                                                      )),
                                                ),
                                                state
                                                            .newOrderDetailsModel
                                                            .data
                                                            .customerDetails
                                                            .customerName ==
                                                        ''
                                                    ? Text(
                                                        'RamaRao',
                                                        style:
                                                            GoogleFonts.manrope(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      )
                                                    : SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.60,
                                                              child: Text(
                                                                state
                                                                    .newOrderDetailsModel
                                                                    .data
                                                                    .customerDetails
                                                                    .customerName,
                                                                style: GoogleFonts.manrope(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
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
                                                                      const Color(
                                                                          0xffF29D00),
                                                                  child: Image.asset(
                                                                      "assets/images/navigation.png",
                                                                      height:
                                                                          12,
                                                                      width:
                                                                          12)),
                                                            ),
                                                            InkWell(
                                                              onTap: () async {
                                                                await _makePhoneCall(state
                                                                    .newOrderDetailsModel
                                                                    .data
                                                                    .customerDetails
                                                                    .mobile);
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
                                                                  size: 18,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  child: state
                                                              .newOrderDetailsModel
                                                              .data
                                                              .customerAddress ==
                                                          ''
                                                      ? Text(
                                                          'N/A',
                                                          style: GoogleFonts
                                                              .manrope(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        )
                                                      : Text(
                                                          state
                                                              .newOrderDetailsModel
                                                              .data
                                                              .customerAddress,
                                                          style: GoogleFonts
                                                              .manrope(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (state.newOrderDetailsModel.data.serviceStatus ==
                                    "Ready To Pickup" ||
                                state.newOrderDetailsModel.data.serviceStatus ==
                                    "Pickedup")
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "ORDER ID: ${state.newOrderDetailsModel.data.refId}",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      10.ph,
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Image.asset(
                                                "assets/images/Pickup.png",
                                                height: 20,
                                              ),
                                              const Dash(
                                                  direction: Axis.vertical,
                                                  length: 90,
                                                  dashLength: 5,
                                                  dashColor: Colors.grey),
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
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Future.delayed(Duration.zero, () {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          OredreReviewScrren(
                                                        refId: state
                                                            .newOrderDetailsModel
                                                            .data
                                                            .refId,
                                                      ),
                                                    ));
                                              });
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
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
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 3,
                                                                  horizontal:
                                                                      5),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            color: const Color(
                                                                0xfff3574e0),
                                                          ),
                                                          child: Text(
                                                            ConvertText.getTitle(
                                                                "PICK UP LOCATION"),
                                                            style: GoogleFonts
                                                                .manrope(
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                        // InkWell(
                                                        //   onTap: () {
                                                        //     Future.delayed(Duration.zero,
                                                        //         () {
                                                        //       Navigator.pushReplacement(
                                                        //           context,
                                                        //           MaterialPageRoute(
                                                        //             builder: (context) =>
                                                        //                 OredreReviewScrren(
                                                        //               refId: state
                                                        //                   .newOrderDetailsModel
                                                        //                   .data
                                                        //                   .refId,
                                                        //             ),
                                                        //           ));
                                                        //     });
                                                        //   },
                                                        //   child: Container(
                                                        //     padding:
                                                        //         const EdgeInsets.all(2),
                                                        //     decoration: BoxDecoration(
                                                        //         color:
                                                        //             ColorsData.themeColor,
                                                        //         shape: BoxShape.circle),
                                                        //     child: const Icon(
                                                        //       Icons
                                                        //           .keyboard_arrow_right_outlined,
                                                        //       color: Colors.white,
                                                        //     ),
                                                        //   ),
                                                        // )
                                                      ],
                                                    )),
                                                state
                                                            .newOrderDetailsModel
                                                            .data
                                                            .restaurantDetails
                                                            .restaurantName ==
                                                        ''
                                                    ? Text(
                                                        " ",
                                                        style:
                                                            GoogleFonts.manrope(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      )
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.60,
                                                                child: Text(
                                                                  state
                                                                      .newOrderDetailsModel
                                                                      .data
                                                                      .restaurantDetails
                                                                      .restaurantName,
                                                                  style: GoogleFonts
                                                                      .manrope(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap:
                                                                    () async {
                                                                  MapsLauncher.launchQuery(state
                                                                      .newOrderDetailsModel
                                                                      .data
                                                                      .restaurantDetails
                                                                      .displayAddress);
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
                                                              InkWell(
                                                                onTap:
                                                                    () async {
                                                                  await _makePhoneCall(state
                                                                      .newOrderDetailsModel
                                                                      .data
                                                                      .restaurantDetails
                                                                      .mobile);
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
                                                                    size: 18,
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  child: state
                                                              .newOrderDetailsModel
                                                              .data
                                                              .restaurantDetails
                                                              .displayAddress ==
                                                          ''
                                                      ? Text(
                                                          "Opposite Diamond Park, Dondaparthy, Dwaraka Nagar, Visakhapatnam, Andhra Pradesh 530016",
                                                          style: GoogleFonts
                                                              .manrope(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ))
                                                      : Text(
                                                          state
                                                              .newOrderDetailsModel
                                                              .data
                                                              .restaurantDetails
                                                              .displayAddress,
                                                          style: GoogleFonts
                                                              .manrope(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
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
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        ConvertText.getTitle(
                                                            'DELIVER TO'),
                                                        style: GoogleFonts.manrope(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: const Color(
                                                                0xFFfe8000)),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                state
                                                            .newOrderDetailsModel
                                                            .data
                                                            .customerDetails
                                                            .customerName ==
                                                        ''
                                                    ? Text(
                                                        'RamaRao',
                                                        style:
                                                            GoogleFonts.manrope(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      )
                                                    : SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.60,
                                                              child: Text(
                                                                state
                                                                    .newOrderDetailsModel
                                                                    .data
                                                                    .customerDetails
                                                                    .customerName,
                                                                style: GoogleFonts.manrope(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
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
                                                                      const Color(
                                                                          0xffF29D00),
                                                                  child: Image.asset(
                                                                      "assets/images/navigation.png",
                                                                      height:
                                                                          12,
                                                                      width:
                                                                          12)),
                                                            ),
                                                            InkWell(
                                                              onTap: () async {
                                                                await _makePhoneCall(state
                                                                    .newOrderDetailsModel
                                                                    .data
                                                                    .customerDetails
                                                                    .mobile);
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
                                                                  size: 18,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  child: state
                                                              .newOrderDetailsModel
                                                              .data
                                                              .customerAddress ==
                                                          ''
                                                      ? Text(
                                                          'Bharath Towers, 405, 4th Floor, 5th Ln, DwarakaNagar, Visakhapatnam, AP 530016',
                                                          style: GoogleFonts
                                                              .manrope(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        )
                                                      : Text(
                                                          state
                                                              .newOrderDetailsModel
                                                              .data
                                                              .customerAddress,
                                                          style: GoogleFonts
                                                              .manrope(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (state.newOrderDetailsModel.data.serviceStatus ==
                                "Out For Delivery")
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(3),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      color: const Color(
                                                          0xFFc245bd),
                                                    ),
                                                    child: Text(
                                                      ConvertText.getTitle(
                                                          'ARRIVED AT DELIVERY LOCATION'),
                                                      style:
                                                          GoogleFonts.manrope(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Future.delayed(
                                                          Duration.zero, () {
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  OredreReviewScrren(
                                                                refId: state
                                                                    .newOrderDetailsModel
                                                                    .data
                                                                    .refId,
                                                              ),
                                                            ));
                                                      });
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2),
                                                      decoration: BoxDecoration(
                                                          color: ColorsData
                                                              .themeColor,
                                                          shape:
                                                              BoxShape.circle),
                                                      child: const Icon(
                                                        Icons
                                                            .keyboard_arrow_right_outlined,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )),
                                          state
                                                      .newOrderDetailsModel
                                                      .data
                                                      .restaurantDetails
                                                      .restaurantName ==
                                                  ''
                                              ? Text(
                                                  "Burger King",
                                                  style: GoogleFonts.manrope(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: SizedBox(
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
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.60,
                                                          child: Text(
                                                            state
                                                                .newOrderDetailsModel
                                                                .data
                                                                .restaurantDetails
                                                                .restaurantName,
                                                            style: GoogleFonts
                                                                .manrope(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
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
                                                                  const Color(
                                                                      0xffF29D00),
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
                                                          child:
                                                              const CircleAvatar(
                                                            radius: 14,
                                                            backgroundColor:
                                                                Color(
                                                                    0xff098B09),
                                                            child: Icon(
                                                              Icons
                                                                  .phone_in_talk_outlined,
                                                              color:
                                                                  Colors.white,
                                                              size: 18,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: state
                                                        .newOrderDetailsModel
                                                        .data
                                                        .restaurantDetails
                                                        .displayAddress ==
                                                    ''
                                                ? Text(
                                                    "Opposite Diamond Park, Dondaparthy, Dwaraka Nagar, Visakhapatnam, Andhra Pradesh 530016",
                                                    style: GoogleFonts.manrope(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ))
                                                : Text(
                                                    state
                                                        .newOrderDetailsModel
                                                        .data
                                                        .restaurantDetails
                                                        .displayAddress,
                                                    style: GoogleFonts.manrope(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                          color: const Color(
                                                              0xFFc245bd))),
                                                ),
                                                BlocBuilder<NewOrderBloc,
                                                    NewOrderState>(
                                                  builder: (context, state) {
                                                    if (state
                                                        is NewOrderDetailsSuccessState) {
                                                      return Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () async {
                                                              print("object");
                                                              if (await Permission
                                                                  .location
                                                                  .isGranted) {
                                                                await MapLauncher
                                                                    .showMarker(
                                                                  mapType: MapType
                                                                      .google,
                                                                  coords: Coords(
                                                                      double.parse(state
                                                                          .newOrderDetailsModel
                                                                          .data
                                                                          .deliveryLat),
                                                                      double.parse(state
                                                                          .newOrderDetailsModel
                                                                          .data
                                                                          .deliveryLng)),
                                                                  title: state
                                                                      .newOrderDetailsModel
                                                                      .data
                                                                      .customerAddress,
                                                                  description:
                                                                      "Delivery Point",
                                                                );
                                                              } else {
                                                                await Permission
                                                                    .location
                                                                    .request();
                                                              }
                                                            },
                                                            child: CircleAvatar(
                                                                radius: 14,
                                                                backgroundColor:
                                                                    const Color(
                                                                        0xffF29D00),
                                                                child: Image.asset(
                                                                    "assets/images/navigation.png",
                                                                    height: 12,
                                                                    width: 12)),
                                                          ),
                                                          10.pw,
                                                          InkWell(
                                                            onTap: () async {
                                                              await _makePhoneCall(state
                                                                  .newOrderDetailsModel
                                                                  .data
                                                                  .restaurantDetails
                                                                  .mobile);
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
                                                                size: 18,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    }
                                                    return const SizedBox();
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                          state
                                                      .newOrderDetailsModel
                                                      .data
                                                      .customerDetails
                                                      .customerName ==
                                                  ''
                                              ? Text(
                                                  'RamaRao',
                                                  style: GoogleFonts.manrope(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )
                                              : Text(
                                                  state
                                                      .newOrderDetailsModel
                                                      .data
                                                      .customerDetails
                                                      .customerName,
                                                  style: GoogleFonts.manrope(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: state.newOrderDetailsModel
                                                        .data.customerAddress ==
                                                    ''
                                                ? Text(
                                                    'N/A',
                                                    style: GoogleFonts.manrope(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  )
                                                : Text(
                                                    state.newOrderDetailsModel
                                                        .data.customerAddress,
                                                    style: GoogleFonts.manrope(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            if (state.newOrderDetailsModel.data.serviceStatus ==
                                "Reached Delivery")
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(10)),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const OredreReviewScrren(),
                                        ));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Column(
                                          children: <Widget>[
                                            const Dash(
                                                direction: Axis.vertical,
                                                length: 15,
                                                dashLength: 3,
                                                dashColor: Colors.grey),
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
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 12.0, left: 10, bottom: 10),
                                        child: Column(
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    ConvertText.getTitle(
                                                        'READY TO DELIVER'),
                                                    style: GoogleFonts.manrope(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: ColorsData
                                                            .themeColor),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //       builder: (context) =>
                                                      //           const OredreReviewScrren(),
                                                      //     ));
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2),
                                                      decoration: BoxDecoration(
                                                          color: ColorsData
                                                              .themeColor,
                                                          shape:
                                                              BoxShape.circle),
                                                      child: const Icon(
                                                        Icons
                                                            .keyboard_arrow_right_outlined,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            BlocBuilder<NewOrderBloc,
                                                NewOrderState>(
                                              builder: (context, state) {
                                                if (state
                                                    is NewOrderDetailsSuccessState) {
                                                  return state
                                                              .newOrderDetailsModel
                                                              .data
                                                              .customerDetails
                                                              .customerName ==
                                                          ''
                                                      ? Text(
                                                          'RamaRao',
                                                          style: GoogleFonts
                                                              .manrope(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        )
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 8.0),
                                                          child: SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.8,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.60,
                                                                  child: Text(
                                                                    state
                                                                        .newOrderDetailsModel
                                                                        .data
                                                                        .customerDetails
                                                                        .customerName,
                                                                    style: GoogleFonts.manrope(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    MapsLauncher.launchQuery(state
                                                                        .newOrderDetailsModel
                                                                        .data
                                                                        .customerAddress);
                                                                  },
                                                                  child: CircleAvatar(
                                                                      radius:
                                                                          14,
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
                                                                InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    await _makePhoneCall(state
                                                                        .newOrderDetailsModel
                                                                        .data
                                                                        .customerDetails
                                                                        .mobile);
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
                                                                      size: 18,
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                }
                                                return SizedBox(
                                                  width: 100.0,
                                                  height: 40.0,
                                                  child: Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey.shade200,
                                                    highlightColor:
                                                        Colors.white,
                                                    child: Container(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              child: BlocBuilder<NewOrderBloc,
                                                  NewOrderState>(
                                                builder: (context, state) {
                                                  if (state
                                                      is NewOrderDetailsSuccessState) {
                                                    return state
                                                                .newOrderDetailsModel
                                                                .data
                                                                .customerAddress ==
                                                            ''
                                                        ? Text(
                                                            'N/A',
                                                            style: GoogleFonts
                                                                .manrope(
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
                                                                .customerAddress,
                                                            style: GoogleFonts
                                                                .manrope(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                          );
                                                  }
                                                  return SizedBox(
                                                    width: 100.0,
                                                    height: 40.0,
                                                    child: Shimmer.fromColors(
                                                      baseColor:
                                                          Colors.grey.shade200,
                                                      highlightColor:
                                                          Colors.white,
                                                      child: Container(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            if (state.newOrderDetailsModel.data.serviceStatus ==
                                "Completed")
                              const Center(
                                child: Text("Yours order is completed"),
                              )
                          ],
                        ),
                      ),
                    );
                  } else if (state is NewOrderDetailsCabSuccessState) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Text(state.newOrderDetailsModel.data.status),
                            if (state.newOrderDetailsModel.data.status ==
                                "Accepted")
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "ORDER ID: ${state.newOrderDetailsModel.data.orderId}",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      10.ph,
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Image.asset(
                                                "assets/images/Pickup.png",
                                                height: 20,
                                              ),
                                              Column(
                                                children: [
                                                  ...state.newOrderDetailsModel
                                                      .data.droppingLocations
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
                                                          height: widget
                                                                      .apptype ==
                                                                  'pickupanddrop'
                                                              ? (entry.key +
                                                                          1) !=
                                                                      state
                                                                          .newOrderDetailsModel
                                                                          .data
                                                                          .droppingLocations
                                                                          .length
                                                                  ? 75
                                                                  : state.newOrderDetailsModel.data.droppingLocations
                                                                              .length >
                                                                          1
                                                                      ? 60
                                                                      : 70
                                                              : (entry.key +
                                                                          1) !=
                                                                      state
                                                                          .newOrderDetailsModel
                                                                          .data
                                                                          .droppingLocations
                                                                          .length
                                                                  ? 54
                                                                  : state.newOrderDetailsModel.data.droppingLocations
                                                                              .length >
                                                                          1
                                                                      ? 40
                                                                      : 50,
                                                          width: 1,
                                                          child: CustomPaint(
                                                            size: const Size(
                                                                1,
                                                                double
                                                                    .infinity),
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
                                                                    color: Colors
                                                                        .black),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          3.0,
                                                                      horizontal:
                                                                          5.0),
                                                              child: Text(
                                                                (entry.key + 1)
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        10),
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
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                        Colors.red,
                                                        BlendMode.srcIn),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              nearToPickupLocation(state
                                                  .newOrderDetailsModel
                                                  .data
                                                  .orderId);
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
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
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            color: const Color(
                                                                0xFF45B3C2),
                                                          ),
                                                          child: Text(
                                                            ConvertText.getTitle(
                                                                "PICKUP LOCATION"),
                                                            style: GoogleFonts
                                                                .manrope(
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            InkWell(
                                                              onTap: () async {
                                                                MapsLauncher.launchQuery(state
                                                                    .newOrderDetailsModel
                                                                    .data
                                                                    .pickupFrom);
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
                                                                        .mobile);
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
                                                        )
                                                      ],
                                                    )),
                                                if (widget.apptype ==
                                                    'pickupanddrop')
                                                  Text(
                                                    state.newOrderDetailsModel
                                                        .data.customerName,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  height: 30,
                                                  child: state
                                                              .newOrderDetailsModel
                                                              .data
                                                              .pickupFrom ==
                                                          ''
                                                      ? Text("N/A",
                                                          style: GoogleFonts
                                                              .manrope(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ))
                                                      : Text(
                                                          state
                                                              .newOrderDetailsModel
                                                              .data
                                                              .pickupFrom,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: GoogleFonts
                                                              .manrope(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
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
                                                  child: Text(
                                                      ConvertText.getTitle(
                                                        widget.apptype == 'cab'
                                                            ? "DROP LOCATION"
                                                            : widget.apptype ==
                                                                    'pickupanddrop'
                                                                ? "DELIVER TO"
                                                                : "DELIVER TO",
                                                      ),
                                                      style:
                                                          GoogleFonts.manrope(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                            0xFF45B3C2),
                                                      )),
                                                ),
                                                state
                                                        .newOrderDetailsModel
                                                        .data
                                                        .droppingLocations
                                                        .isEmpty
                                                    ? Text(
                                                        'N/A',
                                                        style:
                                                            GoogleFonts.manrope(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      )
                                                    : Column(
                                                        children: List.generate(
                                                            state
                                                                .newOrderDetailsModel
                                                                .data
                                                                .droppingLocations
                                                                .length,
                                                            (index) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom:
                                                                        8.0),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                if (widget
                                                                        .apptype ==
                                                                    'pickupanddrop')
                                                                  Text(
                                                                    state
                                                                        .newOrderDetailsModel
                                                                        .data
                                                                        .droppingLocations[
                                                                            index]
                                                                        .personName!,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        height:
                                                                            1.5),
                                                                  ),
                                                                SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.8,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width: widget.apptype == 'pickupanddrop'
                                                                            ? MediaQuery.of(context).size.width *
                                                                                0.6
                                                                            : MediaQuery.of(context).size.width *
                                                                                0.7,
                                                                        height:
                                                                            50,
                                                                        child: state.newOrderDetailsModel.data.droppingLocations[index].address ==
                                                                                ''
                                                                            ? Text(
                                                                                'N/A',
                                                                                style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w500),
                                                                              )
                                                                            : Text(
                                                                                state.newOrderDetailsModel.data.droppingLocations[index].address,
                                                                                maxLines: 3,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w500),
                                                                              ),
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        children: [
                                                                          InkWell(
                                                                            onTap:
                                                                                () async {
                                                                              MapsLauncher.launchQuery(state.newOrderDetailsModel.data.droppingLocations[index].address);
                                                                            },
                                                                            child: CircleAvatar(
                                                                                radius: 14,
                                                                                backgroundColor: const Color(0xffF29D00),
                                                                                child: Image.asset("assets/images/navigation.png", height: 12, width: 12)),
                                                                          ),
                                                                          if (widget.apptype ==
                                                                              'pickupanddrop')
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 8.0),
                                                                              child: InkWell(
                                                                                onTap: () async {
                                                                                  await _makePhoneCall(state.newOrderDetailsModel.data.droppingLocations[index].personNumber!);
                                                                                },
                                                                                child: const CircleAvatar(
                                                                                  radius: 14,
                                                                                  backgroundColor: Color(0xff098B09),
                                                                                  child: Icon(
                                                                                    Icons.phone_in_talk_outlined,
                                                                                    color: Colors.white,
                                                                                    size: 14,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }),
                                                      ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      if (widget.apptype == 'cab')
                                        Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image(
                                                image: NetworkImage(state
                                                    .newOrderDetailsModel
                                                    .data
                                                    .image),
                                                height: 23,
                                                width: 23,
                                                fit: BoxFit.fill,
                                                errorBuilder: (BuildContext
                                                        context,
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
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            10.pw,
                                            InkWell(
                                              onTap: () async {
                                                await _makePhoneCall(state
                                                    .newOrderDetailsModel
                                                    .data
                                                    .mobile);
                                              },
                                              child: const CircleAvatar(
                                                radius: 12,
                                                backgroundColor:
                                                    Color(0xff098B09),
                                                child: Icon(
                                                  Icons.phone_in_talk_outlined,
                                                  color: Colors.white,
                                                  size: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (widget.apptype == 'cab')
                                        Column(
                                          children: [
                                            if (state.newOrderDetailsModel.data
                                                    .forWhom !=
                                                'myself')
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            if (state.newOrderDetailsModel.data
                                                    .forWhom !=
                                                'myself')
                                              Text(
                                                  'This ride was booked for ${state.newOrderDetailsModel.data.someoneName} So please contact him(or)her.',
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            if (state.newOrderDetailsModel.data
                                                    .forWhom !=
                                                'myself')
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            if (state.newOrderDetailsModel.data
                                                    .forWhom !=
                                                'myself')
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 1)),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        state
                                                            .newOrderDetailsModel
                                                            .data
                                                            .someoneName,
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                    10.pw,
                                                    InkWell(
                                                      onTap: () async {
                                                        await _makePhoneCall(state
                                                            .newOrderDetailsModel
                                                            .data
                                                            .someoneMobile);
                                                      },
                                                      child: const CircleAvatar(
                                                        radius: 12,
                                                        backgroundColor:
                                                            Color(0xff098B09),
                                                        child: Icon(
                                                          Icons
                                                              .phone_in_talk_outlined,
                                                          color: Colors.white,
                                                          size: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      if (widget.apptype == 'pickupanddrop')
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                  'assets/images/goodstype.png',
                                                  width: 20,
                                                  height: 20),
                                              10.pw,
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const CommonProximaNovaTextWidget(
                                                    text: 'Type of Goods:',
                                                    fontSize: 12,
                                                  ),
                                                  CommonProximaNovaTextWidget(
                                                    text: state
                                                        .newOrderDetailsModel
                                                        .data
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
                              ),
                            if (state.newOrderDetailsModel.data.status ==
                                "Rider Reached to your location")
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "ORDER ID: ${state.newOrderDetailsModel.data.orderId}",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      10.ph,
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Image.asset(
                                                "assets/images/Pickup.png",
                                                height: 20,
                                              ),
                                              Column(
                                                children: [
                                                  ...state.newOrderDetailsModel
                                                      .data.droppingLocations
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
                                                          height: widget
                                                                      .apptype ==
                                                                  'pickupanddrop'
                                                              ? (entry.key +
                                                                          1) !=
                                                                      state
                                                                          .newOrderDetailsModel
                                                                          .data
                                                                          .droppingLocations
                                                                          .length
                                                                  ? 75
                                                                  : state.newOrderDetailsModel.data.droppingLocations
                                                                              .length >
                                                                          1
                                                                      ? 60
                                                                      : 70
                                                              : (entry.key +
                                                                          1) !=
                                                                      state
                                                                          .newOrderDetailsModel
                                                                          .data
                                                                          .droppingLocations
                                                                          .length
                                                                  ? 54
                                                                  : state.newOrderDetailsModel.data.droppingLocations
                                                                              .length >
                                                                          1
                                                                      ? 40
                                                                      : 50,
                                                          width: 1,
                                                          child: CustomPaint(
                                                            size: const Size(
                                                                1,
                                                                double
                                                                    .infinity),
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
                                                                    color: Colors
                                                                        .black),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          3.0,
                                                                      horizontal:
                                                                          5.0),
                                                              child: Text(
                                                                (entry.key + 1)
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        10),
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
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                        Colors.red,
                                                        BlendMode.srcIn),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              submitOTP();
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
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
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 3,
                                                                  horizontal:
                                                                      5),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            color: const Color(
                                                                0xfff45b3c2),
                                                          ),
                                                          child: Text(
                                                            ConvertText.getTitle(
                                                                "PICK UP LOCATION"),
                                                            style: GoogleFonts
                                                                .manrope(
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            InkWell(
                                                              onTap: () async {
                                                                MapsLauncher.launchQuery(state
                                                                    .newOrderDetailsModel
                                                                    .data
                                                                    .pickupFrom);
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
                                                                        .mobile);
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
                                                    )),
                                                if (widget.apptype ==
                                                    'pickupanddrop')
                                                  Text(
                                                    state.newOrderDetailsModel
                                                        .data.customerName,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  child: state
                                                              .newOrderDetailsModel
                                                              .data
                                                              .pickupFrom ==
                                                          ''
                                                      ? Text("N/A",
                                                          style: GoogleFonts
                                                              .manrope(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ))
                                                      : Text(
                                                          state
                                                              .newOrderDetailsModel
                                                              .data
                                                              .pickupFrom,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: GoogleFonts
                                                              .manrope(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
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
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        ConvertText.getTitle(
                                                          widget.apptype ==
                                                                  'cab'
                                                              ? "DROP LOCATION"
                                                              : widget.apptype ==
                                                                      'pickupanddrop'
                                                                  ? "DELIVER TO"
                                                                  : "DELIVER TO",
                                                        ),
                                                        style: GoogleFonts.manrope(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: const Color(
                                                                0xFFfe8000)),
                                                      )
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
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
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
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  height: 1.5),
                                                            ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.8,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                SizedBox(
                                                                  width: widget.apptype ==
                                                                          'pickupanddrop'
                                                                      ? MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.6
                                                                      : MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.7,
                                                                  height: 50,
                                                                  child: state
                                                                              .newOrderDetailsModel
                                                                              .data
                                                                              .droppingLocations[index]
                                                                              .address ==
                                                                          ''
                                                                      ? Text(
                                                                          'N/A',
                                                                          style: GoogleFonts.manrope(
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w500),
                                                                        )
                                                                      : Text(
                                                                          state
                                                                              .newOrderDetailsModel
                                                                              .data
                                                                              .droppingLocations[index]
                                                                              .address,
                                                                          maxLines:
                                                                              3,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: GoogleFonts.manrope(
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        MapsLauncher.launchQuery(state
                                                                            .newOrderDetailsModel
                                                                            .data
                                                                            .droppingLocations[index]
                                                                            .address);
                                                                      },
                                                                      child: CircleAvatar(
                                                                          radius:
                                                                              14,
                                                                          backgroundColor: const Color(
                                                                              0xffF29D00),
                                                                          child: Image.asset(
                                                                              "assets/images/navigation.png",
                                                                              height: 12,
                                                                              width: 12)),
                                                                    ),
                                                                    if (widget
                                                                            .apptype ==
                                                                        'pickupanddrop')
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                8.0),
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            await _makePhoneCall(state.newOrderDetailsModel.data.droppingLocations[index].personNumber!);
                                                                          },
                                                                          child:
                                                                              const CircleAvatar(
                                                                            radius:
                                                                                14,
                                                                            backgroundColor:
                                                                                Color(0xff098B09),
                                                                            child:
                                                                                Icon(
                                                                              Icons.phone_in_talk_outlined,
                                                                              color: Colors.white,
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
                                                    );
                                                  }),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      if (widget.apptype == 'cab')
                                        Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image(
                                                image: NetworkImage(state
                                                    .newOrderDetailsModel
                                                    .data
                                                    .image),
                                                height: 23,
                                                width: 23,
                                                fit: BoxFit.fill,
                                                errorBuilder: (BuildContext
                                                        context,
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
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            10.pw,
                                            InkWell(
                                              onTap: () async {
                                                await _makePhoneCall(state
                                                    .newOrderDetailsModel
                                                    .data
                                                    .mobile);
                                              },
                                              child: const CircleAvatar(
                                                radius: 12,
                                                backgroundColor:
                                                    Color(0xff098B09),
                                                child: Icon(
                                                  Icons.phone_in_talk_outlined,
                                                  color: Colors.white,
                                                  size: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (widget.apptype == 'cab')
                                        Column(
                                          children: [
                                            if (state.newOrderDetailsModel.data
                                                    .forWhom !=
                                                'myself')
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            if (state.newOrderDetailsModel.data
                                                    .forWhom !=
                                                'myself')
                                              Text(
                                                  'This ride was booked for ${state.newOrderDetailsModel.data.someoneName} So please contact him(or)her.',
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            if (state.newOrderDetailsModel.data
                                                    .forWhom !=
                                                'myself')
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            if (state.newOrderDetailsModel.data
                                                    .forWhom !=
                                                'myself')
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 1)),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        state
                                                            .newOrderDetailsModel
                                                            .data
                                                            .someoneName,
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                    10.pw,
                                                    InkWell(
                                                      onTap: () async {
                                                        await _makePhoneCall(state
                                                            .newOrderDetailsModel
                                                            .data
                                                            .someoneMobile);
                                                      },
                                                      child: const CircleAvatar(
                                                        radius: 12,
                                                        backgroundColor:
                                                            Color(0xff098B09),
                                                        child: Icon(
                                                          Icons
                                                              .phone_in_talk_outlined,
                                                          color: Colors.white,
                                                          size: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      if (widget.apptype == 'pickupanddrop')
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                  'assets/images/goodstype.png',
                                                  width: 20,
                                                  height: 20),
                                              10.pw,
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const CommonProximaNovaTextWidget(
                                                    text: 'Type of Goods:',
                                                    fontSize: 12,
                                                  ),
                                                  CommonProximaNovaTextWidget(
                                                    text: state
                                                        .newOrderDetailsModel
                                                        .data
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
                              ),
                            if (state.newOrderDetailsModel.data.status ==
                                "Started")
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "ORDER ID: ${state.newOrderDetailsModel.data.orderId}",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      10.ph,
                                      InkWell(
                                        onTap: () {
                                          Future.delayed(Duration.zero, () {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      OredreReviewScrren(
                                                          refId: state
                                                              .newOrderDetailsModel
                                                              .data
                                                              .orderId,
                                                          apptype:
                                                              widget.apptype),
                                                ));
                                          });
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Image.asset(
                                                  "assets/images/Pickup.png",
                                                  height: 20,
                                                ),
                                                Column(
                                                  children: [
                                                    ...state
                                                        .newOrderDetailsModel
                                                        .data
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
                                                            height: (widget
                                                                        .apptype ==
                                                                    'pickupanddrop')
                                                                ? (entry.key +
                                                                            1) !=
                                                                        state
                                                                            .newOrderDetailsModel
                                                                            .data
                                                                            .droppingLocations
                                                                            .length
                                                                    ? 75
                                                                    : state.newOrderDetailsModel.data.droppingLocations.length >
                                                                            1
                                                                        ? 60
                                                                        : 70
                                                                : (entry.key +
                                                                            1) !=
                                                                        state
                                                                            .newOrderDetailsModel
                                                                            .data
                                                                            .droppingLocations
                                                                            .length
                                                                    ? 54
                                                                    : state.newOrderDetailsModel.data.droppingLocations.length >
                                                                            1
                                                                        ? 40
                                                                        : 50,
                                                            width: 1,
                                                            child: CustomPaint(
                                                              size: const Size(
                                                                  1,
                                                                  double
                                                                      .infinity),
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
                                                                      color: Colors
                                                                          .black),
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        3.0,
                                                                    horizontal:
                                                                        5.0),
                                                                child: Text(
                                                                  (entry.key +
                                                                          1)
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          10),
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
                                                  colorFilter:
                                                      const ColorFilter.mode(
                                                          Colors.red,
                                                          BlendMode.srcIn),
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
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            color: const Color(
                                                                0xFF3574E0),
                                                          ),
                                                          child: Text(
                                                            ConvertText.getTitle(
                                                                'PICKED UP'),
                                                            style: GoogleFonts
                                                                .manrope(
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                        if (widget.apptype ==
                                                            'pickupanddrop')
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              InkWell(
                                                                onTap:
                                                                    () async {
                                                                  MapsLauncher.launchQuery(state
                                                                      .newOrderDetailsModel
                                                                      .data
                                                                      .pickupFrom);
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
                                                                        .mobile);
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
                                                    )),
                                                if (widget.apptype ==
                                                    'pickupanddrop')
                                                  Text(
                                                    state.newOrderDetailsModel
                                                        .data.customerName,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0),
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    child: state
                                                                .newOrderDetailsModel
                                                                .data
                                                                .pickupFrom ==
                                                            ''
                                                        ? Text("N/A",
                                                            style: GoogleFonts
                                                                .manrope(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ))
                                                        : Text(
                                                            state
                                                                .newOrderDetailsModel
                                                                .data
                                                                .pickupFrom,
                                                            style: GoogleFonts
                                                                .manrope(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            )),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
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
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.60,
                                                            child: Text(
                                                                ConvertText
                                                                    .getTitle(
                                                                  widget.apptype ==
                                                                          'cab'
                                                                      ? "DROP LOCATION"
                                                                      : widget.apptype ==
                                                                              'pickupanddrop'
                                                                          ? "DELIVER TO"
                                                                          : "DELIVER TO",
                                                                ),
                                                                style: GoogleFonts.manrope(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: const Color(
                                                                        0xFFc245bd))),
                                                          ),
                                                        ])),
                                                Column(
                                                  children: List.generate(
                                                      state
                                                          .newOrderDetailsModel
                                                          .data
                                                          .droppingLocations
                                                          .length, (index) {
                                                    return SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
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
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            )
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          8.0),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  if (widget
                                                                          .apptype ==
                                                                      'pickupanddrop')
                                                                    Text(
                                                                      state
                                                                          .newOrderDetailsModel
                                                                          .data
                                                                          .droppingLocations[
                                                                              index]
                                                                          .personName!,
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          height:
                                                                              1.5),
                                                                    ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width: (widget.apptype == 'pickupanddrop')
                                                                            ? MediaQuery.of(context).size.width *
                                                                                0.6
                                                                            : MediaQuery.of(context).size.width *
                                                                                0.7,
                                                                        height:
                                                                            50,
                                                                        child:
                                                                            Text(
                                                                          state
                                                                              .newOrderDetailsModel
                                                                              .data
                                                                              .droppingLocations[index]
                                                                              .address,
                                                                          maxLines:
                                                                              3,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: GoogleFonts.manrope(
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        children: [
                                                                          InkWell(
                                                                            onTap:
                                                                                () async {
                                                                              MapsLauncher.launchQuery(state.newOrderDetailsModel.data.droppingLocations[index].address);
                                                                            },
                                                                            child: CircleAvatar(
                                                                                radius: 14,
                                                                                backgroundColor: const Color(0xffF29D00),
                                                                                child: Image.asset("assets/images/navigation.png", height: 12, width: 12)),
                                                                          ),
                                                                          if (widget.apptype ==
                                                                              'pickupanddrop')
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 8.0),
                                                                              child: InkWell(
                                                                                onTap: () async {
                                                                                  await _makePhoneCall(state.newOrderDetailsModel.data.droppingLocations[index].personNumber!);
                                                                                },
                                                                                child: const CircleAvatar(
                                                                                  radius: 14,
                                                                                  backgroundColor: Color(0xff098B09),
                                                                                  child: Icon(
                                                                                    Icons.phone_in_talk_outlined,
                                                                                    color: Colors.white,
                                                                                    size: 14,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                    );
                                                  }),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      if (widget.apptype == 'pickupanddrop')
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                  'assets/images/goodstype.png',
                                                  width: 20,
                                                  height: 20),
                                              10.pw,
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const CommonProximaNovaTextWidget(
                                                    text: 'Type of Goods:',
                                                    fontSize: 12,
                                                  ),
                                                  CommonProximaNovaTextWidget(
                                                    text: state
                                                        .newOrderDetailsModel
                                                        .data
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
                              ),
                            if (state.newOrderDetailsModel.data.status ==
                                "Completed")
                              const Center(
                                child: Text("Yours order is completed"),
                              ),
                            if (state.newOrderDetailsModel.data.status ==
                                "Cancelled")
                              const Center(
                                child: Text("This Ride is Canceled By User"),
                              ),
                            if (state.newOrderDetailsModel.data.status ==
                                "Rejected")
                              const Center(
                                child: Text("This Ride was Rejected"),
                              )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 12),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16)),
                        width: 300.0,
                        height: 200.0,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey.shade200,
                          highlightColor: Colors.white,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                    );
                  }
                }));
          },
        ),
      ),
    );
  }

  // void orderDetails() {
  //   showModalBottomSheet<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return SizedBox(
  //         // height: 200,
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             SizedBox(
  //               height: 10,
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Container(
  //                     padding: EdgeInsets.all(10),
  //                     decoration: BoxDecoration(
  //                         border: Border.all(color: Colors.grey.shade300),
  //                         borderRadius: BorderRadius.circular(10)),
  //                     child: Row(
  //                       children: [
  //                         Column(
  //                           children: <Widget>[
  //                             Image.asset(
  //                               "assets/images/Pickup.png",
  //                               height: 20,
  //                             ),
  //                             const Dash(
  //                                 direction: Axis.vertical,
  //                                 length: 60,
  //                                 dashLength: 5,
  //                                 dashColor: Colors.grey),
  //                             const Icon(
  //                               Icons.location_pin,
  //                               color: Colors.grey,
  //                             )
  //                           ],
  //                         ),
  //                         SizedBox(
  //                           width: 5,
  //                         ),
  //                         Column(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             SizedBox(
  //                               width: MediaQuery.of(context).size.width * 0.8,
  //                               child: Row(
  //                                 mainAxisAlignment:
  //                                     MainAxisAlignment.spaceBetween,
  //                                 children: [
  //                                   BlocBuilder<NewOrderBloc, NewOrderState>(
  //                                     builder: (context, state) {
  //                                       if (state
  //                                           is NewOrderDetailsSuccessState) {
  //                                         return state
  //                                                     .newOrderDetailsModel
  //                                                     .data
  //                                                     .restaurantDetails
  //                                                     .restaurantName ==
  //                                                 ''
  //                                             ? Text(
  //                                                 "Burger King",
  //                                                 style: GoogleFonts.manrope(
  //                                                   fontSize: 14,
  //                                                   fontWeight: FontWeight.w700,
  //                                                 ),
  //                                               )
  //                                             : Text(
  //                                                 state
  //                                                     .newOrderDetailsModel
  //                                                     .data
  //                                                     .restaurantDetails
  //                                                     .restaurantName,
  //                                                 style: GoogleFonts.manrope(
  //                                                   fontSize: 14,
  //                                                   fontWeight: FontWeight.w700,
  //                                                 ),
  //                                               );
  //                                       }
  //                                       return const CircularProgressIndicator();
  //                                     },
  //                                   ),
  //                                   GestureDetector(
  //                                     onTap: () {},
  //                                     child: Container(
  //                                       padding: const EdgeInsets.all(4),
  //                                       decoration: BoxDecoration(
  //                                           color: ColorsData.themeColor,
  //                                           borderRadius:
  //                                               BorderRadius.circular(6)),
  //                                       child: Text(
  //                                         "GET DIRECTIONS",
  //                                         style: GoogleFonts.manrope(
  //                                           color: Colors.white,
  //                                           fontSize: 9,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   )
  //                                 ],
  //                               ),
  //                             ),
  //                             SizedBox(
  //                               height: 8,
  //                             ),
  //                             SizedBox(
  //                               width: MediaQuery.of(context).size.width * 0.8,
  //                               child: Text(
  //                                   "Opposite Diamond Park, Dondaparthy, Dwaraka Nagar, Visakhapatnam, Andhra Pradesh 530016",
  //                                   style: GoogleFonts.manrope(
  //                                     fontSize: 12,
  //                                     fontWeight: FontWeight.w500,
  //                                   )),
  //                             ),
  //                             const SizedBox(
  //                               height: 10,
  //                             ),
  //                             SizedBox(
  //                               width: MediaQuery.of(context).size.width * 0.8,
  //                               child: Row(
  //                                 mainAxisAlignment:
  //                                     MainAxisAlignment.spaceBetween,
  //                                 children: [
  //                                   Text(
  //                                     'DELIVER',
  //                                     style: GoogleFonts.manrope(
  //                                       fontSize: 12,
  //                                       fontWeight: FontWeight.w500,
  //                                       color: Colors.amber[700],
  //                                     ),
  //                                   ),
  //                                   CircleAvatar(
  //                                     radius: 16,
  //                                     backgroundColor: ColorsData.themeColor,
  //                                     child: const Icon(
  //                                       Icons.phone_in_talk_outlined,
  //                                       color: Colors.white,
  //                                       size: 18,
  //                                     ),
  //                                   )
  //                                 ],
  //                               ),
  //                             ),
  //                             BlocBuilder<NewOrderBloc, NewOrderState>(
  //                               builder: (context, state) {
  //                                 if (state is NewOrderDetailsSuccessState) {
  //                                   return state.newOrderDetailsModel.data
  //                                               .customerDetails.customerNamee ==
  //                                           ''
  //                                       ? Text(
  //                                           'RamaRao',
  //                                           style: GoogleFonts.manrope(
  //                                               fontSize: 14,
  //                                               fontWeight: FontWeight.w600),
  //                                         )
  //                                       : Text(
  //                                           state.newOrderDetailsModel.data
  //                                               .customerDetails.customerNamee,
  //                                           style: GoogleFonts.manrope(
  //                                               fontSize: 14,
  //                                               fontWeight: FontWeight.w600),
  //                                         );
  //                                 }
  //                                 return const CircularProgressIndicator();
  //                               },
  //                             ),
  //                             SizedBox(
  //                               width: MediaQuery.of(context).size.width * 0.8,
  //                               child: BlocBuilder<NewOrderBloc, NewOrderState>(
  //                                 builder: (context, state) {
  //                                   if (state is NewOrderDetailsSuccessState) {
  //                                     return state.newOrderDetailsModel.data
  //                                                 .customerAddress ==
  //                                             ''
  //                                         ? Text(
  //                                             'Bharath Towers, 405, 4th Floor, 5th Ln, DwarakaNagar, Visakhapatnam, AP 530016',
  //                                             style: GoogleFonts.manrope(
  //                                                 fontSize: 12,
  //                                                 fontWeight: FontWeight.w500),
  //                                           )
  //                                         : Text(
  //                                             state.newOrderDetailsModel.data
  //                                                 .customerAddress,
  //                                             style: GoogleFonts.manrope(
  //                                                 fontSize: 12,
  //                                                 fontWeight: FontWeight.w500),
  //                                           );
  //                                   }
  //                                   return const CircularProgressIndicator();
  //                                 },
  //                               ),
  //                             )
  //                           ],
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 10,
  //                   ),
  //                   Container(
  //                     padding: EdgeInsets.all(10),
  //                     decoration: BoxDecoration(
  //                         border: Border.all(color: Colors.grey.shade300),
  //                         borderRadius: BorderRadius.circular(10)),
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Text(
  //                               "Order Details",
  //                               style: GoogleFonts.manrope(
  //                                 fontSize: 14,
  //                                 fontWeight: FontWeight.w700,
  //                               ),
  //                             ),
  //                             Padding(
  //                               padding:
  //                                   const EdgeInsets.symmetric(vertical: 4.0),
  //                               child: Text(
  //                                 "Total Bill: ₹ 650",
  //                                 style: GoogleFonts.manrope(
  //                                     color: ColorsData.themeColor,
  //                                     fontSize: 16,
  //                                     fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         SizedBox(
  //                           height: 6,
  //                         ),
  //                         Text(
  //                           "Veg Biriyani * 1",
  //                           style: GoogleFonts.manrope(
  //                             fontSize: 10,
  //                           ),
  //                         ),
  //                         Padding(
  //                           padding: const EdgeInsets.symmetric(vertical: 4.0),
  //                           child: Text(
  //                             "Egg Biriyani * 1",
  //                             style: GoogleFonts.manrope(
  //                               fontSize: 10,
  //                             ),
  //                           ),
  //                         ),
  //                         Text(
  //                           "Paneer Biriyani * 1",
  //                           style: GoogleFonts.manrope(
  //                             fontSize: 10,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 10,
  //                   ),
  //                   Swipperbuttonwidget(
  //                       onSwipeFun: () {
  //                         setState(() {
  //                           buttonTitle = "Order Accepted";
  //                         });
  //                         Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                               builder: (context) => NearToPickUp(
  //                                 type: 'readyToDeliver',
  //                               ),
  //                             ));
  //                       },
  //                       buttonTitle: "REACHED DROPPING LOCATION"),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  void nearToPickupLocation(orderId) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          // height: 200,
          child: BlocConsumer<NewOrderBloc, NewOrderState>(
            listener: (context, state) {
              // TODO: implement listener
              if (state is ReachedPickupSuccessState) {
                print("object if (state is ReachedR}");
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    10.ph,
                    CommonProximaNovaTextWidget(
                      text: "OrderId : $orderId",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BlocBuilder<NewOrderBloc, NewOrderState>(
                                  builder: (context, state) {
                                    if (state
                                        is NewOrderDetailsCabSuccessState) {
                                      return Column(
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
                                                      height: widget.apptype ==
                                                              'pickupanddrop'
                                                          ? (entry.key + 1) !=
                                                                  state
                                                                      .newOrderDetailsModel
                                                                      .data
                                                                      .droppingLocations
                                                                      .length
                                                              ? 75
                                                              : state
                                                                          .newOrderDetailsModel
                                                                          .data
                                                                          .droppingLocations
                                                                          .length >
                                                                      1
                                                                  ? 60
                                                                  : 70
                                                          : (entry.key + 1) !=
                                                                  state
                                                                      .newOrderDetailsModel
                                                                      .data
                                                                      .droppingLocations
                                                                      .length
                                                              ? 52
                                                              : state
                                                                          .newOrderDetailsModel
                                                                          .data
                                                                          .droppingLocations
                                                                          .length >
                                                                      1
                                                                  ? 40
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
                                                                color: Colors
                                                                    .black),
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
                                                            style: const TextStyle(
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
                                          SvgPicture.asset(
                                            "assets/images/pin.svg",
                                            height: 20,
                                            width: 20,
                                            colorFilter: const ColorFilter.mode(
                                                Colors.red, BlendMode.srcIn),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Column(
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
                                      );
                                    }
                                  },
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
                                          BlocBuilder<NewOrderBloc,
                                              NewOrderState>(
                                            builder: (context, state) {
                                              if (state
                                                  is NewOrderDetailsSuccessState) {
                                                return state
                                                            .newOrderDetailsModel
                                                            .data
                                                            .restaurantDetails
                                                            .restaurantName ==
                                                        ''
                                                    ? Text(
                                                        "N/A",
                                                        style:
                                                            GoogleFonts.manrope(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      )
                                                    : SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.60,
                                                        child: Text(
                                                          state
                                                              .newOrderDetailsModel
                                                              .data
                                                              .restaurantDetails
                                                              .restaurantName,
                                                          style: GoogleFonts
                                                              .manrope(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      );
                                              }
                                              if (state
                                                  is NewOrderDetailsCabSuccessState) {
                                                return state.newOrderDetailsModel
                                                            .data.pickupFrom ==
                                                        ''
                                                    ? Text(
                                                        "N/A",
                                                        style:
                                                            GoogleFonts.manrope(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      )
                                                    : SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.60,
                                                        child: Text(
                                                          "PICKUP LOCATION",
                                                          style: GoogleFonts.manrope(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: const Color(
                                                                  0xff45B3C2)),
                                                        ),
                                                      );
                                              }
                                              return SizedBox(
                                                width: 60.0,
                                                height: 30.0,
                                                child: Shimmer.fromColors(
                                                  baseColor:
                                                      Colors.grey.shade200,
                                                  highlightColor: Colors.white,
                                                  child: Container(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        BlocBuilder<NewOrderBloc,
                                            NewOrderState>(
                                          builder: (context, state) {
                                            if (state
                                                is NewOrderDetailsSuccessState) {
                                              return SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.64,
                                                child: Text(
                                                    state
                                                        .newOrderDetailsModel
                                                        .data
                                                        .restaurantDetails
                                                        .address,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.manrope(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                              );
                                            }
                                            if (state
                                                is NewOrderDetailsCabSuccessState) {
                                              return Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  if (widget.apptype ==
                                                      'pickupanddrop')
                                                    Text(
                                                      state.newOrderDetailsModel
                                                          .data.customerName,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  SizedBox(
                                                    width: widget.apptype ==
                                                            'pickupanddrop'
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.62
                                                        : MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.72,
                                                    child: Text(
                                                        state
                                                            .newOrderDetailsModel
                                                            .data
                                                            .pickupFrom,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.manrope(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        )),
                                                  ),
                                                ],
                                              );
                                            }
                                            return const SizedBox();
                                          },
                                        ),
                                        BlocBuilder<NewOrderBloc,
                                            NewOrderState>(
                                          builder: (context, state) {
                                            if (state
                                                is NewOrderDetailsSuccessState) {
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                      onTap: () async {
                                                        print("object");
                                                        if (await Permission
                                                            .location
                                                            .isGranted) {
                                                          await MapLauncher
                                                              .showMarker(
                                                            mapType:
                                                                MapType.google,
                                                            coords: Coords(
                                                                double.parse(state
                                                                    .newOrderDetailsModel
                                                                    .data
                                                                    .restaurantLat),
                                                                double.parse(state
                                                                    .newOrderDetailsModel
                                                                    .data
                                                                    .restaurantLng)),
                                                            title: state
                                                                .newOrderDetailsModel
                                                                .data
                                                                .restaurantDetails
                                                                .address,
                                                            description:
                                                                "Pick Up Point",
                                                          );
                                                        } else {
                                                          await Permission
                                                              .location
                                                              .request();
                                                        }
                                                      },
                                                      child: CircleAvatar(
                                                          radius: 14,
                                                          backgroundColor:
                                                              const Color(
                                                                  0xffF29D00),
                                                          child: Image.asset(
                                                              "assets/images/navigation.png",
                                                              height: 12,
                                                              width: 12))),
                                                  10.pw,
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
                                                      backgroundColor:
                                                          Color(0xff098B09),
                                                      child: Icon(
                                                        Icons
                                                            .phone_in_talk_outlined,
                                                        color: Colors.white,
                                                        size: 18,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              );
                                            }
                                            if (state
                                                is NewOrderDetailsCabSuccessState) {
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                      onTap: () async {
                                                        print("object");
                                                        MapsLauncher
                                                            .launchQuery(state
                                                                .newOrderDetailsModel
                                                                .data
                                                                .pickupFrom);
                                                      },
                                                      child: CircleAvatar(
                                                          radius: 14,
                                                          backgroundColor:
                                                              const Color(
                                                                  0xffF29D00),
                                                          child: Image.asset(
                                                              "assets/images/navigation.png",
                                                              height: 14,
                                                              width: 14))),
                                                  if (widget.apptype ==
                                                      'pickupanddrop')
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: InkWell(
                                                        onTap: () async {
                                                          await _makePhoneCall(state
                                                              .newOrderDetailsModel
                                                              .data
                                                              .mobile);
                                                        },
                                                        child:
                                                            const CircleAvatar(
                                                          radius: 14,
                                                          backgroundColor:
                                                              Color(0xff098B09),
                                                          child: Icon(
                                                            Icons
                                                                .phone_in_talk_outlined,
                                                            color: Colors.white,
                                                            size: 14,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              );
                                            }
                                            return const SizedBox();
                                          },
                                        )
                                      ],
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
                                          Text(
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
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF45B3C2),
                                            ),
                                          ),
                                          // const Icon(
                                          //   Icons.info_outline,
                                          //   color: Colors.grey,
                                          //   size: 18,
                                          // )
                                        ],
                                      ),
                                    ),
                                    BlocBuilder<NewOrderBloc, NewOrderState>(
                                      builder: (context, state) {
                                        if (state
                                            is NewOrderDetailsSuccessState) {
                                          return state
                                                      .newOrderDetailsModel
                                                      .data
                                                      .customerDetails
                                                      .customerName ==
                                                  ''
                                              ? Text(
                                                  'cust name',
                                                  style: GoogleFonts.manrope(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )
                                              : SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.60,
                                                        child: Text(
                                                          state
                                                              .newOrderDetailsModel
                                                              .data
                                                              .customerDetails
                                                              .customerName,
                                                          style: GoogleFonts
                                                              .manrope(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
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
                                                                const Color(
                                                                    0xffF29D00),
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
                                                        child:
                                                            const CircleAvatar(
                                                          radius: 14,
                                                          backgroundColor:
                                                              Color(0xff098B09),
                                                          child: Icon(
                                                            Icons
                                                                .phone_in_talk_outlined,
                                                            color: Colors.white,
                                                            size: 18,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                        }

                                        if (state
                                            is NewOrderDetailsCabSuccessState) {
                                          return Column(
                                            children: List.generate(
                                                state
                                                    .newOrderDetailsModel
                                                    .data
                                                    .droppingLocations
                                                    .length, (index) {
                                              return Padding(
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
                                                            width: widget
                                                                        .apptype ==
                                                                    'pickupanddrop'
                                                                ? MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.60
                                                                : MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.7,
                                                            height: 50,
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
                                                                            FontWeight.w500),
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
                                                                            FontWeight.w500),
                                                                  ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              InkWell(
                                                                onTap:
                                                                    () async {
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
                                                                            14,
                                                                        width:
                                                                            14)),
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
                                                                  child:
                                                                      InkWell(
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
                                                                      radius:
                                                                          14,
                                                                      backgroundColor:
                                                                          Color(
                                                                              0xff098B09),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .phone_in_talk_outlined,
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            14,
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
                                              );
                                            }),
                                          );
                                        }
                                        return SizedBox(
                                          width: 60.0,
                                          height: 30.0,
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.grey.shade200,
                                            highlightColor: Colors.white,
                                            child: Container(
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: BlocBuilder<NewOrderBloc,
                                          NewOrderState>(
                                        builder: (context, state) {
                                          if (state
                                              is NewOrderDetailsSuccessState) {
                                            return state.newOrderDetailsModel
                                                        .data.customerAddress ==
                                                    ''
                                                ? Text(
                                                    'customerAddress',
                                                    style: GoogleFonts.manrope(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  )
                                                : Text(
                                                    state.newOrderDetailsModel
                                                        .data.customerAddress,
                                                    style: GoogleFonts.manrope(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  );
                                          }
                                          if (state
                                              is NewOrderDetailsCabSuccessState) {
                                            return widget.apptype == 'cab'
                                                ? Row(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: Image(
                                                          image: NetworkImage(state
                                                              .newOrderDetailsModel
                                                              .data
                                                              .image),
                                                          height: 23,
                                                          width: 23,
                                                          fit: BoxFit.fill,
                                                          errorBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  Object
                                                                      exception,
                                                                  StackTrace?
                                                                      stackTrace) {
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
                                                          state
                                                              .newOrderDetailsModel
                                                              .data
                                                              .customerName,
                                                          style: const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                      10.pw,
                                                      InkWell(
                                                        onTap: () async {
                                                          await _makePhoneCall(state
                                                              .newOrderDetailsModel
                                                              .data
                                                              .mobile);
                                                        },
                                                        child:
                                                            const CircleAvatar(
                                                          radius: 12,
                                                          backgroundColor:
                                                              Color(0xff098B09),
                                                          child: Icon(
                                                            Icons
                                                                .phone_in_talk_outlined,
                                                            color: Colors.white,
                                                            size: 14,
                                                          ),
                                                        ),
                                                      ),
                                                      10.pw,
                                                      if (state
                                                              .newOrderDetailsModel
                                                              .data
                                                              .forWhom !=
                                                          'myself')
                                                        Text(
                                                            state
                                                                .newOrderDetailsModel
                                                                .data
                                                                .someoneName,
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                      if (state
                                                              .newOrderDetailsModel
                                                              .data
                                                              .forWhom !=
                                                          'myself')
                                                        10.pw,
                                                      if (state
                                                              .newOrderDetailsModel
                                                              .data
                                                              .forWhom !=
                                                          'myself')
                                                        InkWell(
                                                          onTap: () async {
                                                            await _makePhoneCall(state
                                                                .newOrderDetailsModel
                                                                .data
                                                                .someoneMobile);
                                                          },
                                                          child:
                                                              const CircleAvatar(
                                                            radius: 12,
                                                            backgroundColor:
                                                                Color(
                                                                    0xff098B09),
                                                            child: Icon(
                                                              Icons
                                                                  .phone_in_talk_outlined,
                                                              color:
                                                                  Colors.white,
                                                              size: 14,
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Row(
                                                      children: [
                                                        Image.asset(
                                                            'assets/images/goodstype.png',
                                                            width: 20,
                                                            height: 20),
                                                        10.pw,
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const CommonProximaNovaTextWidget(
                                                              text:
                                                                  'Type of Goods:',
                                                              fontSize: 12,
                                                            ),
                                                            CommonProximaNovaTextWidget(
                                                              text: state
                                                                  .newOrderDetailsModel
                                                                  .data
                                                                  .goodsType,
                                                              fontSize: 12,
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                          }
                                          return SizedBox(
                                            width: 60.0,
                                            height: 30.0,
                                            child: Shimmer.fromColors(
                                              baseColor: Colors.grey.shade200,
                                              highlightColor: Colors.white,
                                              child: Container(
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          BlocBuilder<NewOrderBloc, NewOrderState>(
                            builder: (context, newOrderstate) {
                              if (newOrderstate
                                  is NewOrderDetailsCabSuccessState) {
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
                                              'REACHED PICKUP LOCATION'),
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
                                          CabReachedToRestrantLocationEvent(
                                              refId: newOrderstate
                                                  .newOrderDetailsModel.data.id
                                                  .toString(),
                                              apptype: widget.apptype!));

                                      return true;
                                    },
                                    onHorizontalDragleft: (e) async {
                                      return false;
                                    });
                              } else {
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
                                              'REACHED PICKUP LOCATION'),
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
                                          const ReachedToRestrantLocationEvent(
                                              refId: ''));

                                      return true;
                                    },
                                    onHorizontalDragleft: (e) async {
                                      return false;
                                    });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // void pickedUp() {
  //   showModalBottomSheet<void>(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //             topRight: Radius.circular(12), topLeft: Radius.circular(12))),
  //     builder: (BuildContext context) {
  //       return Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Container(
  //                   padding: EdgeInsets.all(10),
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         "PICK FOOD",
  //                         style: GoogleFonts.manrope(
  //                           fontSize: 14,
  //                           color: ColorsData.themeColor,
  //                           fontWeight: FontWeight.w700,
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 8,
  //                       ),
  //                       Text("Please Check the Orders",
  //                           style: GoogleFonts.manrope(
  //                             fontSize: 12,
  //                             fontWeight: FontWeight.w600,
  //                           )),
  //                       SizedBox(
  //                         height: 8,
  //                       ),
  //                       Text(
  //                         "Veg Biriyani * 1",
  //                         style: GoogleFonts.manrope(
  //                           fontSize: 10,
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(vertical: 4.0),
  //                         child: Text(
  //                           "Egg Biriyani * 1",
  //                           style: GoogleFonts.manrope(
  //                             fontSize: 10,
  //                           ),
  //                         ),
  //                       ),
  //                       Text(
  //                         "Paneer Biriyani * 1",
  //                         style: GoogleFonts.manrope(
  //                           fontSize: 10,
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(vertical: 4.0),
  //                         child: Text(
  //                           "Total Bill: ₹ 650",
  //                           style: GoogleFonts.manrope(
  //                               fontSize: 16, fontWeight: FontWeight.bold),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Swipperbuttonwidget(
  //                     onSwipeFun: () {
  //                       setState(() {
  //                         buttonTitle = "Order Accepted";
  //                       });
  //                       Navigator.pop(context);
  //                       submitOTP();
  //                     },
  //                     buttonTitle: "Yes, Confirm Order"),
  //                 Row(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Text(
  //                       "Alternate the Food Items",
  //                       style: GoogleFonts.manrope(
  //                         fontSize: 10,
  //                       ),
  //                     ),
  //                     TextButton(
  //                       onPressed: () {
  //                         alternateFood();
  //                       },
  //                       child: Text(
  //                         "Customer Support!",
  //                         style: GoogleFonts.manrope(
  //                             color: ColorsData.themeColor,
  //                             fontSize: 11,
  //                             fontWeight: FontWeight.bold),
  //                       ),
  //                     )
  //                   ],
  //                 )
  //               ],
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void alternateFood() {
  //   showModalBottomSheet<void>(
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
  //           duration: Duration(milliseconds: 150),
  //           child: Container(
  //             constraints: BoxConstraints(maxHeight: 900, minHeight: 150),
  //             child: SingleChildScrollView(
  //               physics: BouncingScrollPhysics(),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: <Widget>[
  //                   SizedBox(
  //                     height: 10,
  //                   ),
  //                   Align(
  //                     alignment: Alignment.centerLeft,
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.start,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             "Alternate Food Items",
  //                             style: GoogleFonts.manrope(
  //                               fontSize: 16,
  //                               color: ColorsData.themeColor,
  //                               fontWeight: FontWeight.w500,
  //                             ),
  //                           ),
  //                           SizedBox(
  //                             height: 6,
  //                           ),
  //                           Text(
  //                             "Please Enter Alternate Orders",
  //                             style: GoogleFonts.manrope(
  //                               fontSize: 12,
  //                               fontWeight: FontWeight.w500,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding:
  //                         const EdgeInsets.only(left: 8, right: 8, bottom: 10),
  //                     child: Column(
  //                       children: [
  //                         Form(
  //                             key: alternateKey,
  //                             child: Column(
  //                               children: [
  //                                 DeliveryBoyTextFormField(
  //                                   obscureText: true,
  //                                   isDense: true,
  //                                   hint: "Exchange Item1",
  //                                   hintStyle: TextStyle(color: Colors.grey),
  //                                 ),
  //                                 DeliveryBoyTextFormField(
  //                                   isDense: true,
  //                                   hintStyle: TextStyle(color: Colors.grey),
  //                                   hint: "Exchange Item2",
  //                                 ),
  //                                 SizedBox(
  //                                   height: 10,
  //                                 )
  //                               ],
  //                             )),
  //                         Swipperbuttonwidget(
  //                             onSwipeFun: () {
  //                               Navigator.pop(context);
  //                               submitOTP();
  //                               setState(() {
  //                                 // buttonTitle = "Order Accepted";
  //                               });
  //                               // Navigator.push(
  //                               //     context,
  //                               //     MaterialPageRoute(
  //                               //       builder: (context) => NearToPickUp(
  //                               //         type: 'submitOTP',
  //                               //       ),
  //                               //     ));
  //                             },
  //                             buttonTitle: "Yes, Confirm Order"),
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

  void submitOTP() {
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
        return BlocBuilder<NewOrderBloc, NewOrderState>(
          builder: (context, state) {
            if (state is NewOrderDetailsCabSuccessState) {
              return SizedBox(
                // height: 260,
                child: AnimatedPadding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  duration: const Duration(milliseconds: 150),
                  child: Container(
                    constraints:
                        const BoxConstraints(maxHeight: 900, minHeight: 150),
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
                                "Enter OTP to as Picked Up-ORDER ID : ${state.newOrderDetailsModel.data.orderId}",
                                style: GoogleFonts.manrope(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  "Enter 4 Digit OTP ",
                                  style: GoogleFonts.manrope(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Form(
                                  key: otpKey,
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
                                          selectedColor: Colors.black,
                                          inactiveFillColor: Colors.grey[100],
                                          activeFillColor: Colors.white,
                                          activeColor: Colors.black,
                                          inactiveColor: Colors.grey[300],
                                          shape: PinCodeFieldShape.underline,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          fieldHeight: 50,
                                          fieldWidth: 45,
                                        ),
                                        cursorColor: Colors.black,
                                        animationDuration:
                                            const Duration(milliseconds: 300),
                                        enableActiveFill: true,
                                        errorAnimationController:
                                            errorotpController,
                                        controller: otpController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],

                                        onCompleted: (v) {
                                          debugPrint("Completed $v");
                                        },
                                        // onTap: () {
                                        //   print("Pressed");
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
                                SwipeButtonWidget(
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
                                              'VERIFY & START RIDE'),
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
                                      if (currentText.length < 4) {
                                        // Show an error message or perform any other action to indicate that the OTP is incomplete
                                        Fluttertoast.showToast(
                                            msg: 'Please enter complete otp');
                                        return false; // Return false to prevent swiping if OTP is incomplete
                                      } else {
                                        // OTP is complete, proceed with the action

                                        context.read<NewOrderBloc>().add(
                                            SendingOTPEvent(
                                                refId: state
                                                    .newOrderDetailsModel
                                                    .data
                                                    .id
                                                    .toString(),
                                                apptype: widget.apptype!,
                                                otp: currentText));

                                        return true;
                                        // Allow swiping since OTP is complete
                                      }
                                    },
                                    onHorizontalDragleft: (e) async {
                                      return false;
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}
