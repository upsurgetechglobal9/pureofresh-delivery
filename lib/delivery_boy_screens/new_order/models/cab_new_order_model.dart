// To parse this JSON data, do
//
//     final cabRideDetailModel = cabRideDetailModelFromJson(jsonString);

import 'dart:convert';

CabRideDetailModel cabRideDetailModelFromJson(String str) =>
    CabRideDetailModel.fromJson(json.decode(str));

String cabRideDetailModelToJson(CabRideDetailModel data) =>
    json.encode(data.toJson());

class CabRideDetailModel {
  String errCode;
  Data data;

  CabRideDetailModel({
    required this.errCode,
    required this.data,
  });

  factory CabRideDetailModel.fromJson(Map<String, dynamic> json) =>
      CabRideDetailModel(
        errCode: json["err_code"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "err_code": errCode,
        "data": data.toJson(),
      };
}

class Data {
  String id;
  String status;
  String pickupDistance;
  String orderId;
  String grandTotal;
  String earnings;
  String totalBill;

  String droppingDistance;
  String pickupFrom;
  List<DroppingLocation> droppingLocations;
  String note;
  String customerName;
  String mobile;
  String image;
  String goodsType;
  String someoneName;
  String someoneMobile;
  String forWhom;
  String paymentMode;
  String couponCode;
  String couponCodeDiscount;
  String scheduleType;
  String pickupDate;
  String pickupTime;
  String remainingBalance;

  Data(
      {required this.id,
      required this.status,
      required this.pickupDistance,
      required this.orderId,
      required this.grandTotal,
      required this.earnings,
      required this.totalBill,
      required this.droppingDistance,
      required this.pickupFrom,
      required this.droppingLocations,
      required this.note,
      required this.customerName,
      required this.mobile,
      required this.image,
      required this.goodsType,
      required this.someoneName,
      required this.someoneMobile,
      required this.forWhom,
      required this.paymentMode,
      required this.couponCode,
      required this.couponCodeDiscount,
      required this.scheduleType,
      required this.pickupDate,
      required this.pickupTime,
      required this.remainingBalance});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      id: json["id"] ?? '',
      status: json["status"] ?? '',
      pickupDistance: json["pickup_distance"] ?? '',
      orderId: json["order_id"] ?? '',
      grandTotal: json["grand_total"] ?? '',
      earnings: json["earnings"] ?? '',
      totalBill: json["total_bill"] ?? '',
      droppingDistance: json["dropping_distance"] ?? '',
      pickupFrom: json["pickup_from"] ?? '',
      droppingLocations: List<DroppingLocation>.from(
          json["dropping_locations"].map((x) => DroppingLocation.fromJson(x))),
      note: json["note"] ?? '',
      customerName: json["customer_name"] ?? '',
      mobile: json["mobile"] ?? '',
      image: json["image"] ?? 'assets/images/default.png',
      goodsType: json['goods_type'] ?? '',
      forWhom: json['for_whom'] ?? '',
      someoneName: json['someone_name'] ?? '',
      someoneMobile: json['someone_mobile'] ?? '',
      paymentMode: json['payment_mode'] ?? '',
      couponCode: json['coupon_code'] ?? '',
      couponCodeDiscount: json['coupon_code_discount'] ?? '',
      scheduleType: json['schedule_type'] ?? 'no',
      pickupDate: json['pickup_date'] ?? '',
      pickupTime: json['pickup_time'] ?? '',
      remainingBalance: json['remaining_balance'] != null
          ? json['remaining_balance'].toString()
          : '');

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "pickup_distance": pickupDistance,
        "order_id": orderId,
        "grand_total": grandTotal,
        "earnings": earnings,
        "total_bill": totalBill,
        "dropping_distance": droppingDistance,
        "pickup_from": pickupFrom,
        "dropping_locations":
            List<dynamic>.from(droppingLocations.map((x) => x.toJson())),
        "note": note,
        "customer_name": customerName,
        "mobile": mobile,
        "image": image,
        'goods_type': goodsType,
        'for_whom': forWhom,
        'someone_name': someoneName,
        'someone_mobile': someoneMobile,
        'coupon_code_discount': couponCodeDiscount,
        'coupon_code': couponCode,
        'payment_mode': paymentMode,
        'schedule_type': scheduleType,
        'pickup_date': pickupDate,
        'pickup_time': pickupTime,
        'remaining_balance': remainingBalance
      };
}

class DroppingLocation {
  String id;
  String type;
  String lat;
  String lng;
  String address;
  String? personName;
  String? personNumber;
  bool status;

  DroppingLocation(
      {required this.id,
      required this.type,
      required this.lat,
      required this.lng,
      required this.address,
      this.personNumber,
      this.personName,
      required this.status});

  factory DroppingLocation.fromJson(Map<String, dynamic> json) =>
      DroppingLocation(
          id: json['id'] ?? '',
          type: json['type'] ?? '',
          lat: json["lat"] ?? '',
          lng: json["lng"] ?? '',
          address: json["address"],
          personName: json['person_name'] ?? '',
          personNumber: json['person_number'] ?? '',
          status: json['status']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "lat": lat,
        "lng": lng,
        "address": address,
        'person_name': personName,
        'person_number': personNumber,
        "status": status
      };
}
