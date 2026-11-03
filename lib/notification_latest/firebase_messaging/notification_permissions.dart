import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

/// A class to manage notification permissions for Firebase Messaging.
class NotificationPermissions {
  final FirebaseMessaging firebaseMessaging;

  NotificationPermissions(this.firebaseMessaging);

  /// Requests notification permission from the user.
  Future<void> requestNotificationPermission() async {
    // Standard permissions for iOS
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false, // Set to false unless you have the Apple entitlement
      provisional: false,
      sound: true,
    );

    // Prompt user for Awesome Notifications permission
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications(
        permissions: [
          NotificationPermission.Alert,
          NotificationPermission.Sound,
          NotificationPermission.Badge,
          NotificationPermission.Vibration,
          NotificationPermission.Light,
          // NotificationPermission.CriticalAlert, // Remove if no entitlement
        ],
      );
    }

    _handlePermissionResponse(settings.authorizationStatus);
  }

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
