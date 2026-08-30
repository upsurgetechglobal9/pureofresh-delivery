// To parse this JSON data, do
//
//     final myOrdersRideModel = myOrdersRideModelFromJson(jsonString);

import 'dart:convert';

MyOrdersRideModel myOrdersRideModelFromJson(String str) =>
    MyOrdersRideModel.fromJson(json.decode(str));

String myOrdersRideModelToJson(MyOrdersRideModel data) =>
    json.encode(data.toJson());

class MyOrdersRideModel {
  String errCode;
  List<Datum> data;

  MyOrdersRideModel({
    required this.errCode,
    required this.data,
  });

  factory MyOrdersRideModel.fromJson(Map<String, dynamic> json) =>
      MyOrdersRideModel(
        errCode: json["err_code"],
        data:
            List<Datum>.from(json["data"].map((x) => Datum.fromJson(x ?? {}))),
      );

  Map<String, dynamic> toJson() => {
        "err_code": errCode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String id;
  String pickupDistance;
  String orderId;
  String grandTotal;
  String droppingDistance;
  String pickupFrom;
  List<DroppingLocation> droppingLocations;
  String note;
  String status;

  Datum(
      {required this.id,
      required this.pickupDistance,
      required this.orderId,
      required this.grandTotal,
      required this.droppingDistance,
      required this.pickupFrom,
      required this.droppingLocations,
      required this.note,
      required this.status});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] ?? '',
        pickupDistance: json["pickup_distance"] ?? '',
        orderId: json["order_id"] ?? '',
        grandTotal: json["grand_total"] ?? '',
        droppingDistance: json["dropping_distance"] ?? '',
        pickupFrom: json["pickup_from"] ?? '',
        droppingLocations: json["dropping_locations"] == null
            ? []
            : List<DroppingLocation>.from(json["dropping_locations"]
                .map((x) => DroppingLocation.fromJson(x))),
        note: json["note"] ?? '',
        status: json['status'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pickup_distance": pickupDistance,
        "order_id": orderId,
        "grand_total": grandTotal,
        "dropping_distance": droppingDistance,
        "pickup_from": pickupFrom,
        "dropping_locations": droppingLocations == null
            ? []
            : List<dynamic>.from(droppingLocations.map((x) => x.toJson())),
        "note": note,
        "status": status,
      };
}

class DroppingLocation {
  String lat;
  String lng;
  String address;
  String? personName;
  String? personNumber;

  DroppingLocation({
    required this.lat,
    required this.lng,
    required this.address,
    this.personName,
    this.personNumber,
  });

  factory DroppingLocation.fromJson(Map<String, dynamic> json) =>
      DroppingLocation(
        lat: json["lat"] ?? '',
        lng: json["lng"] ?? '',
        address: json["address"] ?? '',
        personName: json["person_name"] ?? '',
        personNumber: json["person_number"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
        "address": address,
        "person_name": personName,
        "person_number": personNumber,
      };
}
