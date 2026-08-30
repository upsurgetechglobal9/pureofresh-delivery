// To parse this JSON data, do
//
//     final primaryCheckInModel = primaryCheckInModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

PrimaryCheckInModel primaryCheckInModelFromJson(String str) =>
    PrimaryCheckInModel.fromJson(json.decode(str));

String primaryCheckInModelToJson(PrimaryCheckInModel data) =>
    json.encode(data.toJson());

class PrimaryCheckInModel {
  String errCode;
  String title;
  String message;
  bool checkinStatus;
  bool checkoutStatus;

  PrimaryCheckInModel({
    required this.errCode,
    required this.title,
    required this.message,
    required this.checkinStatus,
    required this.checkoutStatus,
  });

  factory PrimaryCheckInModel.fromJson(Map<String, dynamic> json) =>
      PrimaryCheckInModel(
        errCode: json["err_code"],
        title: json["title"],
        message: json["message"],
        checkinStatus: json["checkin_status"],
        checkoutStatus: json["checkout_status"],
      );

  Map<String, dynamic> toJson() => {
        "err_code": errCode,
        "title": title,
        "message": message,
        "checkin_status": checkinStatus,
        "checkout_status": checkoutStatus,
      };
}
