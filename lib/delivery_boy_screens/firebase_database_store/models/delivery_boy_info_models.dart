// To parse this JSON data, do
//
//     final firebaseDriverProfileDetailsModel = firebaseDriverProfileDetailsModelFromJson(jsonString);

import 'dart:convert';

List<FirebaseDriverProfileDetailsModel>
    firebaseDriverProfileDetailsModelFromJson(String str) =>
        List<FirebaseDriverProfileDetailsModel>.from(json
            .decode(str)
            .map((x) => FirebaseDriverProfileDetailsModel.fromJson(x)));

String firebaseDriverProfileDetailsModelToJson(
        List<FirebaseDriverProfileDetailsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FirebaseDriverProfileDetailsModel {
  String driverId;
  double driverLatitude;
  double driverLongitude;

  FirebaseDriverProfileDetailsModel({
    required this.driverId,
    required this.driverLatitude,
    required this.driverLongitude,
  });

  factory FirebaseDriverProfileDetailsModel.fromJson(
          Map<String, dynamic> json) =>
      FirebaseDriverProfileDetailsModel(
        driverId: json["driver_id"],
        driverLatitude: json["driver_latitude"],
        driverLongitude: json["driver_longitude"],
      );

  Map<String, dynamic> toJson() => {
        "driver_id": driverId,
        "driver_latitude": driverLatitude,
        "driver_longitude": driverLongitude,
      };
}
