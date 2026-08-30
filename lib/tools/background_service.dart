// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pure_o_fresh_rider_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../commons/cod_base_options.dart';
import '../commons/shared_prefs.dart';
import '../commons/url_links.dart';

const String notificationChannelKey = "foreground_service_alerts";
const int notificationChannelId = -1;
const String initialNotificationTitle = "TRACK YOUR LOCATION";
const String initialNotificationContent = "Background location sharing";

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  try {
    DartPluginRegistrant.ensureInitialized();

    //Service controller listener for android
    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });
      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }
    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    Position? previousPosition;

    Timer.periodic(const Duration(seconds: 3), (timer) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('token');

      if (service is AndroidServiceInstance) {
        if (!await service.isForegroundService()) return;

        // Check location service
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          Fluttertoast.showToast(
              msg: "Please enable device's location service",
              backgroundColor: Colors.red);

          final batteryPercentage = await battery.batteryLevel;
          debugPrint('current battery percentage: $batteryPercentage');

          final formData = FormData.fromMap({
            'access_token': accessToken,
            'is_online': Constants.prefs!.getBool("status"),
            'battery_percent': batteryPercentage
          });

          final dio = BaseApi().dioClient(); // Use your custom client
          final response = await dio
              .post("${UrlLinksData.serverUrl}Online_or_offline_status/update",
                  data: formData)
              .whenComplete(() {
            service.stopSelf();
          });

          if (response.data['err_code'] == 'valid') {
            await prefs.setBool("status", response.data['data']);
          }
          return;
        }

        final permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          await Geolocator.requestPermission();
          return;
        }

        Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        // Compare with previous position
        if (previousPosition != null) {
          print(
              'previous: ${previousPosition!.latitude}, ${previousPosition!.longitude} | current: ${currentPosition.latitude}, ${currentPosition.longitude}');
          double distance = Geolocator.distanceBetween(
            previousPosition!.latitude,
            previousPosition!.longitude,
            currentPosition.latitude,
            currentPosition.longitude,
          );

          if (distance < 50) {
            service.invoke('on_location_changed', previousPosition!.toJson());

            await service.setForegroundNotificationInfo(
              title: "Delivery boy location tracking",
              content:
                  'Your Latitude: ${previousPosition!.latitude}, Longitude: ${previousPosition!.longitude}',
            );
            return;
          }
        }

        try {
          final batteryPercentage = await battery.batteryLevel;
          debugPrint('current battery percentage: $batteryPercentage');

          final statusData = FormData.fromMap({
            'access_token': accessToken,
            'latitude': currentPosition.latitude,
            'longitude': currentPosition.longitude,
            'battery_percent': batteryPercentage
          });

          print("Sending location update: ${statusData.fields}");

          final dio = BaseApi().dioClient();
          final response = await dio.post("Update_location", data: statusData);
          print("Location update response: ${response.data}");

          previousPosition = currentPosition;

          service.invoke('on_location_changed', currentPosition.toJson());

          await service.setForegroundNotificationInfo(
            title: "Delivery boy location tracking",
            content:
                'Your Latitude: ${currentPosition.latitude}, Longitude: ${currentPosition.longitude}',
          );
        } catch (e, stackTrace) {
          print("Error sending location update: $e");
          print("StackTrace: $stackTrace");

          Fluttertoast.showToast(
            msg: "Failed to update location",
            backgroundColor: Colors.red,
          );
        }
      }
    });
  } catch (e) {
    // Handle errors, e.g., retry or log errors.
    log("Error updating location: $e");
  }
}

class BackgroundService {
  //Get instance for flutter background service plugin
  Future<void> initializeService() async {
    final service = FlutterBackgroundService();
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'foreground_service_alerts', // id
      'MY FOREGROUND SERVICE', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.low, // importance must be at low or higher level
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    if (Platform.isIOS || Platform.isAndroid) {
      await flutterLocalNotificationsPlugin.initialize(
        settings: const InitializationSettings(
          iOS: DarwinInitializationSettings(),
          android: AndroidInitializationSettings('ic_bg_service_small'),
        ),
      );
    }

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,
        // auto start service
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: notificationChannelKey,
        foregroundServiceNotificationId: notificationChannelId,
        initialNotificationTitle: initialNotificationTitle,
        initialNotificationContent: initialNotificationContent,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
      ),
    );
    await service.startService();
    // setServiceAsForeGround();
  }

  void setServiceAsForeGround() async {
    FlutterBackgroundService().invoke("setAsForeground");
  }

  void setServiceAsBackground() async {
    FlutterBackgroundService().invoke("setAsBackground");
  }

  void stopService() {
    FlutterBackgroundService().invoke("stopService");
  }
}



/*
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pure_o_fresh_rider_app/commons/cod_base_options.dart';

import '../commons/url_links.dart';

const String notificationChannelKey = "foreground_service_alerts";
const int notificationChannelId = -1;
const String initialNotificationTitle = "TRACK YOUR LOCATION";
const String initialNotificationContent = "Background location sharing";
// CollectionReference conversations =
//     FirebaseFirestore.instance.collection('driver_info');
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  try {
    DartPluginRegistrant.ensureInitialized();

    // Initialize Firebase
    // WidgetsFlutterBinding.ensureInitialized();
    // await Firebase.initializeApp();

    //Service controller listener for android
    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    Timer.periodic(const Duration(seconds: 3), (timer) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('token');
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {}

        bool serviceEnabled;

        // Test if location services are enabled.
        serviceEnabled = await Geolocator.isLocationServiceEnabled();

        if (!serviceEnabled) {
          Fluttertoast.showToast(
              msg: "Please enable device's location service",
              backgroundColor: Colors.red);
          final formData = FormData.fromMap({
            'access_token': accessToken,
            'is_online': false,
          });
          final dio = Dio();
          final response = await dio
              .post("${UrlLinksData.serverUrl}Online_or_offline_status/update",
                  data: formData)
              .whenComplete(() {
            service.stopSelf();
          });
          if (response.data['err_code'] == 'valid') {
            await prefs.setBool("status", response.data['data']);
          }
        }

        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        final permission = await Geolocator.checkPermission();

        if (permission == LocationPermission.always) {
          //show the notification from the service instance
          await service.setForegroundNotificationInfo(
            title: "Delivery boy location tracking",
            content:
                'Your Latitude: ${position.latitude}, Longitude: ${position.longitude}',
          );
          service.invoke('on_location_changed', position.toJson());
          //api call
          if (accessToken != null) {
            // final statusdata = <String, dynamic>{
            //   'access_token': accessToken,
            //   'latitude': position.latitude,
            //   'longitude': position.longitude
            // };
            // FormData data = FormData.fromMap(statusdata);
            // final dio = BaseApi().dioClient();
            // await dio.post('Update_location', data: data);


           try {
              final statusdata = <String, dynamic>{
                'access_token': accessToken,
                'latitude': position.latitude,
                'longitude': position.longitude
              };

              FormData data = FormData.fromMap(statusdata);
              final dio = BaseApi().dioClient();

              await dio.post('Update_location', data: data);
            } catch (e) {
              // Handle the exception here, you can log it or perform any other necessary actions.
               if (e is DioException) {
                if (e.response?.statusCode == 500) {
                  return  updateLocation({
                    'access_token': accessToken,
                    'latitude': position.latitude,
                    'longitude': position.longitude
                  });
                } else if (e.response?.statusCode == 508){
                  return updateLocation({
                    'access_token': accessToken,
                    'latitude': position.latitude,
                    'longitude': position.longitude
                  });
                  
                }else {
                  return updateLocation({
                    'access_token': accessToken,
                    'latitude': position.latitude,
                    'longitude': position.longitude
                  });
                }
              } else {
                rethrow;
              }
            }



            //   final firebaseProfile = FirebaseDriverProfileDetailsModel(
            //     driverId: accessToken,
            //     driverLatitude: position.latitude,
            //     driverLongitude: position.longitude,
            //   );
            //   var docId = firebaseProfile.driverId;

            //   if (!await checkIfDocExists(docId)) {
            //     docId = firebaseProfile.driverId;
            //   }

            // // Get a reference to the existing document with the same driverId
            //   final docRef = conversations.doc(docId);

            // // Check if the document exists
            //   final docSnapshot = await docRef.get();
            //   if (docSnapshot.exists) {
            //     // If the document exists, update its data with the new profile

            //     // Get the existing profile data
            //     final existingData = docSnapshot.data() as Map<String, dynamic>;

            //     // Construct the array data or update existing array
            //     List<dynamic> existingArray = existingData['locationList'] ?? [];

            //     // Check if the last location in the array is different from the new one
            //     if (existingArray.isEmpty ||
            //         (existingArray.isNotEmpty &&
            //             (existingArray.last['driver_latitude'] !=
            //                     firebaseProfile.driverLatitude ||
            //                 existingArray.last['driver_longitude'] !=
            //                     firebaseProfile.driverLongitude))) {
            //       existingArray.add(firebaseProfile.toJson());
            //     }

            //     // Update the document with the new array
            //     await docRef.update({
            //       'locationList': existingArray,
            //     });
            //   } else {
            //     // If the document doesn't exist, create it with the new profile in an array
            //     await docRef.set({
            //       'locationList': [], // Initialize with the new profile
            //     });
            //   }
          }
        } else {
          await Geolocator.requestPermission();
        }
      }
    });
  } catch (e) {
    // Handle errors, e.g., retry or log errors.
    log("Error updating location: $e");
  }
}

Future<void> updateLocation(Map<String, dynamic> statusdata) async {
  try {
    FormData data = FormData.fromMap(statusdata);
    final dio = BaseApi().dioClient();
    await dio.post('Update_location', data: data);
  } catch (e) {
    if (e is DioException) {
      if (e.response?.statusCode == 500 || e.response?.statusCode == 508) {
        // Call updateLocation() recursively with the same statusdata
        return updateLocation(statusdata);
      } else {
        throw ("Unable to update token");
      }
    } else {
      rethrow;
    }
  }
}

Future<bool> checkIfDocExists(String docId) async {
  try {
    // Get reference to Firestore collection
    var collectionRef = FirebaseFirestore.instance.collection('driver_info');

    var doc = await collectionRef.doc(docId).get();
    return doc.exists;
  } catch (e) {
    rethrow;
  }
}

class BackgroundService {
  //Get instance for flutter background service plugin
  final FlutterBackgroundService flutterBackgroundService =
      FlutterBackgroundService();

  FlutterBackgroundService get instance => flutterBackgroundService;

  Future<void> initializeService() async {
    // NotificationController.showNotification(
    //   notificationContent: NotificationContent(
    //     id: notificationChannelId,
    //     channelKey: 'background_service_alerts',
    //     title: 'Background location service activated...',
    //   ),
    // );
    await flutterBackgroundService.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,
        // auto start service
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: notificationChannelKey,
        foregroundServiceNotificationId: notificationChannelId,
        initialNotificationTitle: initialNotificationTitle,
        initialNotificationContent: initialNotificationContent,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,
        // this will be executed when app is in foreground in separated isolate
        onForeground: onStart,
      ),
    );
    await flutterBackgroundService.startService();

    setServiceAsForeGround();

    //No notification or information will visible
    // setServiceAsBackground();
  }

  void setServiceAsForeGround() async {
    flutterBackgroundService.invoke("setAsForeground");
  }

  void setServiceAsBackground() async {
    flutterBackgroundService.invoke("setAsBackground");
  }

  void stopService() {
    flutterBackgroundService.invoke("stopService");
  }
}
 */