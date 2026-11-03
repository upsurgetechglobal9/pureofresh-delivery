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
      debugPrint("====================================================");
      debugPrint("🔥 [FCM FOREGROUND MESSAGE RECEIVED]");
      debugPrint("🔥 Message ID: ${payload.messageId}");
      debugPrint("🔥 Notification Title: ${payload.notification?.title}");
      debugPrint("🔥 Notification Body: ${payload.notification?.body}");
      debugPrint("🔥 Data Payload: ${payload.data}");
      debugPrint("====================================================");

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
        debugPrint('🔥 [FCM] Received empty payload data');
      }
    });
  }
}
