// To parse this JSON data, do
//
//     final ratingsViewModel = ratingsViewModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

RatingsViewModel ratingsViewModelFromJson(String str) =>
    RatingsViewModel.fromJson(json.decode(str));

String ratingsViewModelToJson(RatingsViewModel data) =>
    json.encode(data.toJson());

class RatingsViewModel {
  String errCode;
  String title;
  String message;
  String txtThisWeek;
  String txtLastWeek;
  Data data;

  RatingsViewModel({
    required this.errCode,
    required this.title,
    required this.message,
    required this.txtThisWeek,
    required this.txtLastWeek,
    required this.data,
  });

  factory RatingsViewModel.fromJson(Map<String, dynamic> json) =>
      RatingsViewModel(
        errCode: json["err_code"],
        title: json["title"],
        message: json["message"],
        txtThisWeek: json["txt_this_week"] ?? '-',
        txtLastWeek: json["txt_last_week"] ?? '-',
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "err_code": errCode,
        "title": title,
        "message": message,
        "txt_this_week": txtThisWeek,
        "txt_last_week": txtLastWeek,
        "data": data.toJson(),
      };
}

class Data {
  String thisWeek;
  String lastWeek;

  Data({
    required this.thisWeek,
    required this.lastWeek,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        thisWeek: json["this_week"],
        lastWeek: json["last_week"],
      );

  Map<String, dynamic> toJson() => {
        "this_week": thisWeek,
        "last_week": lastWeek,
      };
}
