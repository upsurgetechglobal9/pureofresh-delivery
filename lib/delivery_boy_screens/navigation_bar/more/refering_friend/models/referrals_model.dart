// To parse this JSON data, do
//
//     final referralsListModel = referralsListModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ReferralsListModel referralsListModelFromJson(String str) =>
    ReferralsListModel.fromJson(json.decode(str));

String referralsListModelToJson(ReferralsListModel data) =>
    json.encode(data.toJson());

class ReferralsListModel {
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

  ReferralsListModel({
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

  factory ReferralsListModel.fromJson(Map<String, dynamic> json) =>
      ReferralsListModel(
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
