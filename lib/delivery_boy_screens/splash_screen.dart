// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart' as geo;
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../commons/ConvertText.dart';
import '../commons/shared_prefs.dart';
import '../commons/show_chuk_notification.dart';
import '../commons/url_links.dart';
import '../main.dart';
import '../notification/controller/notification_controller.dart';
import '../utility/colors_data.dart';
import '../utility/common_text.dart';
import 'location_popup.dart';
import 'login/screens/welcome_screen.dart';
import 'navigation_bar/navigationbar_screen.dart';
import 'version_check/logic/vesion_control_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> moveToHome() async {
    print("I am Bottom $isrideviewed");
    final dio = Dio();
    String? token = Constants.prefs!.getString("token");
    if (token == '' || token == null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          (route) => false);
    } else if (token != '') {
      final pendingData = FormData.fromMap({
        'access_token': token,
      });
      addChuck(dio);
      final responseforPending = await dio.post(
          UrlLinksData.serverUrl + UrlLinksData.pendingDetailsUrl,
          data: pendingData);
      if (responseforPending.data['error_type'] == 'invalid_login') {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            (route) => false);
      } else if (responseforPending.data['data']['verification_status'] ==
          true) {
        final dailycheckData = FormData.fromMap({
          'access_token': token,
        });
        // await Constants.prefs?.remove('isrideviewed');

        if (isrideviewed != 0) {
          print("I am Bottom Nav1 $isrideviewed");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => BottomsNaviScreen(index: 0)),
              (route) => false);
        }
      } else {
        if (isrideviewed != 0) {
          print("I am Bottom Nav2 $isrideviewed");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => BottomsNaviScreen(index: 0)),
              (route) => false);
        }
      }
    } else {
      if (isrideviewed != 0) {
        print("I am Bottom Nav3 $isrideviewed");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const BottomsNaviScreen(index: 0)),
            (route) => false);
      }
    }
  }

  Future<Position> fetchLocationByDeviceGPS() async {
    geo.Location location = geo.Location();
    bool serviceEnabled0 = await location.serviceEnabled();
    if (!serviceEnabled0) {
      serviceEnabled0 = await location.requestService();
      if (!serviceEnabled0) {
        await location.requestService();
        // SystemNavigator.pop();
        if (!serviceEnabled0) {
          await location.requestService();
          if (!serviceEnabled0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const LocationPopUp(gps: 'gps', screen: "register"),
              ),
            );
          }
        }
      }
    }
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await location.requestService();
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            Constants.prefs!.setString("permission", 'denied');
            moveToHome();

            // permission = await Geolocator.requestPermission();
            // if (mounted) {
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const LocationPopUp(),
            //       ));
            // }
          }
        }
        throw ('Location services are disabled.');
      } else {
        permission = await Geolocator.checkPermission();

        if (permission == LocationPermission.always) {
          Constants.prefs!.setString("bglocation", 'agree');
          Constants.prefs!.setString("permission", 'allow');
          return await Geolocator.getCurrentPosition();
        } else {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            Constants.prefs!.setString("permission", 'denied');
            moveToHome();

            // permission = await Geolocator.requestPermission();
            throw ('Location permissions are denied');
          } else if (permission == LocationPermission.deniedForever) {
            Constants.prefs!.setString("permission", 'denied');
            moveToHome();

            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => const LocationPopUp(),
            //     ));
            // Permissions are denied forever, handle appropriately.
            throw ('Location permissions are permanently denied, we cannot request permissions.');
          } else if (permission == LocationPermission.whileInUse) {
            Constants.prefs!.setString("bglocation", 'agree');
            Constants.prefs!.setString("permission", 'allow');
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LocationPopUp(screen: "register"),
                ));
            // Permissions are denied forever, handle appropriately.
            throw ('Set the location permissions to Always.');
          } else {
            if (permission == LocationPermission.always) {
              return await Geolocator.getCurrentPosition();
            } else {
              throw ('Try again.');
            }
          }
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  void didChangeDependencies() async {
    if (mounted) {
      Future.delayed(Duration.zero, () async {
        await NotificationController.startListeningNotificationEvents();
      });
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    // context.read<VesionControlCubit>().maintenanceCheckApi();
    Future.delayed(Duration.zero, () async {
      print("I am Bottom init");
      if (Constants.prefs!.getString("bglocation") == 'agree') {
        await fetchLocationByDeviceGPS();
        context.read<VesionControlCubit>().maintenanceCheckApi();
      } else {
        initialAlertDialog();
      }
    });
    requestPermissions();
    // Timer.periodic(const Duration(seconds: 5), (timer) {
    //   moveToHome();
    // });
  }

  Future<void> requestPermissions() async {
    if (await Permission.notification.isGranted) {
      // Permission is already granted
      print('333333333333333');
    } else {
      print('44444444444444444');

      await Permission.notification.request();
    }

    // if (await Permission.ignoreBatteryOptimizations.isGranted) {
    //   // Permission is already granted
    //   print('1111111111111111');

    // } else {
    //   print('222222222222222');

    //   await openAppSettings();
    // }

    // if (await Permission.systemAlertWindow.isGranted) {
    //   // Permission is already granted
    //   print('555555555555555');

    // } else {
    //   print('6666666666666666');

    //   await Permission.systemAlertWindow.request();
    // }
    // if(await Permission.locationAlways.isGranted){
    //   print('77777777777777777');

    // }else{
    //   print('8888888888888888');

    //   await openAppSettings();
    // }
  }

  @override
  Widget build(BuildContext context) {
    // return BlocBuilder<InternetCubit, InternetState>(
    //   builder: (context, internetState) {
    //     if (internetState is InternetConnected) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<VesionControlCubit, VesionControlState>(
        builder: (context, state) {
          if (state is UpdateNeededState) {
            return Stack(
              children: [
                Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/splashlogo.png',
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                    child: Text("hiiiii")),
                alertDialog(
                    state.versionCheckModel.message,
                    state.versionCheckModel.userAndroidAppLink,
                    state.versionCheckModel.forceUpdate)
              ],
            );
          }
          if (state is VersionUpdateNotNeedSate) {
            Future.delayed(const Duration(seconds: 0), () async {
              print("Version update no ");
              if (Constants.prefs!.getString("bglocation") == 'agree') {
                await moveToHome();
              } else {
                print("hereee i am inside alert ");
                showInitialBottomSheet(context);
              }
            });
            return Center(
              child: Container(
                height: 300,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage('assets/images/splashlogo.png'),
                    fit: BoxFit.contain,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        "Version - v${VersionNumber.displayVersion}",
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.bold,
                            color: ColorsData.themeColor),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          if (state is UnderMaintenanceSate) {
            if (state.underMaintenanceModel.data.maintenanceModeEnabled ==
                '0') {
              context.read<VesionControlCubit>().checkingVersion();
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.37,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          state.underMaintenanceModel.data.image,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      state.underMaintenanceModel.data.message,
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              );
            }
          }
          if (state is WorkingFineSate) {}
          return Stack(
            children: [
              Center(
                child: Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/splashlogo.png',
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Constants.prefs!.getString("bglocation") == 'agree'
                    ? const SizedBox.shrink()
                    : initialAlertDialog(),
              )
            ],
          );
        },
      ),
    );
    // } else if (internetState is InternetDisconnected) {
    //   return const NoInternetScreen();
    // }
    // return CircularProgressIndicator();
    // },
    // );
  }

  Widget alertDialog(String message, updateLink, forceUpdate) {
    return AlertDialog(
      actionsPadding: const EdgeInsets.only(bottom: 16),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      title: const Text('New Version Available!'),
      content: Text(message),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            forceUpdate == "yes"
                ? const SizedBox.shrink()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade500),
                    onPressed: () {
                      moveToHome();
                    },
                    child: Text(ConvertText.getTitle("Skip"))),
            forceUpdate == "yes"
                ? const SizedBox.shrink()
                : const SizedBox(
                    width: 24,
                  ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsData.themeColor),
              onPressed: () async {
                final url = Uri.parse(updateLink);
                if (await canLaunchUrl(url)) {
                  await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: "Unable to open Store",
                  );
                }
              },
              child: const Text('Update'),
            )
          ],
        )
      ],
    );
  }

  Widget initialAlertDialog() {
    return AlertDialog(
      actionsPadding: const EdgeInsets.only(bottom: 16),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      title: const Text('Background location permission disclaimer'),
      content: const Text(
          "This app collects the device background location to give the nearby orders to deliver the order."),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
          onPressed: () async {
            // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => const BottomsNaviScreen(index: 0)),
            //     (route) => false);
            Constants.prefs!.setString("permission", 'denied');
            moveToHome();
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            //     (route) => false);
          },
          child: const CommonProximaNovaTextWidget(text: 'No'),
        ),
        ElevatedButton(
          style:
              ElevatedButton.styleFrom(backgroundColor: ColorsData.themeColor),
          onPressed: () async {
            Constants.prefs!.setString("bglocation", 'agree');
            await fetchLocationByDeviceGPS();
            await context.read<VesionControlCubit>().maintenanceCheckApi();
          },
          child: const CommonProximaNovaTextWidget(text: 'Agree'),
        )
      ],
    );
  }

  void showInitialBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Background location permission disclaimer',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "This app collects the device background location to give the nearby orders to deliver the order",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    onPressed: () async {
                      Constants.prefs!.setString("permission", 'denied');
                      Navigator.of(context).pop(); // close sheet
                      moveToHome();
                    },
                    child: const CommonProximaNovaTextWidget(text: 'No'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsData.themeColor),
                    onPressed: () async {
                      Constants.prefs!.setString("bglocation", 'agree');
                      Navigator.of(context).pop(); // close sheet
                      await fetchLocationByDeviceGPS();
                      await context
                          .read<VesionControlCubit>()
                          .maintenanceCheckApi();
                    },
                    child: const CommonProximaNovaTextWidget(text: 'Agree'),
                  )
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
