// To parse this JSON data, do
//
//     final referAFriendModel = referAFriendModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ReferAFriendModel referAFriendModelFromJson(String str) =>
    ReferAFriendModel.fromJson(json.decode(str));

String referAFriendModelToJson(ReferAFriendModel data) =>
    json.encode(data.toJson());

class ReferAFriendModel {
  String errCode;
  String title;
  String message;

  ReferAFriendModel({
    required this.errCode,
    required this.title,
    required this.message,
  });

  factory ReferAFriendModel.fromJson(Map<String, dynamic> json) =>
      ReferAFriendModel(
        errCode: json["err_code"],
        title: json["title"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "err_code": errCode,
        "title": title,
        "message": message,
      };
}
