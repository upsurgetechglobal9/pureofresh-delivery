import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

/// A class to manage notification permissions for Firebase Messaging.
class NotificationPermissions {
  final FirebaseMessaging firebaseMessaging;

  /// Constructor to initialize [NotificationPermissions].
  NotificationPermissions(this.firebaseMessaging);

  /// Requests notification permission from the user.
  ///
  /// This method prompts the user for permission to send notifications.
  /// It checks the authorization status after the request.
  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Handle the user's response to the permission request.
    _handlePermissionResponse(settings.authorizationStatus);
  }

  /// Handles the response from the notification permission request.
  ///
  /// This method logs the authorization status to the console.
  void _handlePermissionResponse(AuthorizationStatus status) {
    switch (status) {
      case AuthorizationStatus.authorized:
        debugPrint('User granted permission: Authorized');
        break;
      case AuthorizationStatus.provisional:
        debugPrint('User granted permission: Provisional');
        break;
      case AuthorizationStatus.denied:
        debugPrint('User granted permission: Denied');
        break;
      case AuthorizationStatus.notDetermined:
        debugPrint('User granted permission: Not Determined');
        break;
    }
  }
}
