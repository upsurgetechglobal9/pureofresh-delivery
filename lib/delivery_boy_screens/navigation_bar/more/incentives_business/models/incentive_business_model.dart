// To parse this JSON data, do
//
//     final incentivesDataModel = incentivesDataModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

IncentivesDataModel incentivesDataModelFromJson(String str) =>
    IncentivesDataModel.fromJson(json.decode(str));

String incentivesDataModelToJson(IncentivesDataModel data) =>
    json.encode(data.toJson());

class IncentivesDataModel {
  String errCode;
  String title;
  String message;
  List<Datum> data;

  IncentivesDataModel({
    required this.errCode,
    required this.title,
    required this.message,
    required this.data,
  });

  factory IncentivesDataModel.fromJson(Map<String, dynamic> json) =>
      IncentivesDataModel(
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
  String type;
  String title;
  String fromdate;
  String todate;
  String fromtime;
  String totime;
  String createdAt;
  String updatedAt;
  String status;
  List<Plan> plans;
  List<Condition> conditions;

  Datum({
    required this.id,
    required this.type,
    required this.title,
    required this.fromdate,
    required this.todate,
    required this.fromtime,
    required this.totime,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.plans,
    required this.conditions,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        type: json["type"],
        title: json["title"],
        fromdate: json["fromdate"],
        todate: json["todate"],
        fromtime: json["fromtime"],
        totime: json["totime"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        status: json["status"],
        plans: List<Plan>.from(json["plans"].map((x) => Plan.fromJson(x))),
        conditions: List<Condition>.from(
            json["conditions"].map((x) => Condition.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "title": title,
        "fromdate": fromdate,
        "todate": todate,
        "fromtime": fromtime,
        "totime": totime,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "status": status,
        "plans": List<dynamic>.from(plans.map((x) => x.toJson())),
        "conditions": List<dynamic>.from(conditions.map((x) => x.toJson())),
      };
}

class Condition {
  String id;
  String incentiveId;
  String conditions;
  String createdAt;
  String updatedAt;
  String status;

  Condition({
    required this.id,
    required this.incentiveId,
    required this.conditions,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  factory Condition.fromJson(Map<String, dynamic> json) => Condition(
        id: json["id"],
        incentiveId: json["incentive_id"],
        conditions: json["conditions"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "incentive_id": incentiveId,
        "conditions": conditions,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "status": status,
      };
}

class Plan {
  String id;
  String incentiveId;
  String noOfOrders;
  String incentiveAmount;
  String createdAt;
  String updatedAt;
  String status;

  Plan({
    required this.id,
    required this.incentiveId,
    required this.noOfOrders,
    required this.incentiveAmount,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        id: json["id"],
        incentiveId: json["incentive_id"],
        noOfOrders: json["no_of_orders"],
        incentiveAmount: json["incentive_amount"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "incentive_id": incentiveId,
        "no_of_orders": noOfOrders,
        "incentive_amount": incentiveAmount,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "status": status,
      };
}
