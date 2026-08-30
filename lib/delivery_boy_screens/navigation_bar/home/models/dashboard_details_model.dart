// To parse this JSON data, do
//
//     final dashBoardDetailsModel = dashBoardDetailsModelFromJson(jsonString);

import 'dart:convert';

DashBoardDetailsModel dashBoardDetailsModelFromJson(String str) =>
    DashBoardDetailsModel.fromJson(json.decode(str));

String dashBoardDetailsModelToJson(DashBoardDetailsModel data) =>
    json.encode(data.toJson());

class DashBoardDetailsModel {
  String errCode;
  String title;
  String message;
  bool checkinStatus;

  Data data;

  DashBoardDetailsModel({
    required this.errCode,
    required this.title,
    required this.message,
    required this.checkinStatus,
    required this.data,
  });

  factory DashBoardDetailsModel.fromJson(Map<String, dynamic> json) =>
      DashBoardDetailsModel(
        errCode: json["err_code"],
        title: json["title"],
        message: json["message"],
        checkinStatus: json["checkin_status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "err_code": errCode,
        "title": title,
        "message": message,
        "checkin_status": checkinStatus,
        "data": data.toJson(),
      };
}

class Data {
  String name;
  String image;
  String totalRating;
  String totalEarnings;
  String flemid;
  List<Ad> ads;
  String trips;
  String cashwallet;
  String codWalletAmount;

  String weekEarnings;
  String todayEarnings;
  String todayDistanceTravelled;
  String ordersAcceptedToday;
  String notificationCount;
  List<dynamic> ongoingOrdersList;
  List<IncentivesInfo> incentivesInfo;
  bool vehicleDetails;
  bool locationDetails;
  bool verificationDetails;
  bool verificationStatus;
  bool deliveryPreferncesStatus;


  Data({
    required this.name,
    required this.image,
    required this.totalRating,
    required this.totalEarnings,
    required this.flemid,
    required this.ads,
    required this.trips,
    required this.cashwallet,
    required this.codWalletAmount,
    required this.weekEarnings,
    required this.todayEarnings,
    required this.todayDistanceTravelled,
    required this.ordersAcceptedToday,
    required this.notificationCount,
    required this.ongoingOrdersList,
    required this.incentivesInfo,
    required this.vehicleDetails,
    required this.locationDetails,
    required this.verificationDetails,
    required this.verificationStatus,
    required this.deliveryPreferncesStatus,

  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"],
        image: json["image"],
        totalRating: json["total_rating"].toString(),
        totalEarnings: json["total_earnings"]?.toString() ?? "0.00",
        flemid: json["flemid"].toString(),
        ads: json["ads"] is List
            ? List<Ad>.from(json["ads"].map((x) => Ad.fromJson(x)))
            : [],
        trips: json["trips"].toString(),
        cashwallet: json["cashwallet"]?.toString() ?? '0',
        codWalletAmount: json["codwallet_amount"]?.toString() ?? '0',
        weekEarnings: json["week_earnings"].toString(),
        todayEarnings: json["today_earnings"].toString(),
        todayDistanceTravelled: json["today_distance_travelled"].toString(),
        ordersAcceptedToday: json["orders_accepted_today"].toString(),
        notificationCount: json["notification_count"].toString(),
        ongoingOrdersList: json["ongoing_orders_list"] is List
            ? List<dynamic>.from(json["ongoing_orders_list"].map((x) => x))
            : [],
        incentivesInfo: json["incentives_info"] is List
            ? List<IncentivesInfo>.from(
                json["incentives_info"].map((x) => IncentivesInfo.fromJson(x)))
            : [],
        vehicleDetails: json["vehicle_details"],
        locationDetails: json["location_details"],
        verificationDetails: json["verification_details"],
        verificationStatus: json["verification_status"],
        deliveryPreferncesStatus: json["is_preferences_status"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "total_rating": totalRating,
        "total_earnings": totalEarnings,
        "flemid": flemid,
        "ads": List<dynamic>.from(ads.map((x) => x.toJson())),
        "trips": trips,
        "cashwallet": cashwallet,
        "codwallet_amount": codWalletAmount,
        "week_earnings": weekEarnings,
        "today_earnings": todayEarnings,
        "today_distance_travelled": todayDistanceTravelled,
        "orders_accepted_today": ordersAcceptedToday,
        "notification_count": notificationCount,
        "ongoing_orders_list":
            List<dynamic>.from(ongoingOrdersList.map((x) => x)),
        "incentives_info":
            List<dynamic>.from(incentivesInfo.map((x) => x.toJson())),
        "vehicle_details": vehicleDetails,
        "location_details": locationDetails,
        "verification_details": verificationDetails,
        "verification_status": verificationStatus,
        "is_preferences_status": deliveryPreferncesStatus,

      };
}

class Ad {
  String id;
  String image;
  String createdAt;
  String updatedAt;
  String displayOrder;
  String status;
  String citiesId;

  Ad({
    required this.id,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.displayOrder,
    required this.status,
    required this.citiesId,
  });

  factory Ad.fromJson(Map<String, dynamic> json) => Ad(
        id: json["id"].toString(),
        image: json["image"]?.toString() ?? "",
        createdAt: json["created_at"]?.toString() ?? "",
        updatedAt: json["updated_at"]?.toString() ?? "",
        displayOrder: json["display_order"].toString(),
        status: json["status"].toString(),
        citiesId: json["cities_id"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "display_order": displayOrder,
        "status": status,
        "cities_id": citiesId,
      };
}

class IncentivesInfo {
  String planId;
  String noOfOrders;
  String incentiveAmount;
  String planType;
  String planTitle;
  String displayText;

  IncentivesInfo({
    required this.planId,
    required this.noOfOrders,
    required this.incentiveAmount,
    required this.planType,
    required this.planTitle,
    required this.displayText,
  });

  factory IncentivesInfo.fromJson(Map<String, dynamic> json) => IncentivesInfo(
        planId: json["plan_id"].toString(),
        noOfOrders: json["no_of_orders"].toString(),
        incentiveAmount: json["incentive_amount"].toString(),
        planType: json["plan_type"]?.toString() ?? "",
        planTitle: json["plan_title"]?.toString() ?? "",
        displayText: json["display_text"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "plan_id": planId,
        "no_of_orders": noOfOrders,
        "incentive_amount": incentiveAmount,
        "plan_type": planType,
        "plan_title": planTitle,
        "display_text": displayText,
      };
}
