import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';

import '../../commons/shared_prefs.dart';

/// A class to manage device tokens for Firebase Cloud Messaging (FCM).
///
/// This class helps you get, refresh, and delete the device token used for notifications.
class NotificationDeviceToken {
  final FirebaseMessaging _firebaseMessaging;

  /// Constructor to initialize [NotificationDeviceToken].
  NotificationDeviceToken(this._firebaseMessaging);

  /// Gets the device token for sending notifications.
  ///
  /// This method retrieves the current device token. You can use this token to send notifications
  /// to this device.
  ///
  /// Returns:
  /// - A `Future<String>` that provides the device token. If the token cannot be found,
  ///   it returns an empty string.
  Future<String?> getDeviceToken() async {
    if (Platform.isIOS) {
      String? apnsToken;
      int retryCount = 0;
      const int maxRetries = 10;

      while (apnsToken == null && retryCount < maxRetries) {
        apnsToken = await _firebaseMessaging.getAPNSToken();
        if (apnsToken == null) {
          debugPrint('APNs token is null, retrying... ($retryCount)');
          await Future.delayed(const Duration(seconds: 1));
          retryCount++;
        }
      }

      if (apnsToken == null) {
        debugPrint('Failed to get APNs token after $maxRetries retries.');
      }
    }
    String? deviceToken = await _firebaseMessaging.getToken();
    debugPrint('====================================================');
    debugPrint('🔥 FCM DEVICE TOKEN: $deviceToken');
    debugPrint('====================================================');

    if (deviceToken != null && deviceToken.isNotEmpty) {
      Constants.prefs?.setString('push_token', deviceToken);
    }
    return deviceToken;
  }

  /// Listens for changes to the device token.
  ///
  /// This method sets up a listener that triggers whenever the token is updated.
  /// It's important to listen for updates because the token may change.
  void listenForTokenRefresh() {
    _firebaseMessaging.getNotificationSettings();
    _firebaseMessaging.onTokenRefresh.listen((String deviceToken) {
      debugPrint('Updated Device Token: $deviceToken');
      Constants.prefs?.setString('push_token', deviceToken);
    });
  }

  /// Deletes the current device token.
  ///
  /// Use this method to remove the device token when you no longer want to receive notifications.
  Future<void> deleteDeviceToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      debugPrint("Device token deleted successfully!");
    } catch (error) {
      debugPrint("Failed to delete device token: $error");
    }
  }
}
