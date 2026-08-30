

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../main.dart';
import '../notification/controller/notification_controller.dart';

void addChuck(Dio dio) {
  if (kDebugMode && chuck != null) {
    dio.interceptors.add(chuck!.dioInterceptor);
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (response, handler) {
        print("Chuck Custom Interceptor: Response received for ${response.requestOptions.uri}");
        NotificationController.showNotification(
          notificationContent: NotificationContent(
            id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
            channelKey: 'chuck_notifications',
            title: 'HTTP: ${response.requestOptions.method} ${response.statusCode}',
            body: '${response.requestOptions.uri}',
            notificationLayout: NotificationLayout.Default,
            payload: {'type': 'chuck_inspector'},
          ),
        );
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print("Chuck Custom Interceptor: Error received for ${e.requestOptions.uri}");
        NotificationController.showNotification(
          notificationContent: NotificationContent(
            id: DateTime.now().millisecondsSinceEpoch.remainder(100000) + 100000,
            channelKey: 'chuck_notifications',
            title: 'HTTP Error: ${e.requestOptions.method} ${e.response?.statusCode ?? 'N/A'}',
            body: '${e.requestOptions.uri}\n${e.message}',
            notificationLayout: NotificationLayout.Default,
            payload: {'type': 'chuck_inspector'},
          ),
        );
        return handler.next(e);
      },
    ));
  }
}