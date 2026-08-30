// To parse this JSON data, do
//
//     final customerTipsList = customerTipsListFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CustomerTipsList customerTipsListFromJson(String str) =>
    CustomerTipsList.fromJson(json.decode(str));

String customerTipsListToJson(CustomerTipsList data) =>
    json.encode(data.toJson());

class CustomerTipsList {
  String refId;
  String customerName;
  String tipAmount;
  String serviceDateTime;

  CustomerTipsList({
    required this.refId,
    required this.customerName,
    required this.tipAmount,
    required this.serviceDateTime,
  });

  factory CustomerTipsList.fromJson(Map<String, dynamic> json) =>
      CustomerTipsList(
        refId: json["ref_id"],
        customerName: json["customer_name"],
        tipAmount: json["tip_amount"],
        serviceDateTime: json["service_date_time"],
      );

  Map<String, dynamic> toJson() => {
        "ref_id": refId,
        "customer_name": customerName,
        "tip_amount": tipAmount,
        "service_date_time": serviceDateTime,
      };
}
