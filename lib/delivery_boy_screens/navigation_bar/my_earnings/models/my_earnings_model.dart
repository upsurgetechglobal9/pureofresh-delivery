// To parse this JSON data, do
//
//     final myEarningsModel = myEarningsModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

MyEarningsModel myEarningsModelFromJson(String str) =>
    MyEarningsModel.fromJson(json.decode(str));

String myEarningsModelToJson(MyEarningsModel data) =>
    json.encode(data.toJson());

class MyEarningsModel {
  String errCode;
  String title;
  String message;
  List<Datum> data;

  MyEarningsModel({
    required this.errCode,
    required this.title,
    required this.message,
    required this.data,
  });

  factory MyEarningsModel.fromJson(Map<String, dynamic> json) =>
      MyEarningsModel(
        errCode: json["err_code"],
        title: json["title"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "err_code": errCode,
        "title": title,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String planId;
  String incentiveDate;
  String noOfOrders;
  String incentiveAmount;
  String displayText;

  Datum({
    required this.planId,
    required this.incentiveDate,
    required this.noOfOrders,
    required this.incentiveAmount,
    required this.displayText,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        planId: json["plan_id"],
        incentiveDate: json["incentive_date"],
        noOfOrders: json["no_of_orders"],
        incentiveAmount: json["incentive_amount"],
        displayText: json["display_text"],
      );

  Map<String, dynamic> toJson() => {
        "plan_id": planId,
        "incentive_date": incentiveDate,
        "no_of_orders": noOfOrders,
        "incentive_amount": incentiveAmount,
        "display_text": displayText,
      };
}
