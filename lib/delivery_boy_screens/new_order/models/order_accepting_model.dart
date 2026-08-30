// To parse this JSON data, do
//
//     final orderAcceptResponseModel = orderAcceptResponseModelFromJson(jsonString);

import 'dart:convert';

OrderAcceptResponseModel orderAcceptResponseModelFromJson(String str) =>
    OrderAcceptResponseModel.fromJson(json.decode(str));

String orderAcceptResponseModelToJson(OrderAcceptResponseModel data) =>
    json.encode(data.toJson());

class OrderAcceptResponseModel {
  String errCode;
  String? title;
  String message;

  OrderAcceptResponseModel({
    required this.errCode,
    this.title,
    required this.message,
  });

  factory OrderAcceptResponseModel.fromJson(Map<String, dynamic> json) =>
      OrderAcceptResponseModel(
        errCode: json["err_code"],
        title: json["title"] ?? '',
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "err_code": errCode,
        "title": title,
        "message": message,
      };
}
