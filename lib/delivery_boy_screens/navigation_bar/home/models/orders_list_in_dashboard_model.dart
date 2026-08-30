// To parse this JSON data, do
//
//     final myOrdersListDashBoardModel = myOrdersListDashBoardModelFromJson(jsonString);

import 'dart:convert';

MyOrdersListDashBoardModel myOrdersListDashBoardModelFromJson(String str) =>
    MyOrdersListDashBoardModel.fromJson(json.decode(str));

String myOrdersListDashBoardModelToJson(MyOrdersListDashBoardModel data) =>
    json.encode(data.toJson());

class MyOrdersListDashBoardModel {
  String errCode;
  String title;
  String message;
  Data data;

  MyOrdersListDashBoardModel({
    required this.errCode,
    required this.title,
    required this.message,
    required this.data,
  });

  factory MyOrdersListDashBoardModel.fromJson(Map<String, dynamic> json) =>
      MyOrdersListDashBoardModel(
        errCode: json["err_code"] ?? '',
        title: json["title"] ?? '',
        message: json["message"] ?? '',
        data: json["data"] == null
            ? Data(totalResultsFound: 0, totalPages: 0, results: [])
            : Data.fromJson(json["data"]),
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

  Data({
    required this.totalResultsFound,
    required this.totalPages,
    required this.results,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalResultsFound: json["total_results_found"] ?? '',
        totalPages: json["total_pages"] ?? '',
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_results_found": totalResultsFound,
        "total_pages": totalPages,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  String refId;
  String customersId;
  String restaurantsId;
  String serviceDate;
  String serviceDateTime;
  String deliveryLat;
  String deliveryLng;
  String restaurantLat;
  String restaurantLng;
  String landmark;
  String doorNo;
  String address;
  String grandTotal;
  String serviceStatus;
  String distanceToCustomerFromStore;
  String deliveryPersonsId;
  String restaurantName;
  String cartItemsTxt;

  Result({
    required this.refId,
    required this.customersId,
    required this.restaurantsId,
    required this.serviceDate,
    required this.serviceDateTime,
    required this.deliveryLat,
    required this.deliveryLng,
    required this.restaurantLat,
    required this.restaurantLng,
    required this.landmark,
    required this.doorNo,
    required this.address,
    required this.grandTotal,
    required this.serviceStatus,
    required this.distanceToCustomerFromStore,
    required this.deliveryPersonsId,
    required this.restaurantName,
    required this.cartItemsTxt,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        refId: json["ref_id"] ?? '',
        customersId: json["customers_id"] ?? '',
        restaurantsId: json["restaurants_id"] ?? '',
        serviceDate: json["service_date"] ?? '',
        serviceDateTime: json["service_date_time"] ?? '',
        deliveryLat: json["delivery_lat"] ?? '',
        deliveryLng: json["delivery_lng"] ?? '',
        restaurantLat: json["restaurant_lat"] ?? '',
        restaurantLng: json["restaurant_lng"] ?? '',
        landmark: json["landmark"] ?? '',
        doorNo: json["door_no"] ?? '',
        address: json["address"] ?? '',
        grandTotal: json["grand_total"] ?? '',
        serviceStatus: json["service_status"] ?? '',
        distanceToCustomerFromStore:
            json["distance_to_customer_from_store"] ?? '',
        deliveryPersonsId: json["delivery_persons_id"] ?? '',
        restaurantName: json["restaurant_name"] ?? '',
        cartItemsTxt: json["cart_items_txt"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ref_id": refId,
        "customers_id": customersId,
        "restaurants_id": restaurantsId,
        "service_date": serviceDate,
        "service_date_time": serviceDateTime,
        "delivery_lat": deliveryLat,
        "delivery_lng": deliveryLng,
        "restaurant_lat": restaurantLat,
        "restaurant_lng": restaurantLng,
        "landmark": landmark,
        "door_no": doorNo,
        "address": address,
        "grand_total": grandTotal,
        "service_status": serviceStatus,
        "distance_to_customer_from_store": distanceToCustomerFromStore,
        "delivery_persons_id": deliveryPersonsId,
        "restaurant_name": restaurantName,
        "cart_items_txt": cartItemsTxt,
      };
}
