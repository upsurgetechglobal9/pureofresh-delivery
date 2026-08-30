import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../commons/shared_prefs.dart';
import '../../delivery_boy_screens/new_order/screens/new_order_screen.dart';
import '../../main.dart';
import '../../notification/controller/notification_controller.dart';

const String _accept = 'accept';
const String _reject = 'reject';

@pragma('vm:entry-point')
Future<void> _onActionReceivedMethod(ReceivedAction event) async {
  await actionMethod(event: event);
}

Future<void> _removeRideViewed() async {
  final prefs = await SharedPreferences.getInstance();
  await Constants.prefs?.remove('isrideviewed');
  await AwesomeNotifications().cancel(1);
  await prefs.remove('isrideviewed');
  print("🚮 isrideviewed & orderId removed");
}

actionMethod({ReceivedAction? event}) async {
  print("event $event");
  final prefs = await SharedPreferences.getInstance();
  final data = event?.payload;

  /// Prevent duplicate processing
  final alreadyHandled = prefs.getBool('notification_handled') ?? false;
  if (alreadyHandled) {
    _removeRideViewed();
    print("⚠️ Notification already handled. Skipping.");
    if (data?['order_accept_notification'] == '1') {
      // await Constants.prefs?.setInt('isrideviewed', 0);
      MyApp.navigatorKey.currentState?.pushNamed(
        NewOrderScreen.routeName,
        arguments: {
          'orderId': data?['operation_id'],
          'apptype': data?['apptype']
        },
      );
      await AwesomeNotifications().cancel(1);
      AwesomeNotificationService().cancelNotification(event?.id ?? 0);
    }
    return;
  }

  // 🔐 Mark as handled immediately to prevent re-entry
  await prefs.setBool('notification_handled', true);

  debugPrint("notification action data >> $data.");

  debugPrint("notification action data >> $data.");
  if (data == null) {
    _removeRideViewed();
  }
  // this is for when notification coming then notification tap to show
  if (data?['order_accept_notification'] == '1') {
    // await Constants.prefs?.setInt('isrideviewed', 0);
    MyApp.navigatorKey.currentState?.pushNamed(
      NewOrderScreen.routeName,
      arguments: {
        'orderId': data?['operation_id'],
        'apptype': data?['apptype']
      },
    );
    await AwesomeNotifications().cancel(1);
    AwesomeNotificationService().cancelNotification(event?.id ?? 0);
  }

  // this is for when notification coming user click accept Button Then this is showing.
  if (event?.buttonKeyPressed == _accept) {
    // await Constants.prefs?.setInt('isrideviewed', 0);
    MyApp.navigatorKey.currentState?.pushNamed(
      NewOrderScreen.routeName,
      arguments: {
        'orderId': data?['operation_id'],
        'apptype': data?['apptype']
      },
    );
    await Future.delayed(Durations.extralong2);
    AwesomeNotificationService().cancelNotification(event?.id ?? 0);
  }

  // this is for when notification coming user click reject then notification cancel.
  if (event?.buttonKeyPressed == _reject) {
    AwesomeNotificationService().cancelNotification(event?.id ?? 0);
  }
}

String _cleanTitle(String? title) {
  if (title == null) return '';
  // Remove [DEMO] (case-insensitive, trims extra spaces)
  return title.replaceAll(RegExp(r'^\[DEMO\]\s*', caseSensitive: false), '');
}

/// Service for handling notifications using Awesome Notifications package.
class AwesomeNotificationService {
  // Private constants and fields
  static String ids = '';

  /// Creates a notification with optional action buttons and a big picture.
  ///
  /// [id] - The ID for the notification (default is an empty string).
  /// [uid] - The unique ID of the notification.
  /// [title] - The title of the notification.
  /// [body] - The body content of the notification.
  /// [bigPicture] - The URL or asset path of the big picture (optional).
  /// [showButton] - If true, shows an action button in the notification.
  /// [channelKey] - The channel key for categorizing the notification.
  Future<void> createNotification({
    String? id,
    int? uid,
    String? title,
    String? body,
    String? bigPicture,
    required String channelKey,
    NotificationLayout notificationLayout = NotificationLayout.BigText,
  }) async {
    await _startListeningNotificationEvents();
    ids = id ?? '';
    await _storeNotificationId(id);

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: uid ?? 0,
        channelKey: channelKey,
        title: _cleanTitle(title),
        body: body,
        bigPicture: bigPicture,
        category: NotificationCategory.Message, // 👈 helps keep expanded
        notificationLayout: notificationLayout,
        actionType: ActionType.Default,
        // summary: bigPicture != null ? body : null,
        wakeUpScreen: true,
      ),
    );
  }

  /// Creates a notification with optional action buttons and a big picture.
  ///
  /// [id] - The ID for the notification (default is an empty string).
  /// [uid] - The unique ID of the notification.
  /// [title] - The title of the notification.
  /// [body] - The body content of the notification.
  /// [bigPicture] - The URL or asset path of the big picture (optional).
  /// [timeoutAfter] - Duration after which the notification should be dismissed (optional).
  /// [payload] - Custom payload data (optional).
  /// [buttonList] - List of action buttons for the notification (optional).
  /// [wakeUpScreen] - If true, wakes up the screen when the notification is received.
  /// [notificationLayout] - The layout of the notification.
  /// [channelKey] - The channel key for categorizing the notification.
  Future<void> createChatNotification({
    String? id,
    int? uid,
    String? title,
    bool locked = false,
    String? body,
    String? bigPicture,
    String? customSound,
    String? largeIcon,
    bool repeats = false,
    DateTime? scheduledTime,
    bool preciseAlarm = false,
    Duration? timeoutAfter,
    Map<String, String?>? payload,
    bool wakeUpScreen = true,
    bool allowWhileIdle = false,
    NotificationLayout notificationLayout = NotificationLayout.BigText,
    required String channelKey,
  }) async {
    NotificationSchedule? schedule;
    if (scheduledTime != null) {
      String localTimeZone =
          await AwesomeNotifications().getLocalTimeZoneIdentifier();
      // Create the notification calendar instance
      schedule = NotificationCalendar(
        timeZone: localTimeZone,
        year: scheduledTime.year,
        month: scheduledTime.month,
        day: scheduledTime.day,
        hour: scheduledTime.hour,
        minute: scheduledTime.minute,
        second: scheduledTime.second,
        millisecond: scheduledTime.millisecond,
        allowWhileIdle: allowWhileIdle,
        repeats: repeats,
        preciseAlarm: preciseAlarm,
      );
    }
    // Start listening for notification events
    _startListeningNotificationEvents();
    // Build action buttons from the buttonList
    List<NotificationActionButton>? actionButtons = _buildActionButtons(true);

    // Create the notification
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: uid ?? 0,
        channelKey: channelKey,
        title: _cleanTitle(title),
        body: body,
        wakeUpScreen: wakeUpScreen,
        bigPicture: bigPicture,
        largeIcon: largeIcon,
        payload: payload,
        locked: locked,
        timeoutAfter: timeoutAfter,
        actionType: ActionType.Default,
        customSound: customSound,
        category: NotificationCategory.Message, // 👈 helps keep expanded
        notificationLayout: bigPicture != null
            ? NotificationLayout.BigPicture
            : NotificationLayout.BigText,
        // summary: bigPicture != null ? body : null,
      ),
      schedule: schedule,
      actionButtons: actionButtons,
    );
  }

  /// Cancels a notification by its ID.
  ///
  /// [notificationId] - The ID of the notification to cancel.
  Future<void> cancelNotification(int notificationId) async {
    await AwesomeNotifications().cancel(notificationId);
  }

  /// Cancels all notifications.
  Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAll();
  }

  /// Resets the global notification badge count.
  Future<void> resetBadge() async {
    await AwesomeNotifications().resetGlobalBadge();
  }

  /// Checks if notifications are allowed and requests permission if not.
  Future<void> checkNotificationPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await requestNotificationPermission();
    }
  }

  /// Requests notification permission from the user.
  Future<void> requestNotificationPermission() async {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  // Private helper methods

  /// Starts listening for notification action events.
  Future<bool> _startListeningNotificationEvents() async {
    return await AwesomeNotifications().setListeners(
      onActionReceivedMethod: _onActionReceivedMethod,
    );
  }

  /// Handles actions when a notification button is pressed.

  /// Stores the notification ID in secure storage.
  ///
  /// [id] - The notification ID to store.
  Future<void> _storeNotificationId(String? id) async {
    // await SecureStorage.write(key: StorageKey.newOrderItem, value: id ?? '');
  }

  /// Builds action buttons for notifications if required.
  ///
  /// [showButton] - If true, includes an action button.
  List<NotificationActionButton>? _buildActionButtons(bool? showButton) {
    if (showButton ?? true) {
      return [
        NotificationActionButton(
            key: _accept,
            icon: '',
            showInCompactView: true,
            label: 'VIEW',
            requireInputText: false,
            autoDismissible: false,
            isDangerousOption: false,
            actionType: ActionType.Default),
        NotificationActionButton(
          key: _reject,
          icon: '',
          showInCompactView: true,
          label: 'DISMISS',
          requireInputText: false,
          autoDismissible: false,
          isDangerousOption: false,
          actionType: ActionType.DismissAction,
        ),
      ];
    }
    return null;
  }

  /// Navigates to the NewRequestScreen with the stored notification ID.
}
