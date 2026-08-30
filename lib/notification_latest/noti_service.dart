import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationService(
    this.flutterLocalNotificationsPlugin,
  );

  void foregroundNotificationTap(NotificationResponse details) {
    // print("******LOCAL FOREGROUND RECEIVED 1*******");
  }

  @pragma('vm:entry-point')
  static void backgroundNotificationTap(NotificationResponse details) {
    // print("******LOCAL BACKGROUND RECEIVED 2*******");
  }

  Future<void> foregroundConfig() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: false,
      sound: true,
    );
    const channel = AndroidNotificationChannel(
      'foreground_high_importance_channel', // id
      'High Importance Foreground Notifications', // title
      description:
          'This channel is used for foreground notifications.', // description
      importance: Importance.high,
    );

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the AndroidManifest.xml file to override the
    /// default FCM channel to enable heads up notifications.
    await createChannel(channel);
  }

  Future<void> createChannel(
      AndroidNotificationChannel notificationChannel) async {
    return await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(notificationChannel);
  }

  Future<void> initialize(BuildContext context) async {
    await foregroundConfig();
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings(
            "@mipmap/ic_launcher"); //'@mipmap/ic_launcher'

    DarwinInitializationSettings darwinInitializationSettings =
        const DarwinInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: foregroundNotificationTap,
      onDidReceiveBackgroundNotificationResponse: backgroundNotificationTap,
    );
  }

  Future showNotification({
    int showNotificationId = 0,
    required AndroidNotificationDetails androidNotificationDetails,
    //
    String? title,
    String? body,
    String? payload,
  }) async {
    var platformChannelSpecifics =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      title: title,
      body: body,
      notificationDetails: platformChannelSpecifics,
      payload: payload, id: showNotificationId,
    );
  }
}
