import 'package:meta/meta.dart';
import 'dart:convert';

CustomerTipsModel customerTipsModelFromJson(String str) =>
    CustomerTipsModel.fromJson(json.decode(str));

String customerTipsModelToJson(CustomerTipsModel data) =>
    json.encode(data.toJson());

class CustomerTipsModel {
  TipsData data;

  CustomerTipsModel({
    required this.data,
  });

  factory CustomerTipsModel.fromJson(Map<String, dynamic> json) =>
      CustomerTipsModel(
        data: TipsData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class TipsData {
  List<Result> results;
  String totalAmount;

  TipsData({
    required this.results,
    required this.totalAmount,
  });

  factory TipsData.fromJson(Map<String, dynamic> json) => TipsData(
        results:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
        totalAmount: json["total_amount"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_amount": totalAmount,
      };
}

class Result {
  String refId;
  String customerName;
  String tipAmount;
  String serviceDateTime;

  Result({
    required this.refId,
    required this.customerName,
    required this.tipAmount,
    required this.serviceDateTime,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        refId: json["ref_id"] ?? '',
        customerName: json["customer_name"] ?? '',
        tipAmount: json["tip_amount"] ?? '',
        serviceDateTime: json["service_date_time"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ref_id": refId,
        "customer_name": customerName,
        "tip_amount": tipAmount,
        "service_date_time": serviceDateTime,
      };
}
