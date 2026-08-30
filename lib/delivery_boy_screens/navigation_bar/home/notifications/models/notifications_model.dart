// To parse this JSON data, do
//
//     final notificationsModel = notificationsModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

NotificationsModel notificationsModelFromJson(String str) =>
    NotificationsModel.fromJson(json.decode(str));

String notificationsModelToJson(NotificationsModel data) =>
    json.encode(data.toJson());

class NotificationsModel {
  String errCode;
  String title;
  String message;
  Data data;
  Pagination pagination;

  NotificationsModel({
    required this.errCode,
    required this.title,
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> json) =>
      NotificationsModel(
        errCode: json["err_code"],
        title: json["title"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
        pagination: Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "err_code": errCode,
        "title": title,
        "message": message,
        "data": data.toJson(),
        "pagination": pagination.toJson(),
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
        totalResultsFound: json["total_results_found"],
        totalPages: json["total_pages"],
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
  String id;
  String fromTablePrimaryId;
  String comment;
  String fromTableName;
  String toTablePrimaryKey;
  String toTableName;
  String createdAt;
  String updatedAt;
  String status;
  String seenStatus;
  dynamic type;
  String displayTime;

  Result({
    required this.id,
    required this.fromTablePrimaryId,
    required this.comment,
    required this.fromTableName,
    required this.toTablePrimaryKey,
    required this.toTableName,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.seenStatus,
    required this.type,
    required this.displayTime,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        fromTablePrimaryId: json["from_table_primary_id"],
        comment: json["comment"],
        fromTableName: json["from_table_name"],
        toTablePrimaryKey: json["to_table_primary_key"],
        toTableName: json["to_table_name"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        status: json["status"],
        seenStatus: json["seen_status"],
        type: json["type"],
        displayTime: json["display_time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "from_table_primary_id": fromTablePrimaryId,
        "comment": comment,
        "from_table_name": fromTableName,
        "to_table_primary_key": toTablePrimaryKey,
        "to_table_name": toTableName,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "status": status,
        "seen_status": seenStatus,
        "type": type,
        "display_time": displayTime,
      };
}

class Pagination {
  String page;
  String pagination;
  PaginationHelper paginationHelper;

  Pagination({
    required this.page,
    required this.pagination,
    required this.paginationHelper,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        page: json["page"],
        pagination: json["pagination"],
        paginationHelper: PaginationHelper.fromJson(json["pagination_helper"]),
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "pagination": pagination,
        "pagination_helper": paginationHelper.toJson(),
      };
}

class PaginationHelper {
  int perPage;
  int curPage;

  PaginationHelper({
    required this.perPage,
    required this.curPage,
  });

  factory PaginationHelper.fromJson(Map<String, dynamic> json) =>
      PaginationHelper(
        perPage: json["per_page"],
        curPage: json["cur_page"],
      );

  Map<String, dynamic> toJson() => {
        "per_page": perPage,
        "cur_page": curPage,
      };
}
