// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart' as geo;
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/screens/commocoloo.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../commons/ConvertText.dart';
import '../../../../commons/shared_prefs.dart';
import '../../../../commons/show_chuk_notification.dart';
import '../../../../commons/url_links.dart';
import '../../../../location_service/logic/location_controller/location_controller_cubit.dart';
import '../../../../main.dart';
import '../../../../notification/controller/notification_controller.dart';
import '../../../../tools/background_service.dart';
import '../../../../utility/colors_data.dart';
import '../../../../utility/common_text.dart';
import '../../../location_popup.dart';
import '../../../login/screens/welcome_screen.dart';
import '../../../new_order/screens/near_to_pickup_location_screen.dart';
import '../../../new_order/screens/new_order_screen.dart';
import '../../../registration/registration_successful/screens/registration_successful_screen.dart';
import '../../../registration/select_city/screens/select_city_screen.dart';
import '../../../registration/select_language/logic/bloc/languages_bloc.dart';
import '../../../registration/select_vehicle/screens/select_vehicle_screen.dart';
import '../../../registration/verification_documents/screens/documents_verification_screen.dart';
import '../../more/cms_screens/screens/delivery_preferences.dart';
import '../../more/cod_cash/screens/cod_cash_screens.dart';
import '../../more/code_wallet/screens/cod_wallet.dart';
import '../../more/payout_history/screens/payout_history_screen.dart';
import '../../more/profile/screens/profile_screen.dart';
import '../../navigationbar_screen.dart';
import '../logic/bloc/dashboard_home_bloc.dart';
import '../notifications/logic/cubit/ongoing_rides_data_cubit.dart';
import '../notifications/screens/norifications_screen.dart';
import '../repository/dashboard_details_repository.dart';
import 'online_offline_screen.dart';
import 'widgets/home_quicklinks_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final backgroundService = BackgroundService();

  int activeIndex = 0;
  DateTime? currentBackPressTime;
  bool? onlineOfflineStatus = false;

  late DashboardHomeBloc dashboardHomeBloc;
  //late OrdersListBloc ordersListBloc;
  late OngoingRidesDataCubit _ongoingRidesDataCubit;
  bool permissionSetted = false;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Tap back again to leave');
      return Future.value(false);
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }

  @override
  void didChangeDependencies() async {
    checkIfLocationPermissionDenied().then((isDenied) {
      if (mounted) {
        setState(() {
          permissionSetted = isDenied;
        });
      }
    });
    context.read<LocationControllerCubit>().locationFetchByDeviceGPS();

    dashboardHomeBloc = DashboardHomeBloc(
        dashBoardDetailsReposotory: DashBoardDetailsReposotory());

    // ordersListBloc = OrdersListBloc(
    //     dashBoardDetailsReposotory: DashBoardDetailsReposotory());

    _ongoingRidesDataCubit =
        OngoingRidesDataCubit(DashBoardDetailsReposotory());

    if (mounted) {
      Future.delayed(Duration.zero, () async {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        final deviceId = androidInfo.id;
        // await NotificationController.startListeningNotificationEvents();
        await NotificationController.requestFirebaseToken().then((token) {
          dashboardHomeBloc.add(UpdatingFirebaseKeyEvent(
            pushNotificationFireKey: token,
            accessToken: (Constants.prefs!.getString("token"))!,
            deviceId: deviceId,
          ));
        });
        await onlineOfflineapi();
        await _determinePosition().then((value) {
          dashboardHomeBloc.add(BackgroundLoactionEvent(
              accessToken: (Constants.prefs!.getString("token"))!,
              latitude: value.latitude.toString(),
              longitude: value.longitude.toString()));
          // ordersListBloc.add(OrdersListFetchingEvent(
          //     latitude: value.latitude.toString(),
          //     longitude: value.longitude.toString()));
          // ongoingRidesDataCubit.fetchOngoingRides('cab');
          // ongoingRidesDataCubit.fetchOngoingRides('pickupanddrop');
          _ongoingRidesDataCubit.fetchDeliveryServices();
          _ongoingRidesDataCubit.fetchSingleOrderData(isLoading: true);
        });
      });
    }
    dashboardHomeBloc.add(DashBoardDetailsFetchingEvent(
        accessToken: (Constants.prefs!.getString("token"))!));
    context.read<LanguagesBloc>().add(ContinueButtonClicked(
        selectedLanguage:
            Constants.prefs!.getString('selectedLanguage') ?? "English"));
    //We can listen to the isolate from the application
    FlutterBackgroundService().on('on_location_changed').listen((event) {});
    onlineOfflineStatus = Constants.prefs!.getBool("status");
    super.didChangeDependencies();
  }

  Future<void> deniedUpdate() async {
    if (permissionSetted == true) {

      final batteryPercentage = await battery.batteryLevel;
      debugPrint('current battery percentage: $batteryPercentage');

      final formData = FormData.fromMap({
        'access_token': Constants.prefs!.getString("token"),
        'is_online': Constants.prefs!.getBool("status"),
        'battery_percent': batteryPercentage
      });
      final dio = Dio();
      addChuck(dio);
      final response = await dio.post(
          "${UrlLinksData.serverUrl}Online_or_offline_status/update",
          data: formData);
    }
  }

  Future<bool> checkIfLocationPermissionDenied() async {
    LocationPermission permission = await Geolocator.checkPermission();

    return permission != LocationPermission.always;
  }

  Future<void> onlineOfflineapi() async {
    await deniedUpdate();
    final formData = FormData.fromMap({
      'access_token': Constants.prefs!.getString("token"),
    });
    final dio = Dio();
    addChuck(dio);
    final response = await dio.post(
        "${UrlLinksData.serverUrl}Online_or_offline_status",
        data: formData);

    if (response.data['err_code'] == 'valid') {
      await Constants.prefs!.setBool("status", response.data['data']);
      if (mounted) {
        setState(() {
          onlineOfflineStatus = response.data['data'];
        });
      }

      if (response.data['data'] == true) {
        if (mounted) {
          await context
              .read<LocationControllerCubit>()
              .locationFetchByDeviceGPS();
        }

        await backgroundService.initializeService();
      }
      if (response.data['data'] == false) {
        backgroundService.stopService();
        if (mounted) {
          context.read<LocationControllerCubit>().stopLocationFetch();
        }
      }
    } else if (response.data['err_code'] == 'invalid') {
      await Constants.prefs!.clear();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const WelcomeScreen(),
          ));
    }
  }

  Future<void> onlineOfflineUpdateapi(bool status) async {
    // if (permissionSetted != 'denied') {
    final batteryPercentage = await battery.batteryLevel;
    debugPrint('current battery percentage: $batteryPercentage');

    final formData = FormData.fromMap({
      'access_token': Constants.prefs!.getString("token"),
      'is_online': permissionSetted != true ? status : false,
      'battery_percent': batteryPercentage
    });
    final dio = Dio();
    addChuck(dio);
    final response = await dio.post(
        "${UrlLinksData.serverUrl}Online_or_offline_status/update",
        data: formData);

    if (response.data['err_code'] == 'valid') {
      await Constants.prefs!.setBool("status", response.data['data']);
      if (mounted) {
        setState(() {
          onlineOfflineStatus = response.data['data'];
        });
      }

      if (response.data['data'] == true) {
        //initialize the background service and start service as foreground
        if (mounted) {
          await context
              .read<LocationControllerCubit>()
              .locationFetchByDeviceGPS();
        }

        await backgroundService.initializeService();

        Fluttertoast.showToast(
          msg: "Wait for a while, Initializing the service...",
        );
      } else {
        //stop background service
        backgroundService.stopService();

        if (mounted) {
          await context
              .read<LocationControllerCubit>()
              .stopLocationFetch()
              .whenComplete(() {
            // Fluttertoast.showToast(
            //     msg: response.data['message'], backgroundColor: Colors.red);
          });
        }
      }
    }

    if (mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const BottomsNaviScreen(index: 0)),
          (route) => false);
    }
    // }
  }
  // Future<void> onlineOfflineUpdateapi(bool status) async {
  //   final formData = FormData.fromMap({
  //     'access_token': Constants.prefs!.getString("token"),
  //     'is_online': status,
  //   });
  //   final dio = Dio();
  //   final response = await dio
  //       .post("${UrlLinksData.serverUrl}Online_or_offline_status/update",
  //           data: formData)
  //       .whenComplete(() async {
  //     // await _determinePosition().then((value) {
  //     //   dashboardHomeBloc.add(BackgroundLoactionEvent(
  //     //       accessToken: (Constants.prefs!.getString("token"))!,
  //     //       latitude: value.latitude.toString(),
  //     //       longitude: value.longitude.toString()));

  //     //   ordersListBloc.add(OrdersListFetchingEvent(
  //     //       latitude: value.latitude.toString(),
  //     //       longitude: value.longitude.toString()));
  //     // });

  //     // dashboardHomeBloc.add(DashBoardDetailsFetchingEvent(
  //     //     accessToken: (Constants.prefs!.getString("token"))!));
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => const BottomsNaviScreen(index: 0)),
  //         (route) => false);
  //   });
  //   if (response.data['err_code'] == 'valid') {
  //     await Constants.prefs!.setBool("status", response.data['data']);
  //     if (mounted) {
  //       setState(() {
  //         onlineOfflineStatus = response.data['data'];
  //       });
  //     }

  //     if (response.data['data'] == true) {
  //       //initialize the background service and start service as foreground
  //       if (mounted) {
  //         await context
  //             .read<LocationControllerCubit>()
  //             .locationFetchByDeviceGPS();
  //       }

  //       await backgroundService.initializeService();

  //       Fluttertoast.showToast(
  //         msg: "Wait for a while, Initializing the service...",
  //       );
  //     } else {
  //       //stop background service
  //       backgroundService.stopService();

  //       await context
  //           .read<LocationControllerCubit>()
  //           .stopLocationFetch()
  //           .whenComplete(() {
  //         // Fluttertoast.showToast(
  //         //     msg: response.data['message'], backgroundColor: Colors.red);
  //       });
  //     }
  //   }
  // }

  Future<Position> _determinePosition() async {
    geo.Location location = geo.Location();
    // if (Constants.prefs!.getString("bglocation") != 'agree') {
    //   print("HERE NOT AGREE");
    //   return Future.error('User did not agree to share location.');
    // }
    print("HERE NOT AGREE DATA");
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (Constants.prefs!.getString("bglocation") == 'agree') {
        await location.requestService();
      }

      if (!serviceEnabled) {
        if (Constants.prefs!.getString("bglocation") == 'agree') {
          await location.requestService();
        }
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

      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      Constants.prefs!.setString("permission", 'denied');
      if (permissionSetted == false) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        Constants.prefs!.setString("permission", 'denied');
        setState(() {
          permissionSetted = true;
        });
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        permissionSetted = true;
      });
      Constants.prefs!.setString("permission", 'denied');
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    setState(() {
      permissionSetted = false;
    });
    Constants.prefs!.setString("bglocation", 'agree');
    Constants.prefs!.setString("permission", 'allow');
    return await Geolocator.getCurrentPosition();
  }

  Future<Position> _determinePositionOld() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return Geolocator.getCurrentPosition();
  }

  final int _selectedIndex = 0;

  @override
  void dispose() {
    _ongoingRidesDataCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: dashboardHomeBloc),
          // BlocProvider.value(value: ordersListBloc),
          BlocProvider.value(value: _ongoingRidesDataCubit),
        ],
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            titleSpacing: 0.5,
            leading: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<DashboardHomeBloc, DashboardHomeState>(
                  builder: (context, state) {
                    if (state is DashboardLoadingState) {
                      return Shimmer.fromColors(
                          baseColor: Colors.grey.shade200,
                          highlightColor: Colors.white,
                          child: const CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 130, 13, 13),
                          ));
                    } else if (state is DashBoardDetailsLoadedState) {
                      if (state.dashBoardDetailsModeldata.data.image == '') {
                        return CircleAvatar(
                          // radius: 30,
                          backgroundColor: ColorsData.themeColor,
                          child: const Icon(
                            Icons.person,
                            // size: 30,
                            color: Colors.white,
                          ),
                        );
                      } else {
                        return CircleAvatar(
                          backgroundColor: ColorsData.themeColor,
                          backgroundImage: NetworkImage(
                              state.dashBoardDetailsModeldata.data.image),
                        );
                      }
                    } else {
                      return const Text('Hellooooo');
                    }
                  },
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CommonProximaNovaTextWidget(
                  text: 'Welcome',
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                BlocBuilder<DashboardHomeBloc, DashboardHomeState>(
                  builder: (context, state) {
                    if (state is DashBoardDetailsLoadedState) {
                      return CommonProximaNovaTextWidget(
                        text: state.dashBoardDetailsModeldata.data.name,
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      );
                    }
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.white,
                      child: Container(
                        height: 20,
                        width: 60,
                        color: Colors.white30,
                      ),
                    );
                  },
                )
              ],
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Notifications(),
                      ));
                },
                child: BlocBuilder<DashboardHomeBloc, DashboardHomeState>(
                  builder: (context, state) {
                    if (state is DashBoardDetailsLoadedState) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 13.0, horizontal: 4),
                        child: (state.dashBoardDetailsModeldata.data
                                    .notificationCount !=
                                '0')
                            ? Badge(
                                label: Text(state.dashBoardDetailsModeldata.data
                                    .notificationCount),
                                child: Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: Image.asset(
                                    'assets/images/noti.png',
                                    height: 40,
                                    width: 20,
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(0),
                                child: Image.asset(
                                  'assets/images/noti.png',
                                  height: 40,
                                  width: 20,
                                ),
                              ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(0),
                      child: Image.asset(
                        'assets/images/noti.png',
                        height: 40,
                        width: 20,
                      ),
                    );
                  },
                ),
              ),
              BlocBuilder<DashboardHomeBloc, DashboardHomeState>(
                builder: (context, state) {
                  if (state is DashBoardDetailsLoadedState) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 13),
                        child: OnlineOflineStatus(
                            status: onlineOfflineStatus == true
                                ? "Online"
                                : "Offline",
                            SwitchFun:
                                // state.dashBoardDetailsModeldata
                                //                 .checkinStatus ==
                                //             true &&
                                state.dashBoardDetailsModeldata.data
                                            .verificationStatus ==
                                        true
                                    ? () async {
                                        if (permissionSetted != true) {
                                          if (mounted) {
                                            setState(() {
                                              onlineOfflineStatus =
                                                  !onlineOfflineStatus!;
                                            });
                                          }
                                          await _determinePosition();

                                          onlineOfflineUpdateapi(
                                              onlineOfflineStatus!);
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Please allow the location permission");
                                        }
                                      }
                                    :
                                    //  state.dashBoardDetailsModeldata
                                    //             .checkinStatus ==
                                    //         false
                                    //     ? () {
                                    //         Fluttertoast.showToast(
                                    //             msg:
                                    //                 "Documents details or Approval or Check-In pending");
                                    //       }
                                    //     :
                                    state.dashBoardDetailsModeldata.data
                                                    .verificationStatus ==
                                                false &&
                                            state.dashBoardDetailsModeldata.data
                                                    .verificationDetails ==
                                                false
                                        ? () {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Please complete your registration steps");
                                          }
                                        : state.dashBoardDetailsModeldata.data
                                                        .verificationStatus ==
                                                    false &&
                                                state
                                                        .dashBoardDetailsModeldata
                                                        .data
                                                        .verificationDetails ==
                                                    true
                                            ? () {
                                                dashboardHomeBloc.add(
                                                    DashBoardDetailsFetchingEvent(
                                                        accessToken: (Constants
                                                            .prefs!
                                                            .getString(
                                                                "token"))!));
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Please wait for approval from our team");
                                              }
                                            : () {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Please do check in..!");
                                              }));
                  }
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white30,
                            borderRadius: BorderRadius.circular(12)),
                        height: 10,
                        width: 80,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          //7658900605
          body: RefreshIndicator(
            onRefresh: () async {
              print("datatata");
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BottomsNaviScreen(index: 0)),
                  (route) => false);
              context.read<DashboardHomeBloc>().add(
                  DashBoardDetailsFetchingEvent(
                      accessToken: (Constants.prefs!.getString("token"))!));

              await _determinePosition().then(
                (value) {
                  dashboardHomeBloc.add(BackgroundLoactionEvent(
                      accessToken: (Constants.prefs!.getString("token"))!,
                      latitude: value.latitude.toString(),
                      longitude: value.longitude.toString()));
                  _ongoingRidesDataCubit.fetchDeliveryServices();
                  //context.read<AllOngoingListCubit>().fetchSingleOrderList();

                  // ordersListBloc.add(OrdersListFetchingEvent(
                  //     latitude: value.latitude.toString(),
                  //     longitude: value.longitude.toString()));

                  // ongoingRidesDataCubit.fetchOngoingRides('cab');
                  // ongoingRidesDataCubit.fetchOngoingRides('pickupanddrop');
                },
              );
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (permissionSetted == true)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                            color: Color(0xfffecccb),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(60, 116, 116, 116),
                                blurRadius: 4,
                                offset: Offset(0, 0),
                                spreadRadius: 0,
                              )
                            ],
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.75,
                              child: CommonProximaNovaTextWidget(
                                  text:
                                      'This app collects the device background location to give the nearby orders. Please allow location permission'),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LocationPopUp(),
                                      ));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: ColorsData.themeColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: EdgeInsets.all(5),
                                  child: Icon(Icons.navigation,
                                      color: Colors.white),
                                ))
                          ],
                        ),
                      ),

                    BlocBuilder<DashboardHomeBloc, DashboardHomeState>(
                      builder: (context, state) {
                        if (state is DashBoardDetailsLoadedState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Visibility(
                              //   visible: !state.dashBoardDetailsModeldata.data
                              //           .verificationDetails ==
                              //       false,
                              //   child: ElevatedButton(
                              //       onPressed: () {
                              //         if (!state.dashBoardDetailsModeldata.data
                              //             .vehicleDetails) {
                              //           Navigator.push(
                              //               context,
                              //               MaterialPageRoute(
                              //                 builder: (context) =>
                              //                     const SelectVehicleScreen(),
                              //               ));
                              //         } else if (!state
                              //             .dashBoardDetailsModeldata
                              //             .data
                              //             .locationDetails) {
                              //           Navigator.push(
                              //               context,
                              //               MaterialPageRoute(
                              //                 builder: (context) =>
                              //                     const SelectCityScreen(),
                              //               ));
                              //         } else if (!state
                              //             .dashBoardDetailsModeldata
                              //             .data
                              //             .verificationDetails) {
                              //           Navigator.push(
                              //               context,
                              //               MaterialPageRoute(
                              //                 builder: (context) =>
                              //                     const DocumentVerificationScreen(),
                              //               ));
                              //         } else {
                              //           Fluttertoast.showToast(
                              //               msg:
                              //                   "Our team will approve your details soon..");
                              //         }
                              //       },
                              //       child: Text(
                              //         "Click here to complete your profile !",
                              //         style: GoogleFonts.manrope(
                              //             fontWeight: FontWeight.bold,
                              //             fontSize: 12,
                              //             color: Colors.white),
                              //       )),
                              // ),
                              12.ph,
                              Visibility(
                                visible: !state.dashBoardDetailsModeldata.data
                                    .verificationStatus,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey[200],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      state.dashBoardDetailsModeldata.data
                                                  .verificationDetails ==
                                              false
                                          ? const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CommonProximaNovaTextWidget(
                                                  text:
                                                      'Your Profile is Under verification!',
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                CommonProximaNovaTextWidget(
                                                  text:
                                                      'Once Todayneeds deliveryboy verifies you can start orders',
                                                  color: Colors.black,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ],
                                            )
                                          : state.dashBoardDetailsModeldata.data
                                                      .verificationDetails ==
                                                  true
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      ConvertText.getTitle(
                                                          "Your details are updated"),
                                                      style:
                                                          GoogleFonts.manrope(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    Text(
                                                      ConvertText.getTitle(
                                                          "Please Wait for Approval"),
                                                      style:
                                                          GoogleFonts.manrope(
                                                        color: Colors.black87,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox.shrink(),
                                      InkWell(
                                        onTap: () {
                                          if (!state.dashBoardDetailsModeldata
                                              .data.vehicleDetails) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SelectVehicleScreen(),
                                                ));
                                          } else if (!state
                                              .dashBoardDetailsModeldata
                                              .data
                                              .locationDetails) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SelectCityScreen(),
                                                ));
                                          } else if (!state
                                              .dashBoardDetailsModeldata
                                              .data
                                              .verificationDetails) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const DocumentVerificationScreen(),
                                                ));
                                          } else if (!state
                                              .dashBoardDetailsModeldata
                                              .data
                                              .deliveryPreferncesStatus) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const DeliveryPreferencesScreen(
                                                  isFromProfile: true,
                                                ),
                                              ),
                                            );
                                          } else if (state
                                                      .dashBoardDetailsModeldata
                                                      .data
                                                      .verificationDetails ==
                                                  true &&
                                              state
                                                      .dashBoardDetailsModeldata
                                                      .data
                                                      .verificationStatus ==
                                                  false) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Our team will approve your details soon...Plz wait");
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const RegistrationSuccessScreen(),
                                                ),
                                                (route) => false);
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Our team will approve your details soon..if already approved Please do login again");
                                          }
                                        },
                                        // onTap: state.dashBoardDetailsModeldata
                                        //         .data.verificationDetails
                                        //     ? () {
                                        //         Navigator.push(
                                        //             context,
                                        //             MaterialPageRoute(
                                        //               builder: (context) =>
                                        //                   const AttendenceSheetScreen(),
                                        //             ));
                                        //       }
                                        //     : () {
                                        //         Fluttertoast.showToast(
                                        //             msg:
                                        //                 "Please First complete registration steps");
                                        //       },
                                        child: CircleAvatar(
                                          radius: 18,
                                          backgroundColor:
                                              ColorsData.themeColor,
                                          child: Image.asset(
                                            'assets/images/arrows.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return Center(
                          child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.white,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white30,
                                    borderRadius: BorderRadius.circular(10)),
                                height: 60,
                                width: MediaQuery.of(context).size.width * 0.9,
                              )),
                        );
                      },
                    ),

                    BlocBuilder<OngoingRidesDataCubit, OngoingRidesDataState>(
                      builder: (context, ongoingRidesDataState) {
                        if (ongoingRidesDataState.singleOrderdataLoading) {
                          return Center(
                            child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.white,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white30,
                                      borderRadius: BorderRadius.circular(10)),
                                  height: 100,
                                  width: 380,
                                )),
                          );
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                visible: onlineOfflineStatus != null
                                    ? onlineOfflineStatus!
                                    : false,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Visibility(
                                        visible: ongoingRidesDataState
                                            .singleOngoingOrderModel
                                            .data
                                            .isNotEmpty,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                ConvertText.getTitle(
                                                    "Need to deliver Orders"),
                                                style: GoogleFonts.manrope(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                            4.ph,
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              height: 115,
                                              width: MediaQuery.sizeOf(context)
                                                  .width,
                                              decoration: BoxDecoration(
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      offset: Offset(0, 0),
                                                      blurRadius: 2,
                                                      color: Color.fromARGB(
                                                          85, 0, 0, 0),
                                                    )
                                                  ],
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: ListView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: ongoingRidesDataState
                                                    .singleOngoingOrderModel
                                                    .data
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  final data =
                                                      ongoingRidesDataState
                                                          .singleOngoingOrderModel
                                                          .data;
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        _ongoingRidesDataCubit
                                                            .stopTimer();
                                                        if (data[index].type ==
                                                            'food') {
                                                          if (data[index]
                                                                  .status ==
                                                              "Waiting For Pickup") {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        NearToPickUp(
                                                                  refId: data[
                                                                          index]
                                                                      .orderId,
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                          if (data[index]
                                                                  .status ==
                                                              "Ready To Pickup") {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        NearToPickUp(
                                                                  refId: data[
                                                                          index]
                                                                      .orderId,
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                          if (data[index]
                                                                  .status ==
                                                              "Pickedup") {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          NearToPickUp(
                                                                    refId: data[
                                                                            index]
                                                                        .orderId,
                                                                  ),
                                                                ));
                                                          }
                                                          if (data[index]
                                                                  .status ==
                                                              "Reached Delivery") {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          NearToPickUp(
                                                                    refId: data[
                                                                            index]
                                                                        .orderId,
                                                                  ),
                                                                ));
                                                          }
                                                          if (data[index]
                                                                  .status ==
                                                              "Out For Delivery") {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          NearToPickUp(
                                                                    refId: data[
                                                                            index]
                                                                        .orderId,
                                                                  ),
                                                                ));
                                                          }
                                                        } else {
                                                          Future.delayed(
                                                              Duration.zero,
                                                              () {
                                                            if (data[index]
                                                                    .status !=
                                                                'Created') {
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  NearToPickUp
                                                                      .routeName,
                                                                  arguments: {
                                                                    'ref_id': data[
                                                                            index]
                                                                        .orderId,
                                                                    'apptype':
                                                                        data[index]
                                                                            .type
                                                                  });
                                                            } else {
                                                              Navigator
                                                                  .pushNamed(
                                                                context,
                                                                NewOrderScreen
                                                                    .routeName,
                                                                arguments: {
                                                                  'orderId': data[
                                                                          index]
                                                                      .orderId,
                                                                  'apptype':
                                                                      data[index]
                                                                          .type
                                                                },
                                                              );
                                                            }
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 12,
                                                                bottom: 10),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                "Order Type: ${data[index].type}",
                                                                style: GoogleFonts.manrope(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                            2.ph,
                                                            Text(
                                                                "OrderId: ${data[index].orderId}",
                                                                style: GoogleFonts.manrope(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                            2.ph,
                                                            Row(
                                                              children: [
                                                                Text(
                                                                    "${ConvertText.getTitle("Status")}: ",
                                                                    style: GoogleFonts.manrope(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: Colors
                                                                            .black)),
                                                                Text(
                                                                    data[
                                                                            index]
                                                                        .status,
                                                                    style: GoogleFonts.manrope(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            12,
                                                                            134,
                                                                            16))),
                                                              ],
                                                            ),
                                                            if (data[index]
                                                                    .serviceDateTime !=
                                                                '')
                                                              2.ph,
                                                            if (data[index]
                                                                    .serviceDateTime !=
                                                                '')
                                                              Text(
                                                                  "${ConvertText.getTitle("Date & Time")}: ${data[index].serviceDateTime}",
                                                                  style: GoogleFonts.manrope(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600)),
                                                            if (data[index]
                                                                    .grandTotal !=
                                                                '')
                                                              2.ph,
                                                            if (data[index]
                                                                    .grandTotal !=
                                                                '')
                                                              Text(
                                                                  ConvertText
                                                                      .getTitle(
                                                                          'Grand Total :${data[index].grandTotal}'),
                                                                  style: GoogleFonts
                                                                      .manrope(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  )),
                                                            if (data[index]
                                                                    .droppingDistance !=
                                                                '')
                                                              2.ph,
                                                            if (data[index]
                                                                    .droppingDistance !=
                                                                '')
                                                              Text(
                                                                  ConvertText
                                                                      .getTitle(
                                                                          'Distance :${data[index].droppingDistance}KMs'),
                                                                  style: GoogleFonts
                                                                      .manrope(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ))
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: ongoingRidesDataState
                                            .singleOngoingOrderModel
                                            .data
                                            .isEmpty,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Align(
                                                alignment: Alignment.center,
                                                child: Image.asset(
                                                  "assets/images/New Order.png",
                                                  height: 65,
                                                ),
                                              ),
                                              10.ph,
                                              Text(
                                                  ConvertText.getTitle(
                                                      "Waiting for Orders..."),
                                                  style: GoogleFonts.manrope(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]),
                              ),
                            ],
                          );
                        }
                      },
                    ),

                    //           // Visibility(
                    //           //   visible: onlineOfflineStatus != null
                    //           //       ? onlineOfflineStatus!
                    //           //       : false,
                    //           //   child: Container(
                    //           //     constraints: BoxConstraints(
                    //           //         maxWidth:
                    //           //             MediaQuery.of(context).size.width),
                    //           //     child: Row(
                    //           //       mainAxisAlignment:
                    //           //           MainAxisAlignment.spaceEvenly,
                    //           //       children: [
                    //           //         Visibility(
                    //           //           visible: check.isFood,
                    //           //           child: ElevatedButton(
                    //           //             onPressed: () {
                    //           //               if (mounted) {
                    //           //                 setState(() {
                    //           //                   _selectedIndex = 0;
                    //           //                 });
                    //           //               }
                    //           //             },
                    //           //             style: ElevatedButton.styleFrom(
                    //           //               elevation: 0,
                    //           //               backgroundColor: _selectedIndex == 0
                    //           //                   ? Colors.black
                    //           //                   : Colors.grey.shade400,
                    //           //               shape: RoundedRectangleBorder(
                    //           //                 borderRadius: BorderRadius.circular(
                    //           //                     18), // Adjust the radius as needed
                    //           //               ),
                    //           //             ),
                    //           //             child: const Text.rich(
                    //           //               TextSpan(
                    //           //                 children: [
                    //           //                   TextSpan(
                    //           //                     text: ' Food Orders',
                    //           //                     style: TextStyle(
                    //           //                       fontSize: 12,
                    //           //                       fontWeight: FontWeight.bold,
                    //           //                       color: Colors.white,
                    //           //                       fontFamily: 'ProximaNova',
                    //           //                     ),
                    //           //                   ),
                    //           //                   WidgetSpan(
                    //           //                     child: Icon(
                    //           //                       Icons
                    //           //                           .refresh, // Change this to the icon you want
                    //           //                       size:
                    //           //                           15, // Adjust the size of the icon as needed
                    //           //                       color: Colors
                    //           //                           .white, // Adjust the color of the icon as needed
                    //           //                     ),
                    //           //                   ),
                    //           //                 ],
                    //           //               ),
                    //           //             ),
                    //           //           ),
                    //           //         ),
                    //           //         Visibility(
                    //           //           visible: check.isCab,
                    //           //           child: ElevatedButton(
                    //           //             onPressed: () {
                    //           //               ongoingRidesDataCubit
                    //           //                   .fetchOngoingRides('cab');

                    //           //               if (mounted) {
                    //           //                 setState(() {
                    //           //                   _selectedIndex = 1;
                    //           //                 });
                    //           //               }
                    //           //             },
                    //           //             style: ElevatedButton.styleFrom(
                    //           //               elevation: 0,
                    //           //               backgroundColor: _selectedIndex == 1
                    //           //                   ? Colors.black
                    //           //                   : Colors.grey.shade400,
                    //           //               shape: RoundedRectangleBorder(
                    //           //                 borderRadius: BorderRadius.circular(
                    //           //                     18), // Adjust the radius as needed
                    //           //               ),
                    //           //             ),
                    //           //             child: const Text.rich(
                    //           //               TextSpan(
                    //           //                 children: [
                    //           //                   TextSpan(
                    //           //                     text: 'Rides',
                    //           //                     style: TextStyle(
                    //           //                       fontSize: 12,
                    //           //                       fontWeight: FontWeight.bold,
                    //           //                       color: Colors.white,
                    //           //                       fontFamily: 'ProximaNova',
                    //           //                     ),
                    //           //                   ),
                    //           //                   WidgetSpan(
                    //           //                     child: Icon(
                    //           //                       Icons
                    //           //                           .refresh, // Change this to the icon you want
                    //           //                       size:
                    //           //                           15, // Adjust the size of the icon as needed
                    //           //                       color: Colors
                    //           //                           .white, // Adjust the color of the icon as needed
                    //           //                     ),
                    //           //                   ),
                    //           //                 ],
                    //           //               ),
                    //           //             ),
                    //           //           ),
                    //           //         ),
                    //           //         // Text(check.isPickupAndDrop.toString()),
                    //           //         Visibility(
                    //           //           visible: check.isPickupAndDrop,
                    //           //           child: ElevatedButton(
                    //           //             onPressed: () {
                    //           //               ongoingRidesDataCubit
                    //           //                   .fetchOngoingRides(
                    //           //                       'pickupanddrop');
                    //           //               if (mounted) {
                    //           //                 setState(() {
                    //           //                   _selectedIndex = 2;
                    //           //                 });
                    //           //               }
                    //           //             },
                    //           //             style: ElevatedButton.styleFrom(
                    //           //               elevation: 0,
                    //           //               backgroundColor: _selectedIndex == 2
                    //           //                   ? Colors.black
                    //           //                   : Colors.grey.shade400,
                    //           //               shape: RoundedRectangleBorder(
                    //           //                 borderRadius: BorderRadius.circular(
                    //           //                     18), // Adjust the radius as needed
                    //           //               ),
                    //           //             ),
                    //           //             child: const Text.rich(
                    //           //               TextSpan(
                    //           //                 children: [
                    //           //                   TextSpan(
                    //           //                     text: 'Pick And Drop',
                    //           //                     style: TextStyle(
                    //           //                       fontSize: 12,
                    //           //                       fontWeight: FontWeight.bold,
                    //           //                       color: Colors.white,
                    //           //                       fontFamily: 'ProximaNova',
                    //           //                     ),
                    //           //                   ),
                    //           //                   WidgetSpan(
                    //           //                     child: Icon(
                    //           //                       Icons
                    //           //                           .refresh, // Change this to the icon you want
                    //           //                       size:
                    //           //                           15, // Adjust the size of the icon as needed
                    //           //                       color: Colors
                    //           //                           .white, // Adjust the color of the icon as needed
                    //           //                     ),
                    //           //                   ),
                    //           //                 ],
                    //           //               ),
                    //           //             ),
                    //           //           ),
                    //           //         ),
                    //           //       ],
                    //           //     ),
                    //           //   ),
                    //           // ),
                    //           // const SizedBox(height: 20),
                    //           // Visibility(
                    //           //   visible: check.isFood,
                    //           //   child:
                    //           // Visibility(
                    //           //   visible: _selectedIndex == 0,
                    //           //   child:
                    //           // Visibility(
                    //           //   visible: onlineOfflineStatus != null
                    //           //       ? onlineOfflineStatus!
                    //           //       : false,
                    //           //   child: BlocBuilder<OrdersListBloc,
                    //           //       OrdersListState>(
                    //           //     builder: (context, state) {
                    //           //       if (state is MyOrdersListListLoadedState) {
                    //           //         return Column(
                    //           //           crossAxisAlignment:
                    //           //               CrossAxisAlignment.start,
                    //           //           children: [
                    //           //             Visibility(
                    //           //               visible: state
                    //           //                   .myOrdersListDashBoardModeldata
                    //           //                   .data
                    //           //                   .results
                    //           //                   .isEmpty,
                    //           //               child: Align(
                    //           //                 alignment: Alignment.center,
                    //           //                 child: Column(
                    //           //                   mainAxisSize: MainAxisSize.min,
                    //           //                   children: [
                    //           //                     Align(
                    //           //                       alignment: Alignment.center,
                    //           //                       child: Image.asset(
                    //           //                         "assets/images/New Order.png",
                    //           //                         height: 65,
                    //           //                       ),
                    //           //                     ),
                    //           //                     10.ph,
                    //           //                     Text(
                    //           //                         ConvertText.getTitle(
                    //           //                             "Waiting for Orders..."),
                    //           //                         style:
                    //           //                             GoogleFonts.manrope(
                    //           //                           color: Colors.black,
                    //           //                           fontSize: 12,
                    //           //                           fontWeight:
                    //           //                               FontWeight.w500,
                    //           //                         )),
                    //           //                   ],
                    //           //                 ),
                    //           //               ),
                    //           //             ),
                    //           //             Visibility(
                    //           //               visible: state
                    //           //                   .myOrdersListDashBoardModeldata
                    //           //                   .data
                    //           //                   .results
                    //           //                   .isNotEmpty,
                    //           //               child: Column(
                    //           //                 crossAxisAlignment:
                    //           //                     CrossAxisAlignment.start,
                    //           //                 children: [
                    //           //                   Text(
                    //           //                       ConvertText.getTitle(
                    //           //                           "Need to deliver Orders"),
                    //           //                       style: GoogleFonts.manrope(
                    //           //                         color: Colors.black,
                    //           //                         fontSize: 13,
                    //           //                         fontWeight:
                    //           //                             FontWeight.w600,
                    //           //                       )),
                    //           //                   4.ph,
                    //           //                   Container(
                    //           //                     padding: const EdgeInsets
                    //           //                         .symmetric(horizontal: 8),
                    //           //                     height: 100,
                    //           //                     decoration: BoxDecoration(
                    //           //                         boxShadow: const [
                    //           //                           BoxShadow(
                    //           //                             offset: Offset(0, 0),
                    //           //                             blurRadius: 2,
                    //           //                             color: Color.fromARGB(
                    //           //                                 85, 0, 0, 0),
                    //           //                           )
                    //           //                         ],
                    //           //                         color: Colors.white,
                    //           //                         borderRadius:
                    //           //                             BorderRadius.circular(
                    //           //                                 8)),
                    //           //                     child: ListView.builder(
                    //           //                       physics:
                    //           //                           const BouncingScrollPhysics(),
                    //           //                       shrinkWrap: true,
                    //           //                       scrollDirection:
                    //           //                           Axis.horizontal,
                    //           //                       itemCount: state
                    //           //                           .myOrdersListDashBoardModeldata
                    //           //                           .data
                    //           //                           .results
                    //           //                           .length,
                    //           //                       itemBuilder:
                    //           //                           (context, index) {
                    //           //                         return InkWell(
                    //           //                           onTap: () {
                    //           //                             if (state
                    //           //                                     .myOrdersListDashBoardModeldata
                    //           //                                     .data
                    //           //                                     .results[
                    //           //                                         index]
                    //           //                                     .serviceStatus ==
                    //           //                                 "Waiting For Pickup") {
                    //           //                               Navigator.push(
                    //           //                                 context,
                    //           //                                 MaterialPageRoute(
                    //           //                                   builder:
                    //           //                                       (context) =>
                    //           //                                           NearToPickUp(
                    //           //                                     refId: state
                    //           //                                         .myOrdersListDashBoardModeldata
                    //           //                                         .data
                    //           //                                         .results[
                    //           //                                             index]
                    //           //                                         .refId,
                    //           //                                   ),
                    //           //                                 ),
                    //           //                               );
                    //           //                             }
                    //           //                             if (state
                    //           //                                     .myOrdersListDashBoardModeldata
                    //           //                                     .data
                    //           //                                     .results[
                    //           //                                         index]
                    //           //                                     .serviceStatus ==
                    //           //                                 "Ready To Pickup") {
                    //           //                               Navigator.push(
                    //           //                                 context,
                    //           //                                 MaterialPageRoute(
                    //           //                                   builder:
                    //           //                                       (context) =>
                    //           //                                           NearToPickUp(
                    //           //                                     refId: state
                    //           //                                         .myOrdersListDashBoardModeldata
                    //           //                                         .data
                    //           //                                         .results[
                    //           //                                             index]
                    //           //                                         .refId,
                    //           //                                   ),
                    //           //                                 ),
                    //           //                               );
                    //           //                             }
                    //           //                             if (state
                    //           //                                     .myOrdersListDashBoardModeldata
                    //           //                                     .data
                    //           //                                     .results[
                    //           //                                         index]
                    //           //                                     .serviceStatus ==
                    //           //                                 "Pickedup") {
                    //           //                               Navigator.push(
                    //           //                                   context,
                    //           //                                   MaterialPageRoute(
                    //           //                                     builder:
                    //           //                                         (context) =>
                    //           //                                             NearToPickUp(
                    //           //                                       refId: state
                    //           //                                           .myOrdersListDashBoardModeldata
                    //           //                                           .data
                    //           //                                           .results[
                    //           //                                               index]
                    //           //                                           .refId,
                    //           //                                     ),
                    //           //                                   ));
                    //           //                             }
                    //           //                             if (state
                    //           //                                     .myOrdersListDashBoardModeldata
                    //           //                                     .data
                    //           //                                     .results[
                    //           //                                         index]
                    //           //                                     .serviceStatus ==
                    //           //                                 "Reached Delivery") {
                    //           //                               Navigator.push(
                    //           //                                   context,
                    //           //                                   MaterialPageRoute(
                    //           //                                     builder:
                    //           //                                         (context) =>
                    //           //                                             NearToPickUp(
                    //           //                                       refId: state
                    //           //                                           .myOrdersListDashBoardModeldata
                    //           //                                           .data
                    //           //                                           .results[
                    //           //                                               index]
                    //           //                                           .refId,
                    //           //                                     ),
                    //           //                                   ));
                    //           //                             }
                    //           //                             if (state
                    //           //                                     .myOrdersListDashBoardModeldata
                    //           //                                     .data
                    //           //                                     .results[
                    //           //                                         index]
                    //           //                                     .serviceStatus ==
                    //           //                                 "Out For Delivery") {
                    //           //                               Navigator.push(
                    //           //                                   context,
                    //           //                                   MaterialPageRoute(
                    //           //                                     builder:
                    //           //                                         (context) =>
                    //           //                                             NearToPickUp(
                    //           //                                       refId: state
                    //           //                                           .myOrdersListDashBoardModeldata
                    //           //                                           .data
                    //           //                                           .results[
                    //           //                                               index]
                    //           //                                           .refId,
                    //           //                                     ),
                    //           //                                   ));
                    //           //                             }
                    //           //                           },
                    //           //                           child: Container(
                    //           //                             padding:
                    //           //                                 const EdgeInsets
                    //           //                                     .only(
                    //           //                                     top: 12,
                    //           //                                     bottom: 10),
                    //           //                             child: Column(
                    //           //                               mainAxisAlignment:
                    //           //                                   MainAxisAlignment
                    //           //                                       .start,
                    //           //                               crossAxisAlignment:
                    //           //                                   CrossAxisAlignment
                    //           //                                       .start,
                    //           //                               children: [
                    //           //                                 Text(
                    //           //                                     "RefId: ${state.myOrdersListDashBoardModeldata.data.results[index].refId}",
                    //           //                                     style: GoogleFonts.manrope(
                    //           //                                         fontSize:
                    //           //                                             16,
                    //           //                                         fontWeight:
                    //           //                                             FontWeight
                    //           //                                                 .w600)),
                    //           //                                 Padding(
                    //           //                                   padding: const EdgeInsets
                    //           //                                       .symmetric(
                    //           //                                       vertical:
                    //           //                                           4.0),
                    //           //                                   child: Row(
                    //           //                                     children: [
                    //           //                                       Text(
                    //           //                                           "${ConvertText.getTitle("Status")}: ",
                    //           //                                           style: GoogleFonts.manrope(
                    //           //                                               fontSize:
                    //           //                                                   13,
                    //           //                                               fontWeight:
                    //           //                                                   FontWeight.w600,
                    //           //                                               color: Colors.black)),
                    //           //                                       Text(
                    //           //                                           state
                    //           //                                               .myOrdersListDashBoardModeldata
                    //           //                                               .data
                    //           //                                               .results[
                    //           //                                                   index]
                    //           //                                               .serviceStatus,
                    //           //                                           style: GoogleFonts.manrope(
                    //           //                                               fontSize:
                    //           //                                                   13,
                    //           //                                               fontWeight: FontWeight
                    //           //                                                   .w600,
                    //           //                                               color: const Color.fromARGB(
                    //           //                                                   255,
                    //           //                                                   12,
                    //           //                                                   134,
                    //           //                                                   16))),
                    //           //                                     ],
                    //           //                                   ),
                    //           //                                 ),
                    //           //                                 Text(
                    //           //                                     "${ConvertText.getTitle("Date & Time")}: ${state.myOrdersListDashBoardModeldata.data.results[index].serviceDateTime}",
                    //           //                                     style: GoogleFonts.manrope(
                    //           //                                         fontSize:
                    //           //                                             14,
                    //           //                                         fontWeight:
                    //           //                                             FontWeight
                    //           //                                                 .w600)),
                    //           //                               ],
                    //           //                             ),
                    //           //                           ),
                    //           //                         );
                    //           //                       },
                    //           //                     ),
                    //           //                   ),
                    //           //                 ],
                    //           //               ),
                    //           //             )
                    //           //           ],
                    //           //         );
                    //           //       }
                    //           //       return onlineOfflineStatus == true
                    //           //           ? Center(
                    //           //               child: Shimmer.fromColors(
                    //           //                   baseColor: Colors.grey.shade300,
                    //           //                   highlightColor: Colors.white,
                    //           //                   child: Container(
                    //           //                     decoration: BoxDecoration(
                    //           //                         color: Colors.white30,
                    //           //                         borderRadius:
                    //           //                             BorderRadius.circular(
                    //           //                                 28)),
                    //           //                     height: 100,
                    //           //                     width: 380,
                    //           //                   )),
                    //           //             )
                    //           //           : const SizedBox.shrink();
                    //           //     },
                    //           //   ),
                    //           // ),

                    //           // ),
                    //           // ),
                    //           // Visibility(
                    //           //   visible: check.isCab,
                    //           //   child: Visibility(
                    //           //     visible: _selectedIndex == 1,
                    //           //     child: SizedBox(
                    //           //       height:
                    //           //           100, // Set the height of the container
                    //           //       child: BlocBuilder<OngoingRidesDataCubit,
                    //           //           OngoingRidesDataState>(
                    //           //         builder:
                    //           //             (context, ongoingRidesDataState) {
                    //           //           if (ongoingRidesDataState.dataLoading) {
                    //           //             return Center(
                    //           //               child: Shimmer.fromColors(
                    //           //                   baseColor: Colors.grey.shade300,
                    //           //                   highlightColor: Colors.white,
                    //           //                   child: Container(
                    //           //                     decoration: BoxDecoration(
                    //           //                         color: Colors.white30,
                    //           //                         borderRadius:
                    //           //                             BorderRadius.circular(
                    //           //                                 28)),
                    //           //                     height: 100,
                    //           //                     width: 380,
                    //           //                   )),
                    //           //             );
                    //           //           } else if (ongoingRidesDataState
                    //           //                   .error !=
                    //           //               null) {
                    //           //             return const SizedBox.shrink();
                    //           //           } else {
                    //           //             final onGoing = ongoingRidesDataState
                    //           //                 .ongoingRidesResponseModel.data;
                    //           //             return onGoing.isEmpty
                    //           //                 ? Align(
                    //           //                     alignment: Alignment.center,
                    //           //                     child: Column(
                    //           //                       mainAxisSize:
                    //           //                           MainAxisSize.min,
                    //           //                       children: [
                    //           //                         Align(
                    //           //                           alignment:
                    //           //                               Alignment.center,
                    //           //                           child: SvgPicture.asset(
                    //           //                             'assets/images/emptyrides.svg',
                    //           //                             height: 55,
                    //           //                           ),
                    //           //                         ),
                    //           //                         10.ph,
                    //           //                         Text(
                    //           //                             ConvertText.getTitle(
                    //           //                                 "Searching for Rides..."),
                    //           //                             style: GoogleFonts
                    //           //                                 .manrope(
                    //           //                               color: Colors.black,
                    //           //                               fontSize: 12,
                    //           //                               fontWeight:
                    //           //                                   FontWeight.w500,
                    //           //                             )),
                    //           //                       ],
                    //           //                     ),
                    //           //                   )
                    //           //                 : ListView.builder(
                    //           //                     scrollDirection:
                    //           //                         Axis.horizontal,
                    //           //                     shrinkWrap: true,
                    //           //                     itemCount: onGoing.length,
                    //           //                     itemBuilder:
                    //           //                         (context, index) {
                    //           //                       // Return your horizontal list item widget here
                    //           //                       return InkWell(
                    //           //                         onTap: () {
                    //           //                           Future.delayed(
                    //           //                               Duration.zero, () {
                    //           //                             if (onGoing[index]
                    //           //                                     .status !=
                    //           //                                 'Created') {
                    //           //                               Navigator.pushNamed(
                    //           //                                   context,
                    //           //                                   NearToPickUp
                    //           //                                       .routeName,
                    //           //                                   arguments: {
                    //           //                                     'ref_id': onGoing[
                    //           //                                             index]
                    //           //                                         .orderId,
                    //           //                                     'apptype':
                    //           //                                         'cab'
                    //           //                                   });
                    //           //                             } else {
                    //           //                               Navigator.pushNamed(
                    //           //                                 context,
                    //           //                                 NewOrderScreen
                    //           //                                     .routeName,
                    //           //                                 arguments: {
                    //           //                                   'orderId':
                    //           //                                       onGoing[index]
                    //           //                                           .orderId,
                    //           //                                   'apptype': 'cab'
                    //           //                                 },
                    //           //                               );
                    //           //                             }
                    //           //                           });
                    //           //                         },
                    //           //                         child: Card(
                    //           //                           child: Padding(
                    //           //                             padding:
                    //           //                                 const EdgeInsets
                    //           //                                     .symmetric(
                    //           //                                     horizontal:
                    //           //                                         10,
                    //           //                                     vertical: 5),
                    //           //                             child: Column(
                    //           //                               crossAxisAlignment:
                    //           //                                   CrossAxisAlignment
                    //           //                                       .start,
                    //           //                               mainAxisAlignment:
                    //           //                                   MainAxisAlignment
                    //           //                                       .center,
                    //           //                               mainAxisSize:
                    //           //                                   MainAxisSize
                    //           //                                       .min,
                    //           //                               children: [
                    //           //                                 Text(
                    //           //                                     ConvertText
                    //           //                                         .getTitle(
                    //           //                                             'Ride Id :${onGoing[index].orderId}'),
                    //           //                                     style: GoogleFonts
                    //           //                                         .manrope(
                    //           //                                       color: Colors
                    //           //                                           .black,
                    //           //                                       fontSize:
                    //           //                                           15,
                    //           //                                       fontWeight:
                    //           //                                           FontWeight
                    //           //                                               .w700,
                    //           //                                     )),
                    //           //                                 Text.rich(
                    //           //                                   TextSpan(
                    //           //                                     children: [
                    //           //                                       const TextSpan(
                    //           //                                         text:
                    //           //                                             'Status : ',
                    //           //                                         style: TextStyle(
                    //           //                                             fontWeight: FontWeight
                    //           //                                                 .bold,
                    //           //                                             fontFamily:
                    //           //                                                 'ProximaNova',
                    //           //                                             fontSize:
                    //           //                                                 13,
                    //           //                                             color:
                    //           //                                                 Colors.black),
                    //           //                                       ),
                    //           //                                       TextSpan(
                    //           //                                         text: onGoing[
                    //           //                                                 index]
                    //           //                                             .status,
                    //           //                                         style: const TextStyle(
                    //           //                                             fontWeight: FontWeight
                    //           //                                                 .bold,
                    //           //                                             fontFamily:
                    //           //                                                 'ProximaNova',
                    //           //                                             fontSize:
                    //           //                                                 13,
                    //           //                                             color:
                    //           //                                                 Colors.green),
                    //           //                                       ),
                    //           //                                     ],
                    //           //                                   ),
                    //           //                                 ),
                    //           //                                 Text(
                    //           //                                     ConvertText
                    //           //                                         .getTitle(
                    //           //                                             'Grand Total :${onGoing[index].grandTotal}'),
                    //           //                                     style: GoogleFonts
                    //           //                                         .manrope(
                    //           //                                       color: Colors
                    //           //                                           .black,
                    //           //                                       fontSize:
                    //           //                                           12,
                    //           //                                       fontWeight:
                    //           //                                           FontWeight
                    //           //                                               .w700,
                    //           //                                     )),
                    //           //                                 Text(
                    //           //                                     ConvertText
                    //           //                                         .getTitle(
                    //           //                                             'Distance :${onGoing[index].droppingDistance}KMs'),
                    //           //                                     style: GoogleFonts
                    //           //                                         .manrope(
                    //           //                                       color: Colors
                    //           //                                           .black,
                    //           //                                       fontSize:
                    //           //                                           12,
                    //           //                                       fontWeight:
                    //           //                                           FontWeight
                    //           //                                               .w700,
                    //           //                                     ))
                    //           //                               ],
                    //           //                             ),
                    //           //                           ),
                    //           //                         ),
                    //           //                       );
                    //           //                     },
                    //           //                   );
                    //           //           }
                    //           //         },
                    //           //       ),
                    //           //     ),
                    //           //   ),
                    //           // ),
                    //           // Visibility(
                    //           //   visible: check.isPickupAndDrop,
                    //           //   child: Visibility(
                    //           //     visible: _selectedIndex == 2,
                    //           //     child: SizedBox(
                    //           //       height:
                    //           //           100, // Set the height of the container
                    //           //       child: BlocBuilder<OngoingRidesDataCubit,
                    //           //           OngoingRidesDataState>(
                    //           //         builder:
                    //           //             (context, ongoingRidesDataState) {
                    //           //           if (ongoingRidesDataState.dataLoading) {
                    //           //             return Center(
                    //           //               child: Shimmer.fromColors(
                    //           //                   baseColor: Colors.grey.shade300,
                    //           //                   highlightColor: Colors.white,
                    //           //                   child: Container(
                    //           //                     decoration: BoxDecoration(
                    //           //                         color: Colors.white30,
                    //           //                         borderRadius:
                    //           //                             BorderRadius.circular(
                    //           //                                 28)),
                    //           //                     height: 100,
                    //           //                     width: 380,
                    //           //                   )),
                    //           //             );
                    //           //           } else if (ongoingRidesDataState
                    //           //                   .error !=
                    //           //               null) {
                    //           //             return const SizedBox.shrink();
                    //           //           } else {
                    //           //             final onGoing = ongoingRidesDataState
                    //           //                 .ongoingRidesResponseModel.data;
                    //           //             return onGoing.isEmpty
                    //           //                 ? Align(
                    //           //                     alignment: Alignment.center,
                    //           //                     child: Column(
                    //           //                       mainAxisSize:
                    //           //                           MainAxisSize.min,
                    //           //                       children: [
                    //           //                         Align(
                    //           //                           alignment:
                    //           //                               Alignment.center,
                    //           //                           child: SvgPicture.asset(
                    //           //                             "assets/images/emptypickanddrop.svg",
                    //           //                             height: 55,
                    //           //                           ),
                    //           //                         ),
                    //           //                         10.ph,
                    //           //                         Text(
                    //           //                             ConvertText.getTitle(
                    //           //                                 "Searching for Rides..."),
                    //           //                             style: GoogleFonts
                    //           //                                 .manrope(
                    //           //                               color: Colors.black,
                    //           //                               fontSize: 12,
                    //           //                               fontWeight:
                    //           //                                   FontWeight.w500,
                    //           //                             )),
                    //           //                       ],
                    //           //                     ),
                    //           //                   )
                    //           //                 : ListView.builder(
                    //           //                     scrollDirection:
                    //           //                         Axis.horizontal,
                    //           //                     shrinkWrap: true,
                    //           //                     itemCount: onGoing.length,
                    //           //                     itemBuilder:
                    //           //                         (context, index) {
                    //           //                       // Return your horizontal list item widget here
                    //           //                       return InkWell(
                    //           //                         onTap: () {
                    //           //                           Future.delayed(
                    //           //                               Duration.zero, () {
                    //           //                             if (onGoing[index]
                    //           //                                     .status !=
                    //           //                                 'Created') {
                    //           //                               Navigator.pushNamed(
                    //           //                                   context,
                    //           //                                   NearToPickUp
                    //           //                                       .routeName,
                    //           //                                   arguments: {
                    //           //                                     'ref_id': onGoing[
                    //           //                                             index]
                    //           //                                         .orderId,
                    //           //                                     'apptype':
                    //           //                                         'pickupanddrop'
                    //           //                                   });
                    //           //                             } else {
                    //           //                               Navigator.pushNamed(
                    //           //                                 context,
                    //           //                                 NewOrderScreen
                    //           //                                     .routeName,
                    //           //                                 arguments: {
                    //           //                                   'orderId':
                    //           //                                       onGoing[index]
                    //           //                                           .orderId,
                    //           //                                   'apptype':
                    //           //                                       'pickupanddrop'
                    //           //                                 },
                    //           //                               );
                    //           //                             }
                    //           //                           });
                    //           //                         },
                    //           //                         child: Card(
                    //           //                           child: Padding(
                    //           //                             padding:
                    //           //                                 const EdgeInsets
                    //           //                                     .symmetric(
                    //           //                                     horizontal:
                    //           //                                         10,
                    //           //                                     vertical: 5),
                    //           //                             child: Column(
                    //           //                               crossAxisAlignment:
                    //           //                                   CrossAxisAlignment
                    //           //                                       .start,
                    //           //                               mainAxisAlignment:
                    //           //                                   MainAxisAlignment
                    //           //                                       .center,
                    //           //                               mainAxisSize:
                    //           //                                   MainAxisSize
                    //           //                                       .min,
                    //           //                               children: [
                    //           //                                 Text(
                    //           //                                     ConvertText
                    //           //                                         .getTitle(
                    //           //                                             'Ride Id :${onGoing[index].orderId}'),
                    //           //                                     style: GoogleFonts
                    //           //                                         .manrope(
                    //           //                                       color: Colors
                    //           //                                           .black,
                    //           //                                       fontSize:
                    //           //                                           15,
                    //           //                                       fontWeight:
                    //           //                                           FontWeight
                    //           //                                               .w700,
                    //           //                                     )),
                    //           //                                 Text.rich(
                    //           //                                   TextSpan(
                    //           //                                     children: [
                    //           //                                       const TextSpan(
                    //           //                                         text:
                    //           //                                             'Status : ',
                    //           //                                         style: TextStyle(
                    //           //                                             fontWeight: FontWeight
                    //           //                                                 .bold,
                    //           //                                             fontFamily:
                    //           //                                                 'ProximaNova',
                    //           //                                             fontSize:
                    //           //                                                 13,
                    //           //                                             color:
                    //           //                                                 Colors.black),
                    //           //                                       ),
                    //           //                                       TextSpan(
                    //           //                                         text: onGoing[
                    //           //                                                 index]
                    //           //                                             .status,
                    //           //                                         style: const TextStyle(
                    //           //                                             fontWeight: FontWeight
                    //           //                                                 .bold,
                    //           //                                             fontFamily:
                    //           //                                                 'ProximaNova',
                    //           //                                             fontSize:
                    //           //                                                 13,
                    //           //                                             color:
                    //           //                                                 Colors.green),
                    //           //                                       ),
                    //           //                                     ],
                    //           //                                   ),
                    //           //                                 ),
                    //           //                                 Text(
                    //           //                                     ConvertText
                    //           //                                         .getTitle(
                    //           //                                             'Grand Total :${onGoing[index].grandTotal}'),
                    //           //                                     style: GoogleFonts
                    //           //                                         .manrope(
                    //           //                                       color: Colors
                    //           //                                           .black,
                    //           //                                       fontSize:
                    //           //                                           12,
                    //           //                                       fontWeight:
                    //           //                                           FontWeight
                    //           //                                               .w700,
                    //           //                                     )),
                    //           //                                 Text(
                    //           //                                     ConvertText
                    //           //                                         .getTitle(
                    //           //                                             'Distance :${onGoing[index].droppingDistance}KMs'),
                    //           //                                     style: GoogleFonts
                    //           //                                         .manrope(
                    //           //                                       color: Colors
                    //           //                                           .black,
                    //           //                                       fontSize:
                    //           //                                           12,
                    //           //                                       fontWeight:
                    //           //                                           FontWeight
                    //           //                                               .w700,
                    //           //                                     ))
                    //           //                               ],
                    //           //                             ),
                    //           //                           ),
                    //           //                         ),
                    //           //                       );
                    //           //                     },
                    //           //                   );
                    //           //           }
                    //           //         },
                    //           //       ),
                    //           //     ),
                    //           //   ),
                    //           // ),
                    //         ],
                    //       );
                    //     }
                    //   },
                    // ),

                    10.ph,

                    ///commented food ongoing orders list
                    /*Visibility(
                      visible: onlineOfflineStatus != null
                          ? onlineOfflineStatus!
                          : false,
                      child: BlocBuilder<OrdersListBloc, OrdersListState>(
                        builder: (context, state) {
                          if (state is MyOrdersListListLoadedState) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: state.myOrdersListDashBoardModeldata
                                      .data.results.isEmpty,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            "assets/images/New Order.png",
                                            height: 55,
                                          ),
                                        ),
                                        10.ph,
                                        Text(
                                            ConvertText.getTitle(
                                                "Searching for Orders..."),
                                            style: GoogleFonts.manrope(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: state.myOrdersListDashBoardModeldata
                                      .data.results.isNotEmpty,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      16.ph,
                                      Text(
                                          ConvertText.getTitle(
                                              "Need to deliver Orders"),
                                          style: GoogleFonts.manrope(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          )),
                                      4.ph,
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        height: 146,
                                        decoration: BoxDecoration(
                                            boxShadow: const [
                                              BoxShadow(
                                                offset: Offset(0, 0),
                                                blurRadius: 2,
                                                color:
                                                    Color.fromARGB(85, 0, 0, 0),
                                              )
                                            ],
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: ListView.builder(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: state
                                              .myOrdersListDashBoardModeldata
                                              .data
                                              .results
                                              .length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                if (state
                                                        .myOrdersListDashBoardModeldata
                                                        .data
                                                        .results[index]
                                                        .serviceStatus ==
                                                    "Waiting For Pickup") {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          NearToPickUp(
                                                        // type: '',
                                                        refId: state
                                                            .myOrdersListDashBoardModeldata
                                                            .data
                                                            .results[index]
                                                            .refId,
                                                      ),
                                                    ),
                                                  );
                                                }
                                                if (state
                                                        .myOrdersListDashBoardModeldata
                                                        .data
                                                        .results[index]
                                                        .serviceStatus ==
                                                    "Ready To Pickup") {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          NearToPickUp(
                                                        // type: '',
                                                        refId: state
                                                            .myOrdersListDashBoardModeldata
                                                            .data
                                                            .results[index]
                                                            .refId,
                                                      ),
                                                    ),
                                                  );
                                                }
                                                if (state
                                                        .myOrdersListDashBoardModeldata
                                                        .data
                                                        .results[index]
                                                        .serviceStatus ==
                                                    "Pickedup") {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            NearToPickUp(
                                                          // type: '',
                                                          refId: state
                                                              .myOrdersListDashBoardModeldata
                                                              .data
                                                              .results[index]
                                                              .refId,
                                                        ),
                                                      ));
                                                }
                                                if (state
                                                        .myOrdersListDashBoardModeldata
                                                        .data
                                                        .results[index]
                                                        .serviceStatus ==
                                                    "Reached Delivery") {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            NearToPickUp(
                                                          // type: '',
                                                          refId: state
                                                              .myOrdersListDashBoardModeldata
                                                              .data
                                                              .results[index]
                                                              .refId,
                                                        ),
                                                      ));
                                                }
                                                if (state
                                                        .myOrdersListDashBoardModeldata
                                                        .data
                                                        .results[index]
                                                        .serviceStatus ==
                                                    "Out For Delivery") {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            NearToPickUp(
                                                          // type: '',
                                                          refId: state
                                                              .myOrdersListDashBoardModeldata
                                                              .data
                                                              .results[index]
                                                              .refId,
                                                        ),
                                                      ));
                                                }
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 12, bottom: 12),
                                                decoration: const BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color:
                                                                Colors.grey))),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        "RefId: ${state.myOrdersListDashBoardModeldata.data.results[index].refId}",
                                                        style:
                                                            GoogleFonts.manrope(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 4.0),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                              "${ConvertText.getTitle("Status")}: ",
                                                              style: GoogleFonts.manrope(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .black)),
                                                          Text(
                                                              state
                                                                  .myOrdersListDashBoardModeldata
                                                                  .data
                                                                  .results[
                                                                      index]
                                                                  .serviceStatus,
                                                              style: GoogleFonts.manrope(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      12,
                                                                      134,
                                                                      16))),
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                        "${ConvertText.getTitle("Date & Time")}: ${state.myOrdersListDashBoardModeldata.data.results[index].serviceDateTime}",
                                                        style:
                                                            GoogleFonts.manrope(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                  ],
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
                            );
                          }
                          return onlineOfflineStatus == true
                              ? Center(
                                  child: Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.white,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white30,
                                            borderRadius:
                                                BorderRadius.circular(28)),
                                        height: 120,
                                        width: 380,
                                      )),
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                    ),
                    10.ph, */
                    Text(ConvertText.getTitle("Today So Far"),
                        style: GoogleFonts.manrope(
                          color: ColorsData.themeColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        )),
                    10.ph,
                    BlocBuilder<DashboardHomeBloc, DashboardHomeState>(
                      builder: (context, state) {
                        if (state is DashBoardDetailsLoadedState) {
                          return Container(
                            height: 70,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1.09, color: Colors.black),
                                borderRadius: BorderRadius.circular(6)),
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/Trips.png",
                                        height: 30,
                                        width: 30,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              state.dashBoardDetailsModeldata
                                                  .data.trips
                                                  .toString(),
                                              style: GoogleFonts.manrope(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              )),
                                          Text(ConvertText.getTitle("Trips"),
                                              style: GoogleFonts.manrope(
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                  VerticalDivider(
                                    color: Colors.grey[200],
                                    width: 10,
                                    thickness: 2,
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/Earnings.png",
                                        height: 30,
                                        width: 30,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              state.dashBoardDetailsModeldata
                                                  .data.todayEarnings
                                                  .toString(),
                                              style: GoogleFonts.manrope(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              )),
                                          Text(
                                            ConvertText.getTitle(
                                                "Total Earnings"),
                                            style: GoogleFonts.manrope(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  VerticalDivider(
                                    color: Colors.grey[200],
                                    width: 10,
                                    thickness: 2,
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/Distance.png",
                                        height: 30,
                                        width: 30,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              state.dashBoardDetailsModeldata
                                                  .data.todayDistanceTravelled
                                                  .toString(),
                                              style: GoogleFonts.manrope(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              )),
                                          Text(ConvertText.getTitle("Distance"),
                                              style: GoogleFonts.manrope(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return Center(
                          child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.white,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white30,
                                    borderRadius: BorderRadius.circular(10)),
                                height: 60,
                                width: MediaQuery.of(context).size.width * 0.9,
                              )),
                        );
                      },
                    ),
                    6.ph,
                    BlocBuilder<DashboardHomeBloc, DashboardHomeState>(
                      builder: (context, state) {
                        if (state is DashboardHomeInitial) {
                          return Center(
                            child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.white,
                                child: Container(
                                  height: 130,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                      color: Colors.white30,
                                      borderRadius: BorderRadius.circular(10)),
                                )),
                          );
                        }
                        if (state is DashBoardDetailsLoadedState) {
                          return state
                                  .dashBoardDetailsModeldata.data.ads.isEmpty
                              ? const SizedBox.shrink()
                              : plotsCarsoul(state);
                        }
                        return Center(
                          child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.white,
                              child: Container(
                                height: 130,
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                    color: Colors.white30,
                                    borderRadius: BorderRadius.circular(10)),
                              )),
                        );
                      },
                    ),
                    10.ph,
                    Text(ConvertText.getTitle("Quick Links"),
                        style: GoogleFonts.manrope(
                          color: ColorsData.themeColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        )),
                    5.ph,
                    BlocBuilder<DashboardHomeBloc, DashboardHomeState>(
                      builder: (context, state) {
                        if (state is DashBoardDetailsLoadedState) {
                          return Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Wrap(
                              children: [
                                QuickLinksDataWidget(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CashOnDeliveryWallet(),
                                        ));
                                  },
                                  imageUrl: "assets/images/homewallet.png",
                                  amountData:
                                      "₹ ${state.dashBoardDetailsModeldata.data.codWalletAmount.toString()}",
                                  titleData: "COD Wallet Amount",
                                ),
                                QuickLinksDataWidget(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CODCashScreen(),
                                        ));
                                  },
                                  imageUrl: "assets/images/COD Cash.png",
                                  amountData: state.dashBoardDetailsModeldata
                                          .data.cashwallet.isEmpty
                                      ? "₹ 0"
                                      : " ₹ ${state.dashBoardDetailsModeldata.data.cashwallet.toString()}",
                                  titleData: "COD Cash >",
                                ),
                                QuickLinksDataWidget(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const PayoutHistoryScreen(),
                                        ));
                                  },
                                  imageUrl: "assets/images/Total Earnings.png",
                                  amountData:
                                      "₹ ${state.dashBoardDetailsModeldata.data.totalEarnings.toString()}",
                                  titleData: "Settlement Amount",
                                ),
                                QuickLinksDataWidget(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const BottomsNaviScreen(index: 2),
                                        ));
                                  },
                                  imageUrl: "assets/images/Week Earnings.png",
                                  amountData:
                                      "₹ ${state.dashBoardDetailsModeldata.data.weekEarnings.toString()}",
                                  titleData: "Week Earnings",
                                ),
                              ],
                            ),
                          );
                        }
                        return Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.white,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white30,
                                    borderRadius: BorderRadius.circular(12)),
                                height: 120,
                                width: MediaQuery.of(context).size.width * 0.45,
                              ),
                            ),
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.white,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white30,
                                    borderRadius: BorderRadius.circular(12)),
                                height: 120,
                                width: MediaQuery.of(context).size.width * 0.45,
                              ),
                            ),
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.white,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white30,
                                    borderRadius: BorderRadius.circular(12)),
                                height: 120,
                                width: MediaQuery.of(context).size.width * 0.45,
                              ),
                            ),
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.white,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white30,
                                    borderRadius: BorderRadius.circular(12)),
                                height: 120,
                                width: MediaQuery.of(context).size.width * 0.45,
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget plotsCarsoul(DashBoardDetailsLoadedState state) {
    return Column(
      children: [
        Container(
          height: 135,
          // width: 350,
          color: Colors.transparent,
          child: CarouselSlider.builder(
            itemCount: state.dashBoardDetailsModeldata.data.ads.length,
            itemBuilder: (context, index, realIndex) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(
                        state.dashBoardDetailsModeldata.data.ads[index].image),
                    fit: BoxFit.fill,
                  ),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 5),
              );
            },
            options: CarouselOptions(
                padEnds: false,
                height: 200.0,
                // aspectRatio: 3.3,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: false,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: 0.9,
                autoPlay: true,
                onPageChanged: (index, reason) => (mounted) {
                      setState(() => activeIndex = index);
                    }),
          ),
        ),
      ],
    );
  }
}
