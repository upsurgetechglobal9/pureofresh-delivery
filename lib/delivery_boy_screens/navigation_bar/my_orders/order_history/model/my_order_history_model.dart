// To parse this JSON data, do
//
//     final myOrdersHistoryModel = myOrdersHistoryModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

MyOrdersHistoryModel myOrdersHistoryModelFromJson(String str) =>
    MyOrdersHistoryModel.fromJson(json.decode(str));

String myOrdersHistoryModelToJson(MyOrdersHistoryModel data) =>
    json.encode(data.toJson());

class MyOrdersHistoryModel {
  String errCode;
  String title;
  List<Datum> data;
  String totalEarnings;
  String date;

  MyOrdersHistoryModel({
    required this.errCode,
    required this.title,
    required this.data,
    required this.totalEarnings,
    required this.date,
  });

  factory MyOrdersHistoryModel.fromJson(Map<String, dynamic> json) =>
      MyOrdersHistoryModel(
        errCode: json["err_code"],
        title: json["title"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        totalEarnings: json["total_earnings"].toString(),
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "err_code": errCode,
        "title": title,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "total_earnings": totalEarnings,
        "date": date,
      };
}

class Datum {
  String refId;
  String serviceDateTime;
  String restaurantsId;
  String pickUpFrom;
  List<DropingAddress> dropingLocations;
  String deliveryPersonEarningAmount;
  String tipAmount;
  String restaurantName;
  String earningAmount;

  Datum({
    required this.refId,
    required this.serviceDateTime,
    required this.restaurantsId,
    required this.pickUpFrom,
    required this.dropingLocations,
    required this.deliveryPersonEarningAmount,
    required this.tipAmount,
    required this.restaurantName,
    required this.earningAmount,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    refId: json["ref_id"],
        serviceDateTime: json["service_date_time"],
        restaurantsId: json["restaurants_id"],
        pickUpFrom: json["from_location"]??"N/A",
        dropingLocations: List<DropingAddress>.from(json["destination_latlng_ar"].map((x) => DropingAddress.fromJson(x))),
        deliveryPersonEarningAmount:
            json["delivery_person_earning_amount"] ?? '',
        tipAmount: json["tip_amount"],
        restaurantName: json["restaurant_name"],
        earningAmount: json["earning_amount"].toString(),
      );

  Map<String, dynamic> toJson() => {
      "ref_id":refId,
        "service_date_time": serviceDateTime,
        "restaurants_id": restaurantsId,
        "from_location": pickUpFrom,
         "destination_latlng_ar": List<dynamic>.from(dropingLocations.map((x) => x.toJson())),
        "delivery_person_earning_amount": deliveryPersonEarningAmount,
        "tip_amount": tipAmount,
        "restaurant_name": restaurantName,
        "earning_amount": earningAmount,
      };
}

class DropingAddress {
  String lat;
  String lng;
  String address;

  DropingAddress({
    required this.lat,
    required this.lng,
    required this.address,
  });

  factory DropingAddress.fromJson(Map<String, dynamic> json) => DropingAddress(
        lat: json["lat"],
        lng: json["lng"] ?? "N/A",
        address:
            json["address"] ?? '',
      );

  Map<String, dynamic> toJson() => {

        "lat": lat,
        "lng": lng,
        "address": address,
      };
}



                // "id": "185",
                // "type": "cab",
                // "lat": "17.73680475708444",
                // "lng": "83.33451747894287",
                // "address": "1-117-1/1, Ushodaya Junction, Sector 13, MVP Colony, Visakhapatnam, Andhra Pradesh 530017, India",
                // "person_name": "",
                // "person_number": "",
                // "status": true
            
