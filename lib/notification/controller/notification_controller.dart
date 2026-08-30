import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pure_o_fresh_rider_app/main.dart';

import '../../delivery_boy_screens/new_order/repository/new_order_repository.dart';
import '../../delivery_boy_screens/new_order/screens/new_order_screen.dart';
import '../model/payload_model.dart';
// import 'package:pure_o_fresh_rider_app/delivery_boy_screens/new_order/repository/new_order_repository.dart';
// import 'package:pure_o_fresh_rider_app/delivery_boy_screens/new_order/screens/new_order_screen.dart';
// import 'package:pure_o_fresh_rider_app/main.dart';
// import 'package:pure_o_fresh_rider_app/notification/model/payload_model.dart';

///  *********************************************
///     NOTIFICATION CONTROLLER
///  *********************************************
///
@pragma('vm:entry-point')
class NotificationController {
  /// *********************************************
  ///   INITIALIZATION METHODS
  /// *********************************************
  @pragma('vm:entry-point')
  static Future<void> initializeLocalNotifications({
    required bool debug,
  }) async {
    print("hhhhh");
    final buzzerNotificationChannel = NotificationChannel(
      channelKey: 'buzzer_channel', // id
      channelName: 'Buzzer', // channel title
      channelDescription:
          'This channel is used for notifications Buzzer.', // description
      channelShowBadge: false,
      importance: NotificationImportance.High,
      soundSource: "resource://raw/finalbuzzer",
      defaultPrivacy: NotificationPrivacy.Private,
      defaultColor: Colors.deepPurple,
      ledColor: Colors.deepPurple,
    );

    final normalNotificationChannel = NotificationChannel(
      channelKey: 'alerts',
      channelName: 'Alerts',
      channelDescription: 'Notification tests as alerts',
      importance: NotificationImportance.High,
      defaultPrivacy: NotificationPrivacy.Private,
      defaultColor: Colors.deepPurple,
      ledColor: Colors.deepPurple,
    );

    final chuckNotificationChannel = NotificationChannel(
      channelKey: 'chuck_notifications',
      channelName: 'Chuck Inspector',
      channelDescription: 'Notifications for network inspection',
      importance: NotificationImportance.High,
      defaultPrivacy: NotificationPrivacy.Private,
      defaultColor: Colors.deepPurple,
      ledColor: Colors.deepPurple,
    );

    final foregroundNotificationChannel = NotificationChannel(
      channelKey: 'foreground_service_alerts',
      channelName: 'Background Service Alerts',
      channelDescription: 'Alert notification showing for background activity',
      enableVibration: false,
      soundSource: null,
      playSound: false,
      importance: NotificationImportance.None,
      // importance: NotificationImportance.Default,
      defaultPrivacy: NotificationPrivacy.Private,
      defaultColor: Colors.deepPurple,
      ledColor: Colors.deepPurple,
    );

    await AwesomeNotifications().initialize(
      null, //'resource://drawable/res_app_icon',//
      [
        buzzerNotificationChannel,
        normalNotificationChannel,
        foregroundNotificationChannel,
        chuckNotificationChannel,
      ],
      debug: debug,
    );

    // Get initial notification action is optional
    await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  @pragma('vm:entry-point')
  static Future<void> initializeRemoteNotifications({
    required bool debug,
  }) async {
    print("hhhhh");
    await AwesomeNotificationsFcm().initialize(
      onFcmSilentDataHandle: NotificationController.mySilentDataHandle,
      onFcmTokenHandle: NotificationController.myFcmTokenHandle,
      onNativeTokenHandle: NotificationController.myNativeTokenHandle,
      licenseKeys:
          // On this example app, the app ID / Bundle Id are different
          // for each platform, so i used the main Bundle ID + 1 variation
          [
        // me.carda.awesomeNotificationsFcmExample
        'B3J3yxQbzzyz0KmkQR6rDlWB5N68sTWTEMV7k9HcPBroUh4RZ/Og2Fv6Wc/lE'
            '2YaKuVY4FUERlDaSN4WJ0lMiiVoYIRtrwJBX6/fpPCbGNkSGuhrx0Rekk'
            '+yUTQU3C3WCVf2D534rNF3OnYKUjshNgQN8do0KAihTK7n83eUD60=',

        // me.carda.awesome_notifications_fcm_example
        'UzRlt+SJ7XyVgmD1WV+7dDMaRitmKCKOivKaVsNkfAQfQfechRveuKblFnCp4'
            'zifTPgRUGdFmJDiw1R/rfEtTIlZCBgK3Wa8MzUV4dypZZc5wQIIVsiqi0Zhaq'
            'YtTevjLl3/wKvK8fWaEmUxdOJfFihY8FnlrSA48FW94XWIcFY=',
      ],
      debug: debug,
    );
  }

  ///  *********************************************
  ///     LOCAL NOTIFICATION EVENTS
  ///  *********************************************
  @pragma('vm:entry-point')
  static Future<void> getInitialNotificationAction() async {
    ReceivedAction? receivedAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: true);
    if (receivedAction == null) return;

    // Fluttertoast.showToast(
    //   msg: 'Notification action launched app: $receivedAction',
    //   backgroundColor: Colors.deepPurple,
    // );
  }

  ///  *********************************************
  ///     REMOTE NOTIFICATION EVENTS
  ///  *********************************************
  /// Use this method to execute on background when a silent data arrives
  /// (even while terminated)
  @pragma("vm:entry-point")
  static Future<void> mySilentDataHandle(FcmSilentData silentData) async {
    try {
      print("Silenet Data");
      late String serviceType;

      NotificationPayloadModel? payloadModel;

      //Extract the payload data

      print("Silleee $silentData");
      if (silentData.data != null) {
        if (silentData.data != null) {
          payloadModel = NotificationPayloadModel.fromJson(silentData.data);
        }
      }

      print("PAYLOADDDD $payloadModel");

      if (silentData.createdLifeCycle != NotificationLifeCycle.Foreground) {
        serviceType = 'BACKGROUND';
        //Show notification

        if (payloadModel != null) {
          if (payloadModel.showNotification == '1') {
            //Showing the order accept/reject notification
            if (payloadModel.isOrderAcceptNotification == '1') {
              final actionButtons = [
                NotificationActionButton(
                    key: 'VIEW',
                    label: 'View',
                    color: Colors.blue,
                    actionType: ActionType.Default,
                    showInCompactView: true),
                // NotificationActionButton(
                //   key: 'ACCEPT',
                //   label: 'accept',
                //   color: Colors.green,
                //   // actionType: ActionType.SilentBackgroundAction,
                //   actionType: ActionType.Default,
                // ),
                NotificationActionButton(
                  key: 'DISMISS',
                  label: 'Dismiss',
                  actionType: ActionType.DismissAction,
                  isDangerousOption: true,
                ),
              ];
              await showNotification(
                notificationContent:
                    // notificationContent
                    NotificationContent(
                  id: -1,
                  channelKey: payloadModel.androidChannelId ?? "alerts",
                  title: payloadModel.title,
                  body: payloadModel.body,
                  bigPicture: payloadModel.image,
                  largeIcon: payloadModel.image,
                  payload: payloadModel.toMap(),
                  notificationLayout: NotificationLayout.BigPicture,
                  wakeUpScreen: true,

                  //If true then on notification application will automatically open from the lock screen,
                  //when the user unlock the device.
                  fullScreenIntent: true,
                ),
                actionButtons: actionButtons,
              );
            } else {
              await showNotification(
                notificationContent:
                    // notificationContent,
                    NotificationContent(
                  id: -1,
                  channelKey: payloadModel.androidChannelId ?? "alerts",
                  title: payloadModel.title,
                  body: payloadModel.body,
                  bigPicture: payloadModel.image,
                  largeIcon: payloadModel.image,
                  payload: payloadModel.toMap(),
                  notificationLayout: NotificationLayout.BigPicture,
                  wakeUpScreen: true,

                  //If true then on notification application will automatically open from the lock screen,
                  //when the user unlock the device.
                  fullScreenIntent: true,
                ),
                // actionButtons: actionButtons,
              );
            }
          }
        }
      } else {
        serviceType = 'FOREGROUND';

        if (payloadModel != null) {
          payloadModel = NotificationPayloadModel.fromJson(silentData.data);
          print("BAAA $payloadModel");
          if (payloadModel.operationId != null &&
              payloadModel.isOrderAcceptNotification == '1') {
            await showNotification(
                notificationContent:
                    // notificationContent,
                    NotificationContent(
                  id: -1,
                  channelKey: "buzzer_channel",
                  title: payloadModel.title,
                  body: payloadModel.body,
                  bigPicture: payloadModel.image,
                  largeIcon: payloadModel.image,
                  payload: payloadModel.toMap(),
                  notificationLayout: NotificationLayout.BigPicture,
                  wakeUpScreen: true,

                  //If true then on notification application will automatically open from the lock screen,
                  //when the user unlock the device.
                  fullScreenIntent: true,
                ),
                actionButtons: [
                  NotificationActionButton(
                      key: 'VIEW',
                      label: 'View',
                      color: Colors.blue,
                      actionType: ActionType.Default,
                      showInCompactView: true),
                  // NotificationActionButton(
                  //   key: 'ACCEPT',
                  //   label: 'accept',
                  //   color: Colors.green,
                  //   // actionType: ActionType.SilentBackgroundAction,
                  //   actionType: ActionType.Default,
                  // ),
                  NotificationActionButton(
                    key: 'DISMISS',
                    label: 'Dismiss',
                    actionType: ActionType.DismissAction,
                    isDangerousOption: true,
                  ),
                ]);

            // MyApp.navigatorKey.currentState?.push(MaterialPageRoute(
            //   builder: (context) => NewOrderScreen(
            //     orderId: (payloadModel.operationId)!,
            //   ),
            // ));
            // Navigation to NewOrderScreen
            // MyApp.navigatorKey.currentState?.pushNamed(
            //   NewOrderScreen.routeName,
            //   arguments: payloadModel.operationId,
            // );

            MyApp.navigatorKey.currentState?.pushNamed(
              NewOrderScreen.routeName,
              arguments: {
                'orderId': payloadModel.operationId,
                'apptype': payloadModel.apptype
              },
            );
          } else {
            await showNotification(
              notificationContent:
                  // notificationContent,
                  NotificationContent(
                id: -1,
                channelKey: payloadModel.androidChannelId ?? "alerts",
                title: payloadModel.title,
                body: payloadModel.body,
                bigPicture: payloadModel.image,
                largeIcon: payloadModel.image,
                payload: payloadModel.toMap(),
                notificationLayout: NotificationLayout.BigPicture,
                wakeUpScreen: true,

                //If true then on notification application will automatically open from the lock screen,
                //when the user unlock the device.
                fullScreenIntent: true,
              ),
              // actionButtons: actionButtons,
            );
          }
        }
      }

      // Fluttertoast.showToast(
      //   msg: '$serviceType Silent data received',
      //   backgroundColor: Colors.blueAccent,
      //   textColor: Colors.white,
      //   fontSize: 16,
      // );
    } catch (e) {
      print("ERROR $e");
    }
  }

  /// Use this method to detect when a new fcm token is received
  @pragma("vm:entry-point")
  static Future<void> myFcmTokenHandle(String token) async {}

  /// Use this method to detect when a new native token is received
  @pragma("vm:entry-point")
  static Future<void> myNativeTokenHandle(String token) async {}

  static Future<void> resetBadge() async {
    await AwesomeNotifications().resetGlobalBadge();
  }

  ///  *********************************************
  ///     REMOTE TOKEN REQUESTS
  ///  *********************************************
  @pragma('vm:entry-point')
  static Future<String> requestFirebaseToken() async {
    if (await AwesomeNotificationsFcm().isFirebaseAvailable) {
      try {
        return await AwesomeNotificationsFcm().requestFirebaseAppToken();
      } catch (exception) {
        debugPrint('$exception');
      }
    } else {
      debugPrint('Firebase is not available on this project');
    }
    return '';
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS LISTENER
  ///  *********************************************
  ///  Notifications events are only delivered after call this method
  @pragma('vm:entry-point')
  static Future<void> startListeningNotificationEvents() async {
    await AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS
  ///  *********************************************
  ///
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    try {

      if (receivedAction.channelKey != null &&
          (receivedAction.channelKey!.contains('chuck') ||
              receivedAction.channelKey == 'chuck_notifications' ||
              (receivedAction.payload != null &&
                  receivedAction.payload!['type'] == 'chuck_inspector'))) {
        print("Chuck notification detected. Opening Inspector...");

        int retries = 0;
        while (MyApp.navigatorKey.currentState == null && retries < 10) {
          print("Navigator not ready, retrying ($retries)...");
          await Future.delayed(const Duration(milliseconds: 500));
          retries++;
        }

        chuck?.showInspector();
        return;
      }


      NotificationPayloadModel? payloadModel;
      if (receivedAction.payload != null) {
        payloadModel =
            NotificationPayloadModel.fromJson(receivedAction.payload!);
      }
      print("received ${receivedAction}");
      print("PAYYYY ${receivedAction.payload}");

      if (receivedAction.actionType == ActionType.SilentAction ||
          receivedAction.actionType == ActionType.SilentBackgroundAction) {
        // Fluttertoast.showToast(
        //   msg: message,
        //   backgroundColor: Colors.deepPurple,
        // );
        // For background actions, you must hold the execution until the end

        // await executeLongTaskInBackground();
        if (payloadModel != null &&
            payloadModel.operationId != null &&
            payloadModel.isOrderAcceptNotification == '1' &&
            receivedAction.buttonKeyPressed == "ACCEPT") {
          await NewOrderRepository()
              .acceptingOrderApiCall(referId: payloadModel.operationId!);
        }
      } else {
        // Fluttertoast.showToast(
        //   msg: message,
        //   backgroundColor: Colors.deepPurple,
        // );
        if (payloadModel != null &&
            payloadModel.operationId != null &&
            payloadModel.isOrderAcceptNotification == '1') {
          // Navigation to NewOrderScreen
          MyApp.navigatorKey.currentState?.pushNamed(
            NewOrderScreen.routeName,
            arguments: {
              'orderId': payloadModel.operationId,
              'apptype': payloadModel.apptype
            },
          );
        }
      }
    } catch (e) {
      //Error handling
      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: Colors.red,
      );
      return;
    }
  }

  ///  *********************************************
  ///     BACKGROUND TASKS TEST
  ///  *********************************************
  static Future<void> executeLongTaskInBackground() async {
    //API call
    // await Future.delayed(const Duration(seconds: 4));
    // final url = Uri.parse("http://google.com");
    // final re = await http.get(url);
    // print(re.body);
  }

  static Future<void> showNotification({
    required NotificationContent notificationContent,
    List<NotificationActionButton>? actionButtons,
    NotificationSchedule? schedule,
  }) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      isAllowed =
          await AwesomeNotifications().requestPermissionToSendNotifications();
    }
    if (!isAllowed) return;
    await AwesomeNotifications().createNotification(
      content: notificationContent,
      actionButtons: actionButtons,
      schedule: schedule,
    );
  }

  ///Dummy
  static Future<void> createNewNotification() async {
    final notificationContent = NotificationContent(
      id: -1, // -1 is replaced by a random number
      // channelKey: 'alerts',
      channelKey: 'buzzer_channel',
      title: 'Huston! The eagle has landed!',
      body: "A small step for a man, but a giant leap to Flutter's community!",
      bigPicture:
          'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
      largeIcon:
          'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
      //'asset://assets/images/balloons-in-sky.jpg',
      notificationLayout: NotificationLayout.BigPicture,
      payload: {'notificationId': '1234567890'},
    );
    final actionButtons = [
      NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
      NotificationActionButton(
          key: 'REPLY',
          label: 'Reply Message',
          requireInputText: true,
          actionType: ActionType.SilentAction),
      NotificationActionButton(
          key: 'DISMISS',
          label: 'Dismiss',
          actionType: ActionType.DismissAction,
          isDangerousOption: true)
    ];

    await showNotification(
      notificationContent: notificationContent,
      actionButtons: actionButtons,
    );
  }

  static Future<void> resetBadgeCounter() async {
    await AwesomeNotifications().resetGlobalBadge();
  }

  static Future<void> cancelNotifications() async {
    await AwesomeNotifications().cancelAll();
  }
}
