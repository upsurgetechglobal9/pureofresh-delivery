import 'package:awesome_notifications/awesome_notifications.dart';
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
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    // Prompt user for Awesome Notifications permission if not already allowed (crucial for Android 13+)
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications(
        permissions: [
          NotificationPermission.Alert,
          NotificationPermission.Sound,
          NotificationPermission.Badge,
          NotificationPermission.Vibration,
          NotificationPermission.Light,
          NotificationPermission.CriticalAlert,
        ],
      );
    }

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
