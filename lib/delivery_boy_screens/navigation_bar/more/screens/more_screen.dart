import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart' as geo;
import 'package:shimmer/shimmer.dart';
import 'package:pure_o_fresh_rider_app/utility/common_text.dart';

import '../../../../commons/ConvertText.dart';
import '../../../../commons/shared_prefs.dart';
import '../../../../commons/show_chuk_notification.dart';
import '../../../../commons/url_links.dart';
import '../../../../location_service/logic/location_controller/location_controller_cubit.dart';
import '../../../../main.dart';
import '../../../../tools/background_service.dart';
import '../../../../utility/colors_data.dart';
import '../../../location_popup.dart';
import '../../../login/screens/welcome_screen.dart';
import '../../home/logic/bloc/dashboard_home_bloc.dart';

import '../../navigationbar_screen.dart';
import '../bank_details/screens/bank_details.dart';
import '../cms_screens/screens/cms_list_screen.dart';
import '../cod_cash/screens/cod_cash_screens.dart';
import '../code_wallet/screens/cod_wallet.dart';
import '../customer_tip/screen/customer_tips.dart';
import '../delete_account/logic/delete_acount_cubit.dart';
import '../payout_history/screens/payout_history_screen.dart';
import '../profile/screens/profile_screen.dart';
import '../ratings/screens/rating_screen.dart';
import '../refering_friend/screens/refer_your_friend.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final backgroundService = BackgroundService();
  DateTime? currentBackPressTime;

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
    super.initState();
    context.read<DashboardHomeBloc>().add(DashBoardDetailsFetchingEvent(
        accessToken: (Constants.prefs!.getString("token"))!));
    determinePosition();
  }

  Future<bool> onWillPop() {
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              BlocBuilder<DashboardHomeBloc, DashboardHomeState>(
                builder: (context, state) {
                  // if (state is DashboardHomeInitial) {
                  //   return const Center(child: CircularProgressIndicator());
                  // }
                  if (state is DashBoardDetailsLoadedState) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 12),
                      child: Row(
                        children: [
                          state.dashBoardDetailsModeldata.data.image == ''
                              ? CircleAvatar(
                                  radius: 30,
                                  backgroundColor: ColorsData.themeColor,
                                  child: const Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 30,
                                  backgroundColor: ColorsData.themeColor,
                                  backgroundImage: NetworkImage(state
                                      .dashBoardDetailsModeldata.data.image),
                                ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                state.dashBoardDetailsModeldata.data.name,
                                style: GoogleFonts.manrope(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "Pure O Fresh ID: ${state.dashBoardDetailsModeldata.data.flemid}",
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  }
                  return Shimmer.fromColors(
                      baseColor: Colors.grey.shade200,
                      highlightColor: Colors.white,
                      child: Container(
                        height: 20,
                        width: 80,
                        color: Colors.white,
                      ));
                },
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RatingScreen(),
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Expanded(
                        //   child: Text(
                        //     "Your Ratings",
                        //     style: GoogleFonts.manrope(
                        //         fontSize: 14, fontWeight: FontWeight.w500),
                        //   ),
                        // ),
                        CommonProximaNovaTextWidget(
                          text: "Your Ratings",
                          fontSize: 12,
                          color: ColorsData.blackColor,
                          fontWeight: FontWeight.w600,
                        ),
                        BlocBuilder<DashboardHomeBloc, DashboardHomeState>(
                          builder: (context, state) {
                            // if (state is DashboardHomeInitial) {
                            //   return const Center(
                            //       child: CircularProgressIndicator());
                            // }
                            if (state is DashBoardDetailsLoadedState) {
                              return RatingBarIndicator(
                                rating: double.parse(state
                                    .dashBoardDetailsModeldata.data.totalRating
                                    .toString()),
                                itemSize: 20,
                                unratedColor: Colors.grey.shade400,
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 1.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  // color: Color(0xFFfaff00),
                                  color: Color.fromARGB(255, 255, 210, 7),
                                ),
                              );
                            }
                            return Shimmer.fromColors(
                              baseColor: Colors.grey.shade200,
                              highlightColor: Colors.white,
                              child: Container(
                                height: 20,
                                width: 40,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),

                        // for (int i = 0; i < 5; i++)
                        //   Icon(
                        //     Icons.star,
                        //     size: 14,
                        //   )
                      ],
                    ),
                  ),
                ),
              ),
              ListView(
                padding: const EdgeInsets.all(0),
                // physics: BouncingScrollPhysics(),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: ListTile.divideTiles(
                    //          <-- ListTile.divideTiles
                    context: context,
                    tiles: [
                      ListTile(
                        dense: true,
                        title: CommonProximaNovaTextWidget(
                          text: "Profile",
                          fontSize: 14,
                          color: ColorsData.blackColor,
                          fontWeight: FontWeight.w600,
                        ),
                        subtitle: const CommonProximaNovaTextWidget(
                          text: "Details",
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfileScreen(),
                              ));
                        },
                      ),
                      // ListTile(
                      //   dense: true,
                      //   title:CommonProximaNovaTextWidget(
                      //     text: "Attendance Sheet",
                      //     fontSize: 14,
                      //     color: ColorsData.themeColor,
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      //   subtitle:const CommonProximaNovaTextWidget(
                      //     text: "Check In & Check Out",
                      //     fontSize: 12,
                      //     color: Colors.grey,
                      //     fontWeight: FontWeight.w400,
                      //   ) ,
                      //   trailing: const Icon(
                      //     Icons.arrow_forward_ios_rounded,
                      //     size: 18,
                      //   ),
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => const AttendenceSheetScreen(),
                      //         ));
                      //   },
                      // ),
                      // ListTile(
                      //   dense: true,
                      //   title: Text(
                      //     ConvertText.getTitle("Incentives"),
                      //     style: GoogleFonts.manrope(
                      //         fontSize: 15, fontWeight: FontWeight.w600),
                      //   ),
                      //   subtitle: Text(
                      //     ConvertText.getTitle("Business Timings"),
                      //     style: GoogleFonts.manrope(),
                      //   ),
                      //   trailing: const Icon(
                      //     Icons.arrow_forward_ios_rounded,
                      //     size: 18,
                      //   ),
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) =>
                      //               const IncentivesMoreScreen(),
                      //         ));
                      //   },
                      // ),

                      // ListTile(
                      //   dense: true,
                      //   title: CommonProximaNovaTextWidget(
                      //     text: "My Rides",
                      //     fontSize: 14,
                      //     color: ColorsData.themeColor,
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      //   subtitle: const CommonProximaNovaTextWidget(
                      //     text: "Rides List",
                      //     fontSize: 12,
                      //     color: Colors.grey,
                      //     fontWeight: FontWeight.w400,
                      //   ),
                      //   trailing: const Icon(
                      //     Icons.arrow_forward_ios_rounded,
                      //     size: 16,
                      //   ),
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) =>
                      //               const MyOrdersRidesScreen(),
                      //         ));
                      //   },
                      // ),
                      ListTile(
                        dense: true,
                        title: CommonProximaNovaTextWidget(
                          text: "COD Wallet",
                          fontSize: 14,
                          color: ColorsData.blackColor,
                          fontWeight: FontWeight.w600,
                        ),
                        subtitle: const CommonProximaNovaTextWidget(
                          text: "Cash On Delivery Wallet",
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CashOnDeliveryWallet(),
                              ));
                        },
                      ),
                      ListTile(
                        dense: true,
                        title: CommonProximaNovaTextWidget(
                          text: "Customer Tips",
                          fontSize: 14,
                          color: ColorsData.blackColor,
                          fontWeight: FontWeight.w600,
                        ),
                        subtitle: const CommonProximaNovaTextWidget(
                          text: "Tips",
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CustomerTips(),
                              ));
                        },
                      ),
                      // ListTile(
                      //   dense: true,
                      //   title: Text(
                      //     ConvertText.getTitle("Fines"),
                      //     style: GoogleFonts.manrope(
                      //         fontSize: 15, fontWeight: FontWeight.w600),
                      //   ),
                      //   subtitle: Text(
                      //     ConvertText.getTitle("Fines Amounts"),
                      //     style: GoogleFonts.manrope(),
                      //   ),
                      //   trailing: const Icon(
                      //     Icons.arrow_forward_ios_rounded,
                      //     size: 18,
                      //   ),
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => const FineScreen(),
                      //         ));
                      //   },
                      // ),

                      ListTile(
                        dense: true,
                        title: CommonProximaNovaTextWidget(
                          text: "Bank Details",
                          fontSize: 14,
                          color: ColorsData.blackColor,
                          fontWeight: FontWeight.w600,
                        ),
                        subtitle: const CommonProximaNovaTextWidget(
                          text: "Details",
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BankDetailsScreen(),
                              ));
                        },
                      ),
                      ListTile(
                        dense: true,
                        title: CommonProximaNovaTextWidget(
                          text: "COD Cash",
                          fontSize: 14,
                          color: ColorsData.blackColor,
                          fontWeight: FontWeight.w600,
                        ),
                        subtitle: const CommonProximaNovaTextWidget(
                          text: "Charges",
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CODCashScreen(),
                              ));
                        },
                      ),
                      ListTile(
                        dense: true,
                        title: CommonProximaNovaTextWidget(
                          text: "Payout History",
                          fontSize: 14,
                          color: ColorsData.blackColor,
                          fontWeight: FontWeight.w600,
                        ),
                        subtitle: const CommonProximaNovaTextWidget(
                          text: "Payments",
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PayoutHistoryScreen(),
                              ));
                        },
                      ),
                      // ListTile(
                      //   dense: true,
                      //   title: Text(
                      //     ConvertText.getTitle("Support"),
                      //     style: GoogleFonts.manrope(
                      //         fontSize: 15, fontWeight: FontWeight.w600),
                      //   ),
                      //   subtitle: Text(
                      //     ConvertText.getTitle("Issues and Support"),
                      //     style: GoogleFonts.manrope(),
                      //   ),
                      //   trailing: const Icon(
                      //     Icons.arrow_forward_ios_rounded,
                      //     size: 18,
                      //   ),
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) =>
                      //               const SupportandHelpScreen(isProfile: true,),
                      //         ));
                      //   },
                      // ),

                      ListTile(
                        dense: true,
                        title: CommonProximaNovaTextWidget(
                          text: "Refer a Friend",
                          fontSize: 14,
                          color: ColorsData.blackColor,
                          fontWeight: FontWeight.w600,
                        ),
                        subtitle: const CommonProximaNovaTextWidget(
                          text: "Refering",
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ReferYourFriend(),
                            ),
                          );
                        },
                      ),

                      ListTile(
                        dense: true,
                        title: CommonProximaNovaTextWidget(
                          text: "Settings",
                          fontSize: 14,
                          color: ColorsData.blackColor,
                          fontWeight: FontWeight.w600,
                        ),
                        subtitle: const CommonProximaNovaTextWidget(
                          text: "Preferences,Terms and Conditions, Policy, FAQ",
                          fontSize: 11,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                      ),
                      // ListTile(
                      //   dense: true,
                      //   title: Text(
                      //     ConvertText.getTitle("About Us"),
                      //     style: GoogleFonts.manrope(
                      //         fontSize: 15, fontWeight: FontWeight.w600),
                      //   ),
                      //   subtitle: Text(
                      //     ConvertText.getTitle("Terms & Conditions,Policy,Faq"),
                      //     style: GoogleFonts.manrope(),
                      //   ),
                      //   trailing: const Icon(
                      //     Icons.arrow_forward_ios_rounded,
                      //     size: 18,
                      //   ),
                      //   onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => const CMsScreen(),
                      //     ));
                      //   },
                      // ),
                      // ListTile(
                      //   dense: true,
                      //   title: Text(
                      //     ConvertText.getTitle("Change Language"),
                      //     style: GoogleFonts.manrope(
                      //         fontSize: 15, fontWeight: FontWeight.w600),
                      //   ),
                      //   // subtitle: Text(
                      //   //   "${Constants.prefs!.getString("selectedLanguage")}",
                      //   //   style: GoogleFonts.manrope(),
                      //   // ),
                      //   trailing: const Icon(
                      //     Icons.arrow_forward_ios_rounded,
                      //     size: 18,
                      //   ),
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => const SelectLanguageScreen(
                      //             type: 'language',
                      //           ),
                      //         ));
                      //   },
                      // ),

                      BlocListener<DeleteAcountCubit, DeleteAcountState>(
                        listener: (context, state) {
                          // TODO: implement listener
                          if (state is DeleteAcountSuccessState) {
                            print("account deleted successfully.");
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const WelcomeScreen()),
                                (route) => false);
                            // Navigator.pushReplac
                          }
                        },
                        child: ListTile(
                          dense: true,
                          title: CommonProximaNovaTextWidget(
                            text: "Delete Account",
                            fontSize: 14,
                            color: ColorsData.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 18,
                          ),
                          onTap: () {
                            var dialog = AlertDialog(
                              actionsPadding: const EdgeInsets.only(bottom: 16),
                              actionsAlignment: MainAxisAlignment.spaceEvenly,
                              title: CommonProximaNovaTextWidget(
                                text: ConvertText.getTitle("Account Deletion"),
                              ),
                              content: CommonProximaNovaTextWidget(
                                text: ConvertText.getTitle(
                                    "Following data will be deleted.Are you sure you want to delete account?\n"
                                    "delivery person  info"
                                    "\norders"
                                    "\npayouts"
                                    "\nyour wallet amount will be deleted."),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              actions: <Widget>[
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey.shade500),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(ConvertText.getTitle("No"))),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorsData.themeColor),
                                    onPressed: () {
                                      // need to impliment delete account api DeleteAcountCubit
                                      context
                                          .read<DeleteAcountCubit>()
                                          .deleteAcountApi()
                                          .whenComplete(() {
                                        Constants.prefs!.setString("token", "");
                                      });
                                    },
                                    child: Text(ConvertText.getTitle("Yes")))
                              ],
                            );
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => dialog);
                          },
                        ),
                      ),
                      BlocListener<DeleteAcountCubit, DeleteAcountState>(
                        listener: (context, state) {
                          if (state is DeleteAcountSuccessState) {
                            print("account logged out successfully");
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const WelcomeScreen()),
                                (route) => false);
                            // Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => WelcomeScreen(),
                            //     ));
                          }
                        },
                        child: ListTile(
                          dense: true,
                          title: CommonProximaNovaTextWidget(
                            text: "Logout",
                            fontSize: 14,
                            color: ColorsData.themeColor,
                            fontWeight: FontWeight.w600,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                          ),
                          onTap: () {
                            var dialog = AlertDialog(
                              actionsPadding: const EdgeInsets.only(bottom: 16),
                              actionsAlignment: MainAxisAlignment.spaceEvenly,
                              title: Text(
                                ConvertText.getTitle("Logout"),
                              ),
                              content: Text(
                                ConvertText.getTitle(
                                    "Are you sure, do you want to logout?"),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              actions: <Widget>[
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey.shade500),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(ConvertText.getTitle("No"))),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorsData.themeColor),
                                    onPressed: () async {

                                      final batteryPercentage = await battery.batteryLevel;
                                      debugPrint('current battery percentage: $batteryPercentage');

                                      context
                                          .read<DeleteAcountCubit>()
                                          .logoutApi()
                                          .whenComplete(() {
                                        final formData = FormData.fromMap({
                                          'access_token': Constants.prefs!
                                              .getString("token"),
                                          'is_online': Constants.prefs!.getBool("status"),
                                          'battery_percent': batteryPercentage
                                        });
                                        final dio = Dio();
                                        addChuck(dio);
                                        dio
                                            .post(
                                                "${UrlLinksData.serverUrl}Online_or_offline_status/update",
                                                data: formData)
                                            .then((value) {
                                          backgroundService.stopService();
                                        });

                                        context
                                            .read<LocationControllerCubit>()
                                            .stopLocationFetch();
                                        Constants.prefs!.setString("token", "");
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const WelcomeScreen(),
                                            ));
                                      });
                                    },
                                    child: Text(ConvertText.getTitle("Yes")))
                              ],
                            );
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => dialog);
                          },
                        ),
                      )
                    ]).toList(),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Version v${VersionNumber.displayVersion}",
                style: GoogleFonts.manrope(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
