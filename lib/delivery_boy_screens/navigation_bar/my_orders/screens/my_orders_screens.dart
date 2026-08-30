import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart' as geo;
import 'package:pure_o_fresh_rider_app/utility/widgets/theme_spinner.dart';

import '../../../../commons/ConvertText.dart';
import '../../../../utility/colors_data.dart';
import '../../../location_popup.dart';
import '../../home/notifications/logic/cubit/ongoing_rides_data_cubit.dart';
import '../../home/repository/dashboard_details_repository.dart';
import '../../more/cms_screens/logic/cubit/delivery_preferences_cubit.dart';
import '../../navigationbar_screen.dart';
import 'time_taps_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  DateTime? currentBackPressTime;
  Future<bool> onWillPop() {
    print("object");
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;

      // Fluttertoast.showToast(msg: 'Tap back again to leave');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomsNaviScreen(index: 0),
          ));

      return Future.value(false);
    }
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
    // Navigator.pop(context, true);
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }

  Future<Position> determinePosition() async {
    geo.Location location = geo.Location();

    bool serviceEnabled;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await location.requestService();
      if (!serviceEnabled) {
        await location.requestService();
        if (!serviceEnabled) {
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const LocationPopUp(gps: 'gps', screen: 'register'),
              ),
            );
          }
        }
      }
      return Future.error('Location services are disabled.');
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<DeliveryPreferencesCubit>().featchDeliveryType();
    determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: BlocBuilder<DeliveryPreferencesCubit, DeliveryPreferencesState>(
        builder: (context, deliveryPreferencesState) {
          if (deliveryPreferencesState.typeLoad) {
            return const ThemeSpinner();
          }
          if (deliveryPreferencesState.typeId != null) {
            if (deliveryPreferencesState.typeId == '1') {
              return DefaultTabController(
                length: 3,
                child: Scaffold(
                  appBar: AppBar(
                      elevation: 1,
                      backgroundColor: Colors.white,
                      // leading: null,
                      title: Text(
                        ConvertText.getTitle("My Order"),
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      bottom: TabBar(
                        isScrollable: true,
                        indicatorColor: ColorsData.themeColor,
                        tabAlignment: TabAlignment.center,
                        indicatorWeight: 4,
                        indicatorPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        labelColor: Colors.black,
                        labelStyle: GoogleFonts.manrope(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                        tabs: [
                          Tab(
                            child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.sizeOf(context).width * 0.12,
                                child: const Text("All")),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.sizeOf(context).width * 0.13,
                            child: const Tab(
                              child: Text("Food"),
                            ),
                          ),
                          // Container(
                          //   alignment: Alignment.center,
                          //   width: MediaQuery.sizeOf(context).width * 0.13,
                          //   child: const Tab(
                          //     child: Text("Rides"),
                          //   ),
                          // ),
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.sizeOf(context).width * 0.30,
                            child: const Tab(
                              child: Text("Pick And Drop"),
                            ),
                          ),
                        ],
                      )),
                  body: const TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      TimeTabsScreen(
                        searchType: 'all',
                      ),
                      TimeTabsScreen(
                        searchType: 'food',
                      ),
                      TimeTabsScreen(
                        searchType: 'pickanddrop',
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  elevation: 1,
                  backgroundColor: Colors.white,
                  // leading: null,
                  title: Text(
                    ConvertText.getTitle("My Order"),
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                body: const TimeTabsScreen(
                  searchType: 'all',
                ),
              );
            }
          } else {
            return const ThemeSpinner();
          }
        },
      ),
    );
  }
}
