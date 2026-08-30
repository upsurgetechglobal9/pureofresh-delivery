// To parse this JSON data, do
//
//     final underMaintenanceModel = underMaintenanceModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UnderMaintenanceModel underMaintenanceModelFromJson(String str) =>
    UnderMaintenanceModel.fromJson(json.decode(str));

String underMaintenanceModelToJson(UnderMaintenanceModel data) =>
    json.encode(data.toJson());

class UnderMaintenanceModel {
  String errCode;
  String message;
  Data data;

  UnderMaintenanceModel({
    required this.errCode,
    required this.message,
    required this.data,
  });

  factory UnderMaintenanceModel.fromJson(Map<String, dynamic> json) =>
      UnderMaintenanceModel(
        errCode: json["err_code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "err_code": errCode,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  String maintenanceModeEnabled;
  String title;
  String message;
  String image;

  Data({
    required this.maintenanceModeEnabled,
    required this.title,
    required this.message,
    required this.image,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        maintenanceModeEnabled: json["maintenance_mode_enabled"],
        title: json["title"],
        message: json["message"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "maintenance_mode_enabled": maintenanceModeEnabled,
        "title": title,
        "message": message,
        "image": image,
      };
}
