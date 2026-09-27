import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';

import '../../firebase_options.dart';
import '../notification_implementation.dart';

@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('Handling a background message: ${message.messageId}');
  print('Background payload data: ${message.data}');

  Map<String, dynamic> data = Map<String, dynamic>.from(message.data);
  if (message.notification != null) {
    data['title'] ??= message.notification?.title;
    data['body'] ??= message.notification?.body;
  }

  if (data.isNotEmpty) {
    await showNotification(data);
  }
}

class BackGroundNotification {
  /// Initializes background notification handling.
  void backgroundInitializer() {
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  }
}
