// To parse this JSON data, do
//
//     final selectWorkAreaModel = selectWorkAreaModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SelectWorkAreaModel selectWorkAreaModelFromJson(String str) =>
    SelectWorkAreaModel.fromJson(json.decode(str));

String selectWorkAreaModelToJson(SelectWorkAreaModel data) =>
    json.encode(data.toJson());

class SelectWorkAreaModel {
  String errCode;
  String message;
  List<Datum> data;

  SelectWorkAreaModel({
    required this.errCode,
    required this.message,
    required this.data,
  });

  factory SelectWorkAreaModel.fromJson(Map<String, dynamic> json) =>
      SelectWorkAreaModel(
        errCode: json["err_code"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "err_code": errCode,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String id;
  String citiesId;
  String name;
  String createdAt;
  String updatedAt;
  String status;

  Datum({
    required this.id,
    required this.citiesId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        citiesId: json["cities_id"],
        name: json["name"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cities_id": citiesId,
        "name": name,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "status": status,
      };
}
