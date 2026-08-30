// To parse this JSON data, do
//
//     final finesModel = finesModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

FinesModel finesModelFromJson(String str) =>
    FinesModel.fromJson(json.decode(str));

String finesModelToJson(FinesModel data) => json.encode(data.toJson());

class FinesModel {
  String errCode;
  String title;
  String message;
  Data data;

  FinesModel({
    required this.errCode,
    required this.title,
    required this.message,
    required this.data,
  });

  factory FinesModel.fromJson(Map<String, dynamic> json) => FinesModel(
        errCode: json["err_code"],
        title: json["title"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "err_code": errCode,
        "title": title,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  int totalResultsFound;
  int totalPages;
  List<Result> results;
  String totalAmount;

  Data({
    required this.totalResultsFound,
    required this.totalPages,
    required this.results,
    required this.totalAmount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalResultsFound: json["total_results_found"],
        totalPages: json["total_pages"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        totalAmount: json["total_amount"],
      );

  Map<String, dynamic> toJson() => {
        "total_results_found": totalResultsFound,
        "total_pages": totalPages,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_amount": totalAmount,
      };
}

class Result {
  String fineTypes;
  String agentName;
  String fineAmount;
  String dateTime;

  Result({
    required this.fineTypes,
    required this.agentName,
    required this.fineAmount,
    required this.dateTime,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        fineTypes: json["fine_types"],
        agentName: json["agent_name"],
        fineAmount: json["fine_amount"],
        dateTime: json["date_time"],
      );

  Map<String, dynamic> toJson() => {
        "fine_types": fineTypes,
        "agent_name": agentName,
        "fine_amount": fineAmount,
        "date_time": dateTime,
      };
}
