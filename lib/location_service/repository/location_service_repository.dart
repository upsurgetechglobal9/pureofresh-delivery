// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as geo;

import '../../commons/shared_prefs.dart';

class LocationServiceRepository {
  LocationServiceRepository();

  Future<Position> fetchLocationByDeviceGPS() async {
    if (Constants.prefs!.getString("bglocation") != 'agree') {
      print("HERE NOT AGREE");
      return Future.error('User did not agree to share location.');
    }
    geo.Location location = geo.Location();
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await location.requestService();
        if (!serviceEnabled) {
          await location.requestService();
          if (!serviceEnabled) {
            // if (mounted) {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => const LocationPopUp(
            //         gps: 'gps',
            //         screen:'register'
            //       ),
            //     ),
            //   );
            // }
          }
        }
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          Geolocator.requestPermission();
        }
        await Geolocator.requestPermission();
        throw ('Location services are disabled.');
      } else {
        permission = await Geolocator.checkPermission();

        if (permission == LocationPermission.always) {
          return await Geolocator.getCurrentPosition();
        } else {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            throw ('Location permissions are denied');
          } else if (permission == LocationPermission.deniedForever) {
            const AlertDialog();
            // Permissions are denied forever, handle appropriately.
            throw ('Location permissions are permanently denied, we cannot request permissions.');
          } else if (permission == LocationPermission.whileInUse) {
            permission = await Geolocator.requestPermission();
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
}
