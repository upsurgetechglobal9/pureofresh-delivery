// To parse this JSON data, do
//
//     final singleOngoingOrderModel = singleOngoingOrderModelFromJson(jsonString);

import 'dart:convert';

SingleOngoingOrderModel singleOngoingOrderModelFromJson(String str) =>
    SingleOngoingOrderModel.fromJson(json.decode(str));

String singleOngoingOrderModelToJson(SingleOngoingOrderModel data) =>
    json.encode(data.toJson());

class SingleOngoingOrderModel {
  String errCode;
  List<SingleOngoingOrder> data;

  SingleOngoingOrderModel({
    required this.errCode,
    required this.data,
  });

  factory SingleOngoingOrderModel.fromJson(Map<String, dynamic> json) =>
      SingleOngoingOrderModel(
        errCode: json["err_code"],
        data: List<SingleOngoingOrder>.from(
            json["data"].map((x) => SingleOngoingOrder.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "err_code": errCode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class SingleOngoingOrder {
  String id;
  String orderId;
  String grandTotal;
  String droppingDistance;
  String status;
  String type;
  String serviceDateTime;

  SingleOngoingOrder({
    required this.id,
    required this.orderId,
    required this.grandTotal,
    required this.droppingDistance,
    required this.status,
    required this.type,
    required this.serviceDateTime,
  });

  factory SingleOngoingOrder.fromJson(Map<String, dynamic> json) =>
      SingleOngoingOrder(
        id: json["id"] ?? '',
        orderId: json["order_id"] ?? '',
        grandTotal: json["grand_total"] ?? '',
        droppingDistance: json["dropping_distance"] ?? '',
        status: json["status"] ?? '',
        type: json["type"] ?? '',
        serviceDateTime: json["service_date_time"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "grand_total": grandTotal,
        "dropping_distance": droppingDistance,
        "status": status,
        "type": type,
        "service_date_time": serviceDateTime,
      };
}
