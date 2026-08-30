import 'dart:convert';

NotificationPayloadModel notificationPayloadModelFromJson(dynamic str) =>
    NotificationPayloadModel.fromJson(json.decode(str));
dynamic notificationPayloadModelToJson(NotificationPayloadModel data) =>
    json.encode(data.toJson());

class NotificationPayloadModel {
  NotificationPayloadModel(
      {this.operationId,
      this.showNotification,
      this.isPickupAcceptNotification,
      this.isOrderAcceptNotification,
      this.body,
      this.title,
      this.apptype,
      this.androidChannelId,
      this.image});

  NotificationPayloadModel.fromJson(dynamic json) {
    operationId = json['operation_id'];
    showNotification = json['show_notification'] ?? "1";
    isPickupAcceptNotification = json['pickup_accept_notification'] ?? "1";
    isOrderAcceptNotification = json['order_accept_notification'] ?? "1";
    body = json['body']??'';
    title = json['title']??'';
    apptype = json['apptype']??'';
    image = json['image']??'';
    androidChannelId = json['android_channel_id']??'';
  }
  dynamic operationId;
  dynamic showNotification;
  dynamic isPickupAcceptNotification;
  dynamic isOrderAcceptNotification;
  dynamic body;
  dynamic title;
  dynamic apptype;
  dynamic image;
  dynamic androidChannelId;

  Map<dynamic, dynamic> toJson() {
    final map = <dynamic, dynamic>{};
    map['operation_id'] = operationId;
    map['show_notification'] = showNotification;
    map['pickup_accept_notification'] = isPickupAcceptNotification;
    map['order_accept_notification'] = isOrderAcceptNotification;
    map['body'] = body;
    map['title'] = title;
    map['apptype'] = apptype;
    map['image'] = image;
    map['android_channel_id'] = androidChannelId;
    return map;
  }

  Map<String, String?> toMap() {
    return {
      'operation_id': operationId,
      'show_notification': showNotification,
      'pickup_accept_notification': isPickupAcceptNotification,
      'order_accept_notification': isOrderAcceptNotification,
      'body': body,
      'title': title,
      'apptype': apptype,
      'image': image,
      'android_channel_id': androidChannelId,
    };
  }
}

// class NotificationPayloadModel {
//   final String? operationId;
//   final bool showNotification;
//   final bool isOrderAcceptNotification;
//   final bool isPickupAcceptNotification;
//   final String? apptype;
//   final String? title;
//   final String? body;

//   NotificationPayloadModel(
//       {required this.operationId,
//       required this.showNotification,
//       required this.isOrderAcceptNotification,
//       required this.isPickupAcceptNotification,
//       this.title,
//       this.body,
//       this.apptype});

//   factory NotificationPayloadModel.fromMap(Map<String, dynamic> map) {
//     return NotificationPayloadModel(
//         operationId: map['operation_id'],
//         showNotification: map['show_notification'] == "1",
//         isOrderAcceptNotification: map['order_accept_notification'] == "1",
//         isPickupAcceptNotification: map['pickup_accept_notification'] == "1",
//         title: map['title'],
//         body: map['body'],
//         apptype: map['apptype']);
//   }

//   Map<String, String?> toMap() {
//     return <String, String?>{
//       'operation_id': operationId,

//       //here need to convert the bool to string,
//       //because the notification payload only accept strings
//       'show_notification': showNotification ? "1" : "0",
//       'order_accept_notification': isOrderAcceptNotification ? "1" : "0",
//       'pickup_accept_notification': isPickupAcceptNotification ? "1" : "0",
//       'title': title,
//       'body': body,
//       'apptype': apptype
//     };
//   }
// }
