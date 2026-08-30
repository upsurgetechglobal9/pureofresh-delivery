// To parse this JSON data, do
//
//     final versionCheckModel = versionCheckModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

VersionCheckModel versionCheckModelFromJson(String str) =>
    VersionCheckModel.fromJson(json.decode(str));

String versionCheckModelToJson(VersionCheckModel data) =>
    json.encode(data.toJson());

class VersionCheckModel {
  String errCode;
  String forceUpdate;
  String message;
  String userAndroidAppLink;
  String userIosAppLink;

  VersionCheckModel({
    required this.errCode,
    required this.forceUpdate,
    required this.message,
    required this.userAndroidAppLink,
    required this.userIosAppLink,
  });

  factory VersionCheckModel.fromJson(Map<String, dynamic> json) =>
      VersionCheckModel(
        errCode: json["err_code"],
        forceUpdate: json["force_update"],
        message: json["message"],
        userAndroidAppLink: json["user_android_app_link"],
        userIosAppLink: json["user_ios_app_link"],
      );

  Map<String, dynamic> toJson() => {
        "err_code": errCode,
        "force_update": forceUpdate,
        "message": message,
        "user_android_app_link": userAndroidAppLink,
        "user_ios_app_link": userIosAppLink,
      };
}
