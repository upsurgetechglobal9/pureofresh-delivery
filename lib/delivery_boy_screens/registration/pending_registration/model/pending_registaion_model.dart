// To parse this JSON data, do
//
//     final registrationPendingModel = registrationPendingModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

RegistrationPendingModel registrationPendingModelFromJson(String str) =>
    RegistrationPendingModel.fromJson(json.decode(str));

String registrationPendingModelToJson(RegistrationPendingModel data) =>
    json.encode(data.toJson());

class RegistrationPendingModel {
  String errCode;
  String title;
  Data data;

  RegistrationPendingModel({
    required this.errCode,
    required this.title,
    required this.data,
  });

  factory RegistrationPendingModel.fromJson(Map<String, dynamic> json) =>
      RegistrationPendingModel(
        errCode: json["err_code"],
        title: json["title"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "err_code": errCode,
        "title": title,
        "data": data.toJson(),
      };
}

class Data {
  bool vehicleDetails;
  bool locationDetails;
  bool verificationDetails;

  Data({
    required this.vehicleDetails,
    required this.locationDetails,
    required this.verificationDetails,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        vehicleDetails: json["vehicle_details"],
        locationDetails: json["location_details"],
        verificationDetails: json["verification_details"],
      );

  Map<String, dynamic> toJson() => {
        "vehicle_details": vehicleDetails,
        "location_details": locationDetails,
        "verification_details": verificationDetails,
      };
}
