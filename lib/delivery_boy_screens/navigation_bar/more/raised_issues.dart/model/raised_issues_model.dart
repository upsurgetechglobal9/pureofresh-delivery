// To parse this JSON data, do
//
//     final raisedIssuesModel = raisedIssuesModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

RaisedIssuesModel raisedIssuesModelFromJson(String str) =>
    RaisedIssuesModel.fromJson(json.decode(str));

String raisedIssuesModelToJson(RaisedIssuesModel data) =>
    json.encode(data.toJson());

class RaisedIssuesModel {
  String errCode;
  String title;
  String message;
  List<Datum> data;

  RaisedIssuesModel({
    required this.errCode,
    required this.title,
    required this.message,
    required this.data,
  });

  factory RaisedIssuesModel.fromJson(Map<String, dynamic> json) =>
      RaisedIssuesModel(
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
  String id;
  String dpId;
  String name;
  String email;
  String phone;
  String orderId;
  String transactionId;
  String description;
  String image;

  Datum({
    required this.id,
    required this.dpId,
    required this.name,
    required this.email,
    required this.phone,
    required this.orderId,
    required this.transactionId,
    required this.description,
    required this.image,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] ?? '',
        dpId: json["dp_id"] ?? '',
        name: json["name"] ?? '',
        email: json["email"] ?? '',
        phone: json["phone"] ?? '',
        orderId: json["order_id"] ?? '',
        transactionId: json["transaction_id"] ?? '',
        description: json["description"] ?? '',
        image: json["image"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "dp_id": dpId,
        "name": name,
        "email": email,
        "phone": phone,
        "order_id": orderId,
        "transaction_id": transactionId,
        "description": description,
        "image": image,
      };
}
