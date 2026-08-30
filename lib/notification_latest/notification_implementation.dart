import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'awesome_notification/awesome_notification_service.dart';
import 'awesome_notification/notification_channel_service.dart';
import 'firebase_messaging/background_notification.dart';
import 'firebase_messaging/firebase_initialization.dart';
import 'firebase_messaging/foreground_message.dart';
import 'firebase_messaging/notification_device_token.dart';
import 'firebase_messaging/notification_permissions.dart';
import 'firebase_messaging/setup_interact_message.dart';

const String _messageKey = 'message';
const String _buzzer = 'buzzer_channel';
const String _normal = 'alerts';

/// A class to implement notification functionalities.
class NotificationImplementation {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final AwesomeChannelService awesomeChannelService;

  /// Constructor to initialize [NotificationImplementation].
  NotificationImplementation({
    required this.awesomeChannelService,
  });

  /// Initializes Awesome Notifications and creates notification channels.
  Future<void> initialize() async {
    // Initialize Awesome Notifications
    await awesomeChannelService.initializeChannels(
      channels: _createNotificationChannels(),
    );
  }

  /// Creates notification channels for the application.
  List<NotificationChannel> _createNotificationChannels() {
    return [
      awesomeChannelService.createChannel(
        criticalAlerts: true,
        channelKey: _normal,
        channelName: "Normal Notifications",
        channelDescription: "Notifications for normal alerts.",
        ledColor: Colors.green,
        defaultColor: Colors.red,
        importance: NotificationImportance.Max,
        channelShowBadge: false,
        defaultRingtoneType: DefaultRingtoneType.Notification,
        groupKey: 'normal_group', defaultPrivacy: NotificationPrivacy.Private,
      ),
      awesomeChannelService.createBuzzerChannel(
        criticalAlerts: true,
        channelKey: _buzzer,
        channelName: "Buzzer Notifications",
        channelDescription: "Buzzer for sound alerts.",
        ledColor: Colors.green,
        defaultColor: Colors.red,
        importance: NotificationImportance.Max,
        channelShowBadge: false,
        defaultRingtoneType: DefaultRingtoneType.Notification,
        groupKey: 'buzzer_group',
      ),
      awesomeChannelService.createChannel(
        channelKey: 'chuck_notifications',
        channelName: 'Chuck Inspector',
        channelDescription: 'Notifications for network inspection',
        importance: NotificationImportance.High,
        defaultPrivacy: NotificationPrivacy.Private,
        defaultColor: Colors.deepPurple,
        ledColor: Colors.deepPurple,
      ),
    ];
  }

  fcmInitialize() async {
    BackGroundNotification().backgroundInitializer();
    ForegroundMessage(firebaseMessaging).setForegroundNotificationOptions();
    NotificationPermissions(firebaseMessaging).requestNotificationPermission();
    NotificationDeviceToken(firebaseMessaging).getDeviceToken();
    AwesomeNotifications()
        .getInitialNotificationAction()
        .then((ReceivedAction? event) async {
      await actionMethod(event: event);
    });

    await clearOldNotifications();

    FirebaseInitialization(
      showNotification: showNotificationIfNew,
    ).firebaseInit();
    SetupInteractMessage(
      firebaseMessaging: firebaseMessaging,
    ).setupInteractMessage();
  }
}

Future<void> clearOldNotifications() async {
  // Check for old notifications and clear them if needed
  List<NotificationModel> pendingNotifications =
      await AwesomeNotifications().listScheduledNotifications();

  if (pendingNotifications.isNotEmpty) {
    await AwesomeNotifications()
        .cancelAll(); // Clears all scheduled notifications
  }
}

void showNotificationIfNew(Map<String, dynamic> data) async {
  // Ensure the notification is new before displaying it
  if (isNewNotification(data)) {
    await showNotification(data);
  }
}

bool isNewNotification(Map<String, dynamic> data) {
  String? messageId = data['messageId'] ?? data['operation_id'];
  return messageId != null &&
      !previouslyReceivedNotifications.contains(messageId);
}

Set<String> previouslyReceivedNotifications = {};

Future<void> _resetNotificationHandledFlag() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('notification_handled', false);
}

Future<void> showNotification(Map<String, dynamic> data) async {
  print("Notification Received From Firebase");
  print("Show noti ${data['order_accept_notification']}");
  _resetNotificationHandledFlag();
  if (data['order_accept_notification'].toString() == '2') {
    print("Show noti 2 ${data['order_accept_notification']}");
    await AwesomeNotifications().cancel(1);
  }
  if (data['order_accept_notification'].toString() == '1') {
    print("Show noti 1 ${data['order_accept_notification']}");
    await AwesomeNotifications().cancel(1);

    Map<String, String?>? payload = data.map((key, value) {
      return MapEntry(key, value?.toString());
    });

    AwesomeNotificationService().createChatNotification(
      title: data['title'],
      payload: payload,
      body: data['body'],
      bigPicture: data['image'],
      channelKey: _buzzer,
      uid: 1,
      notificationLayout:
          (data['image'] != null && data['image'].toString().isNotEmpty)
              ? NotificationLayout.BigPicture
              : NotificationLayout.BigText,
    );
  } else {
    if (data['order_accept_notification'].toString() != '2') {
      print("Normal Not sound");
      AwesomeNotificationService().createNotification(
        title: data['title'],
        body: data['body'],
        bigPicture: data['image'],
        channelKey: _normal,
        notificationLayout:
            (data['image'] != null && data['image'].toString().isNotEmpty)
                ? NotificationLayout.BigPicture
                : NotificationLayout.BigText,
        // uid: currentNotificationId, // ✅ Now within 32-bit range
      );
    }
  }
}

int generateSSID() {
  return DateTime.now().millisecondsSinceEpoch %
      2147483647; // Ensures it's within the 32-bit limit
}
