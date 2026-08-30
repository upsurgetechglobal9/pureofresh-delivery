// To parse this JSON data, do
//
//     final myOrdersDetailsModel = myOrdersDetailsModelFromJson(jsonString);

import 'dart:convert';

MyOrdersDetailsModel myOrdersDetailsModelFromJson(String str) =>
    MyOrdersDetailsModel.fromJson(json.decode(str));

String myOrdersDetailsModelToJson(MyOrdersDetailsModel data) =>
    json.encode(data.toJson());

class MyOrdersDetailsModel {
  String errCode;
  String title;
  String message;
  Data data;

  MyOrdersDetailsModel({
    required this.errCode,
    required this.title,
    required this.message,
    required this.data,
  });

  factory MyOrdersDetailsModel.fromJson(Map<String, dynamic> json) =>
      MyOrdersDetailsModel(
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
  String totalResultsFound;
  int totalPages;
  List<Result> results;
  TotalEarnings totalEarnings;

  Data({
    required this.totalResultsFound,
    required this.totalPages,
    required this.results,
    required this.totalEarnings,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalResultsFound: json["total_results_found"] == null
            ? json["total_results_found"].toString()
            : '',
        totalPages: json["total_pages"] ?? 0,
        results: json['results'] == null
            ? []
            : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        totalEarnings: TotalEarnings.fromJson(json["total_earnings"]),
      );

  Map<String, dynamic> toJson() => {
        "total_results_found": totalResultsFound,
        "total_pages": totalPages,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_earnings": totalEarnings.toJson(),
      };
}

class Result {
  String serviceDate;
  String displayServiceDate;
  String tipAmount;
  String deliveryPersonEarningAmount;
  String earnings;
  String dutyTimings;
  String date;
  String type;

  Result({
    required this.serviceDate,
    required this.displayServiceDate,
    required this.tipAmount,
    required this.deliveryPersonEarningAmount,
    required this.earnings,
    required this.dutyTimings,
    required this.date,
    required this.type,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        serviceDate: json["service_date"] ?? '',
        displayServiceDate: json["display_service_date"] ?? '',
        tipAmount: json["tip_amount"].toString() ?? '0.00',
        deliveryPersonEarningAmount:
            json["delivery_person_earning_amount"] ?? '0.00',
        earnings: json["earnings"] ?? '0.00',
        dutyTimings: json["duty_timings"] ?? '',
        date: json["date"] ?? '',
        type: json["type"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "service_date": serviceDate,
        "display_service_date": displayServiceDate,
        "tip_amount": tipAmount,
        "delivery_person_earning_amount": deliveryPersonEarningAmount,
        "earnings": earnings,
        "duty_timings": dutyTimings,
        "date": date,
        "type": type,
      };
}

class TotalEarnings {
  String tips;
  String earnings;
  String incentives;
  String dutyTimings;
  String fromDate;
  String toDate;
  String totalEarning;

  TotalEarnings({
    required this.tips,
    required this.earnings,
    required this.incentives,
    required this.dutyTimings,
    required this.fromDate,
    required this.toDate,
    required this.totalEarning,
  });

  factory TotalEarnings.fromJson(Map<String, dynamic> json) => TotalEarnings(
        tips: json["tips"] == null ? '0.00' : json["tips"].toString(),
        earnings:
            json["earnings"] == null ? '0.00' : json["earnings"].toString(),
        incentives:
            json["incentives"] == null ? '0.00' : json["incentives"].toString(),
        dutyTimings: json["duty_timings"] ?? '',
        fromDate: json["from_date"] ?? '',
        toDate: json["to_date"] ?? '',
        totalEarning: json["total_earning"] == null
            ? '0.00'
            : json["total_earning"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "tips": tips,
        "earnings": earnings,
        "incentives": incentives,
        "duty_timings": dutyTimings,
        "from_date": fromDate,
        "to_date": toDate,
        "total_earning": totalEarning,
      };
}
