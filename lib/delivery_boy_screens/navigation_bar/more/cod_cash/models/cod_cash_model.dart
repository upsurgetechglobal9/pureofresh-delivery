// To parse this JSON data, do
//
//     final codCashModel = codCashModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CodCashModel codCashModelFromJson(String str) =>
    CodCashModel.fromJson(json.decode(str));

String codCashModelToJson(CodCashModel data) => json.encode(data.toJson());

class CodCashModel {
  String errCode;
  String title;
  String message;
  Data data;
  Orders orders;

  CodCashModel({
    required this.errCode,
    required this.title,
    required this.message,
    required this.data,
    required this.orders,
  });

  factory CodCashModel.fromJson(Map<String, dynamic> json) => CodCashModel(
        errCode: json["err_code"],
        title: json["title"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
        orders: Orders.fromJson(json["orders"]),
      );

  Map<String, dynamic> toJson() => {
        "err_code": errCode,
        "title": title,
        "message": message,
        "data": data.toJson(),
        "orders": orders.toJson(),
      };
}

class Data {
  String wallet;
  String limit;

  Data({
    required this.wallet,
    required this.limit,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        wallet: json["wallet"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
        "wallet": wallet,
        "limit": limit,
      };
}

class Orders {
  int totalResultsFound;
  int totalPages;
  List<Result> results;

  Orders({
    required this.totalResultsFound,
    required this.totalPages,
    required this.results,
  });

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        totalResultsFound: json["total_results_found"],
        totalPages: json["total_pages"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_results_found": totalResultsFound,
        "total_pages": totalPages,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  String refId;
  String customerName;
  String grandTotal;
  String serviceDateTime;

  Result({
    required this.refId,
    required this.customerName,
    required this.grandTotal,
    required this.serviceDateTime,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        refId: json["ref_id"] ?? '',
        customerName: json["customer_name"] ?? '',
        grandTotal: json["grand_total"] ?? '',
        serviceDateTime: json["service_date_time"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ref_id": refId,
        "customer_name": customerName,
        "grand_total": grandTotal,
        "service_date_time": serviceDateTime,
      };
}
