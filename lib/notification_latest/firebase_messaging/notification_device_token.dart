import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';

import '../../commons/shared_prefs.dart';

/// A class to manage device tokens for Firebase Cloud Messaging (FCM).
class NotificationDeviceToken {
  final FirebaseMessaging _firebaseMessaging;

  NotificationDeviceToken(this._firebaseMessaging);

  Future<String?> getDeviceToken() async {
    if (Platform.isIOS) {
      String? apnsToken;
      int retryCount = 0;
      const int maxRetries = 10;

      // Ensure APNs token is available before getting FCM token
      while (apnsToken == null && retryCount < maxRetries) {
        apnsToken = await _firebaseMessaging.getAPNSToken();
        if (apnsToken == null) {
          debugPrint('APNs token is null, retrying... ($retryCount)');
          await Future.delayed(const Duration(seconds: 1));
          retryCount++;
        }
      }

      if (apnsToken != null) {
        debugPrint('APNs token retrieved successfully: $apnsToken');
      } else {
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

  void listenForTokenRefresh() {
    _firebaseMessaging.onTokenRefresh.listen((String deviceToken) {
      debugPrint('Updated Device Token: $deviceToken');
      Constants.prefs?.setString('push_token', deviceToken);
    });
  }

  Future<void> deleteDeviceToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      debugPrint("Device token deleted successfully!");
    } catch (error) {
      debugPrint("Failed to delete device token: $error");
    }
  }
}
