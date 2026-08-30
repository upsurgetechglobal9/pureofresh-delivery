import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetupInteractMessage {
  final FirebaseMessaging firebaseMessaging;

  SetupInteractMessage({
    required this.firebaseMessaging,
  });

  /// Sets up the interaction with incoming messages and handles navigation.
  void setupInteractMessage() async {
    // Check for any initial message that opened the app
    print("setuo");
    RemoteMessage? payloads = await firebaseMessaging.getInitialMessage();
    print("setuo $payloads");

    // If there is a payload, convert it to NavigationDetailsModel
    if (payloads != null) {
      print("setuo1 $payloads");
      _handlePayload(payloads);
    }
    //  else {
    //   _removeRideViewed();
    // }
    // Listen for messages when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((payloads) {
      print('setuo2 $payloads');
      _handlePayload(payloads);
    });
  }

  // Future<void> _removeRideViewed() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('isrideviewed');
  //   await prefs.remove('orderId');
  //   print("🚮 isrideviewed & orderId removed");
  // }

  /// Handles the incoming payload and navigates to the specified screen.
  void _handlePayload(RemoteMessage payloads) {
    try {
      // Navigate to the specified screen using the NavigationService

      // Map<String, String?>? payload =payloads. data.map((key, value) {
      //   return MapEntry(key, value?.toString());
      // });
      // NavigateScreen.newOrderScreen(data:payload);

      // );
    } catch (ex) {
      debugPrint('Error handling payload: $ex');
    }
  }
}
