import 'dart:convert';

NavigationDetailsModel navigationDetailsModelFromJson(String str) =>
    NavigationDetailsModel.fromJson(json.decode(str));
String navigationDetailsModelToJson(
        NavigationDetailsModel navigationDetailsModel) =>
    json.encode(navigationDetailsModel.toJson());

class NavigationDetailsModel {
  NavigationDetailsModel(
      {this.operationId,
      this.showNotification,
      this.isPickupAcceptNotification,
      this.isOrderAcceptNotification,
      this.body,
      this.title,
      this.image,
      this.apptype,
      this.androidChannelId});

  NavigationDetailsModel.fromJson(dynamic json) {
    operationId = json['operation_id'];
    showNotification = json['show_notification'];
    isPickupAcceptNotification = json['pickup_accept_notification'];
    isOrderAcceptNotification = json['order_accept_notification'];
    body = json['body'];
    title = json['title'];
    apptype = json['apptype'];
    image = json['image'];
    androidChannelId = json['android_channel_id'];
  }

  dynamic operationId;
  dynamic showNotification;
  dynamic isPickupAcceptNotification;
  dynamic isOrderAcceptNotification;
  dynamic body;
  dynamic title;
  dynamic image;
  dynamic apptype;
  dynamic androidChannelId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
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

  NavigationDetailsModel copyWith({
    String? operationId,
    String? showNotification,
    String? isPickupAcceptNotification,
    String? isOrderAcceptNotification,
    String? body,
    String? title,
    String? apptype,
    String? image,
    String? androidChannelId,
  }) {
    return NavigationDetailsModel(
      operationId: operationId ?? this.operationId,
      showNotification: showNotification ?? this.showNotification,
      isPickupAcceptNotification:
          isPickupAcceptNotification ?? this.isPickupAcceptNotification,
      isOrderAcceptNotification:
          isOrderAcceptNotification ?? this.isOrderAcceptNotification,
      body: body ?? this.body,
      title: title ?? this.title,
      apptype: apptype ?? this.apptype,
      image: image ?? this.image,
      androidChannelId: androidChannelId ?? this.androidChannelId,
    );
  }
}
