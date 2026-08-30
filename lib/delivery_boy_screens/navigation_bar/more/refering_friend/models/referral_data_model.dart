// To parse this JSON data, do
//
//     final referralsDataModel = referralsDataModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ReferralsDataModel referralsDataModelFromJson(String str) =>
    ReferralsDataModel.fromJson(json.decode(str));

String referralsDataModelToJson(ReferralsDataModel data) =>
    json.encode(data.toJson());

class ReferralsDataModel {
  String errCode;
  String title;
  String refAmount;
  String refWalletAmount;
  List<Datum> data;
  String message;

  ReferralsDataModel({
    required this.errCode,
    required this.title,
    required this.refAmount,
    required this.refWalletAmount,
    required this.data,
    required this.message,
  });

  factory ReferralsDataModel.fromJson(Map<String, dynamic> json) =>
      ReferralsDataModel(
        errCode: json["err_code"],
        title: json["title"],
        refAmount: json["ref_amount"] ?? '',
        refWalletAmount: json["ref_wallet_amount"] ?? "0",
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "err_code": errCode,
        "title": title,
        "ref_amount": refAmount,
        "ref_wallet_amount": refWalletAmount,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class Datum {
  String id;
  String dpId;
  String mobile;
  String name;
  String age;
  String vehicleType;
  String city;
  String workTime;
  String datetime;
  String status;

  Datum({
    required this.id,
    required this.dpId,
    required this.mobile,
    required this.name,
    required this.age,
    required this.vehicleType,
    required this.city,
    required this.workTime,
    required this.datetime,
    required this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        dpId: json["dp_id"],
        mobile: json["mobile"],
        name: json["name"],
        age: json["age"],
        vehicleType: json["vehicle_type"],
        city: json["city"],
        workTime: json["work_time"],
        datetime: json["datetime"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "dp_id": dpId,
        "mobile": mobile,
        "name": name,
        "age": age,
        "vehicle_type": vehicleType,
        "city": city,
        "work_time": workTime,
        "datetime": datetime,
        "status": status,
      };
}
