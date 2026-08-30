import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:pure_o_fresh_rider_app/commons/ConvertText.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/my_orders_rides/cubit/my_order_rides_cubit.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/screens/commocoloo.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/new_order/screens/near_to_pickup_location_screen.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/new_order/screens/new_order_screen.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/new_order/screens/order_review_screen.dart';
import 'package:pure_o_fresh_rider_app/utility/common_text.dart';
import 'package:pure_o_fresh_rider_app/utility/widgets/theme_spinner.dart';
import 'package:url_launcher/url_launcher.dart';

class RideListScreen extends StatefulWidget {
  const RideListScreen({super.key});

  @override
  State<RideListScreen> createState() => _RideListScreenState();
}

class _RideListScreenState extends State<RideListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<MyOrderRidesCubit>().fecthRideList('cab');
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<MyOrderRidesCubit, MyOrderRidesState>(
      builder: (context, state) {
        if (state.dataLoad == true) {
          return const ThemeSpinner(
            color: Colors.black,
          );
        } else {
          if (state.dataLoadedSuccess == true) {
            return state.rideList!.data.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: state
                        .rideList!.data.length, // Replace with your actual data
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "ORDER ID: ${state.rideList!.data[index].orderId}",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0, vertical: 3.0),
                                        child: Text(
                                          state.rideList!.data[index].status,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                10.ph,
                                InkWell(
                                  onTap: () {
                                    Future.delayed(Duration.zero, () {
                                      if (state.rideList!.data[index].status !=
                                          'Created') {
                                        Navigator.pushReplacementNamed(
                                            context, NearToPickUp.routeName,
                                            arguments: {
                                              'ref_id': state.rideList!
                                                  .data[index].orderId,
                                              'apptype': 'cab'
                                            });
                                      } else {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          NewOrderScreen.routeName,
                                          arguments: {
                                            'orderId': state
                                                .rideList!.data[index].orderId,
                                            'apptype': 'cab'
                                          },
                                        );
                                      }
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
                                                          0xFF3574E0),
                                                    ),
                                                    child: Text(
                                                      ConvertText.getTitle(
                                                          'PICKUP LOCATION'),
                                                      style:
                                                          GoogleFonts.manrope(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      InkWell(
                                                        onTap: () async {
                                                          MapsLauncher
                                                              .launchQuery(state
                                                                  .rideList!
                                                                  .data[index]
                                                                  .pickupFrom);
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
                                                    ],
                                                  ),
                                                ],
                                              )),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: state.rideList!.data[index]
                                                        .pickupFrom ==
                                                    ''
                                                ? Text(
                                                    "Opposite Diamond Park, Dondaparthy, Dwaraka Nagar, Visakhapatnam, Andhra Pradesh 530016",
                                                    style: GoogleFonts.manrope(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ))
                                                : Text(
                                                    state.rideList!.data[index]
                                                        .pickupFrom,
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
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.60,
                                                      child: Text(
                                                          ConvertText.getTitle(
                                                              'DROP LOCATION'),
                                                          style: GoogleFonts.manrope(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: const Color(
                                                                  0xFFc245bd))),
                                                    ),
                                                  ])),
                                          state.rideList!.data[index]
                                                  .droppingLocations.isNotEmpty
                                              ? Column(
                                                  children: List.generate(
                                                      state
                                                          .rideList!
                                                          .data[index]
                                                          .droppingLocations
                                                          .length, (j) {
                                                  return SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    child: state
                                                                .rideList!
                                                                .data[index]
                                                                .droppingLocations[
                                                                    j]
                                                                .address ==
                                                            ''
                                                        ? Text(
                                                            'Bharath Towers, 405, 4th Floor, 5th Ln, DwarakaNagar, Visakhapatnam, AP 530016',
                                                            style: GoogleFonts
                                                                .manrope(
                                                                    fontSize:
                                                                        12,
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
                                                                      0.5,
                                                                  child: Text(
                                                                    state
                                                                        .rideList!
                                                                        .data[
                                                                            index]
                                                                        .droppingLocations[
                                                                            j]
                                                                        .address,
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
                                                                            .rideList!
                                                                            .data[index]
                                                                            .droppingLocations[j]
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
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                  );
                                                }))
                                              : SizedBox.shrink(),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })
                : Center(
                    child: Text("No Rides Found"),
                  );
          }
        }
        return SizedBox.shrink();
      },
    ));
  }
}
