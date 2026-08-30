import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as geo;
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/screens/commocoloo.dart';

import '../commons/shared_prefs.dart';
import '../commons/show_chuk_notification.dart';
import '../commons/url_links.dart';
import '../utility/common_text.dart';
import 'login/screens/welcome_screen.dart';
import 'navigation_bar/home/screens/home_screen.dart';
import 'navigation_bar/navigationbar_screen.dart';
import 'splash_screen.dart';

class LocationPopUp extends StatefulWidget {
  final String? gps;
  final String? screen;
  const LocationPopUp({super.key, this.gps, this.screen});

  @override
  State<LocationPopUp> createState() => _LocationPopUpState();
}

class _LocationPopUpState extends State<LocationPopUp> {
  Future<bool> onWillPop() {
    print("data ${widget.screen}");
    if (widget.screen == 'register') {
      Navigator.pop(context);
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomsNaviScreen(
            index: 0,
          ),
        ),
        (route) => false,
      );
    }

    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              onPressed: () async {
                if (widget.screen == 'register') {
                  Navigator.pop(context);
                } else {
                  // await fetchLocationByDeviceGPS().then((value) {
                  if (mounted) {
                    if (widget.screen == 'register') {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BottomsNaviScreen(
                            index: 0,
                          ),
                        ),
                        (route) => false,
                      );
                    }
                  }
                  // });
                }
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              )),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.center,
              child: CommonProximaNovaTextWidget(
                  textAlign: TextAlign.center,
                  text:
                      "Pure O Fresh  Delivery Partner app collects the device background location to give the nearby orders to deliver the order. By accessing your location in the background, we can provide real-time tracking."),
            ),
            30.ph,
            SvgPicture.asset(
              'assets/images/location.svg',
              width: 300,
            ),
            20.ph,
            widget.gps == 'gps'
                ? const Text(
                    "Please turn on location then only we can access your location",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  )
                : const Text(
                    "Please allow permission for location to continue",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
            const SizedBox(
              height: 10,
            ),
            widget.gps == 'gps'
                ? const Text(
                    "TURN ON LOCATION SERVICE",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  )
                : const Text(
                    "Permissions=>Location=>Allow all the time",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
            const SizedBox(
              height: 30,
            ),
            widget.gps == 'gps'
                ? ElevatedButton(
                    onPressed: () async {
                      await Geolocator.openLocationSettings();
                    },
                    child: const Text("Continue"))
                : ElevatedButton(
                    onPressed: () async {
                      await fetchLocationByDeviceGPS();
                    },
                    child: const Text("Continue")),
          ],
        )),
      ),
    );
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
            await Geolocator.openLocationSettings();
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
            permission = await Geolocator.requestPermission();
            if (mounted) {
              await Geolocator.openAppSettings();
            }
          }
        }
        throw ('Location services are disabled.');
      } else {
        permission = await Geolocator.checkPermission();

        if (permission == LocationPermission.always) {
          Constants.prefs!.setString("bglocation", 'agree');
          Constants.prefs!.setString("permission", 'allow');
          final dio = Dio();
          addChuck(dio);
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
            final responseforPending = await dio.post(
                UrlLinksData.serverUrl + UrlLinksData.pendingDetailsUrl,
                data: pendingData);
            if (responseforPending.data['error_type'] == 'invalid_login') {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WelcomeScreen()),
                  (route) => false);
            } else if (responseforPending.data['data']['verification_status'] ==
                true) {
              final dailycheckData = FormData.fromMap({
                'access_token': token,
              });
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BottomsNaviScreen(index: 0)),
                  (route) => false);
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BottomsNaviScreen(index: 0)),
                  (route) => false);
            }
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const BottomsNaviScreen(
                          index: 0,
                        )),
                (route) => false);
          }
          return await Geolocator.getCurrentPosition();
        } else {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
            throw ('Location permissions are denied');
          } else if (permission == LocationPermission.deniedForever) {
            await Geolocator.openAppSettings();
            // Permissions are denied forever, handle appropriately.

            throw ('Location permissions are permanently denied, we cannot request permissions.');
          } else if (permission == LocationPermission.whileInUse) {
            await Geolocator.openAppSettings();
            // Permissions are denied forever, handle appropriately.
            throw ('Set the location permissions to Always.');
          } else {
            print("I ama heree");
            if (permission == LocationPermission.always) {
              Constants.prefs!.setString("bglocation", 'agree');
              Constants.prefs!.setString("permission", 'allow');
              final dio = Dio();
              addChuck(dio);
              String? token = Constants.prefs!.getString("token");
              if (token == '' || token == null) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WelcomeScreen()),
                    (route) => false);
              } else if (token != '') {
                final pendingData = FormData.fromMap({
                  'access_token': token,
                });
                final responseforPending = await dio.post(
                    UrlLinksData.serverUrl + UrlLinksData.pendingDetailsUrl,
                    data: pendingData);
                if (responseforPending.data['error_type'] == 'invalid_login') {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WelcomeScreen()),
                      (route) => false);
                } else if (responseforPending.data['data']
                        ['verification_status'] ==
                    true) {
                  final dailycheckData = FormData.fromMap({
                    'access_token': token,
                  });
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const BottomsNaviScreen(index: 0)),
                      (route) => false);
                } else {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const BottomsNaviScreen(index: 0)),
                      (route) => false);
                }
              } else {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BottomsNaviScreen(
                              index: 0,
                            )),
                    (route) => false);
              }
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
}
