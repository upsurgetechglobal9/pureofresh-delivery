// To parse this JSON data, do
//
//     final attendanceDetailsModel = attendanceDetailsModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AttendanceDetailsModel attendanceDetailsModelFromJson(String str) =>
    AttendanceDetailsModel.fromJson(json.decode(str));

String attendanceDetailsModelToJson(AttendanceDetailsModel data) =>
    json.encode(data.toJson());

class AttendanceDetailsModel {
  String errCode;
  String title;
  String message;
  List<AttendanceDetail> attendanceDetails;

  AttendanceDetailsModel({
    required this.errCode,
    required this.title,
    required this.message,
    required this.attendanceDetails,
  });

  factory AttendanceDetailsModel.fromJson(Map<String, dynamic> json) =>
      AttendanceDetailsModel(
        errCode: json["err_code"],
        title: json["title"],
        message: json["message"],
        attendanceDetails: List<AttendanceDetail>.from(
            json["attendance_details"]
                .map((x) => AttendanceDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "err_code": errCode,
        "title": title,
        "message": message,
        "attendance_details":
            List<dynamic>.from(attendanceDetails.map((x) => x.toJson())),
      };
}

class AttendanceDetail {
  String date;
  String checkin;
  String checkout;

  AttendanceDetail({
    required this.date,
    required this.checkin,
    required this.checkout,
  });

  factory AttendanceDetail.fromJson(Map<String, dynamic> json) =>
      AttendanceDetail(
        date: json["date"] ?? '',
        checkin: json["checkin"] ?? '-',
        checkout: json["checkout"] ?? '-',
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "checkin": checkin,
        "checkout": checkout,
      };
}
