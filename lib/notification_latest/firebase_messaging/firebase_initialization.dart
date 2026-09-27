import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseInitialization {
  final Function(Map<String, dynamic> data) showNotification;

  FirebaseInitialization({
    required this.showNotification,
  });

  /// Initializes Firebase Messaging and listens for foreground messages.
  Future<void> firebaseInit() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage payload) async {
      // Extract data from the payload, including notification title/body if present
      Map<String, dynamic> data = Map<String, dynamic>.from(payload.data);
      if (payload.notification != null) {
        data['title'] ??= payload.notification?.title;
        data['body'] ??= payload.notification?.body;
      }

      if (data.isNotEmpty) {
        // Show notification based on the platform
        if (Platform.isAndroid || Platform.isIOS) {
          showNotification.call(data);
        }
      } else {
        if (kDebugMode) {
          debugPrint('Received empty payload data');
        }
      }
    });
  }
}
