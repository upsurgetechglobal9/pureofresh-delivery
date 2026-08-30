// To parse this JSON data, do
//
//     final cmsModel = cmsModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CmsModel cmsModelFromJson(String str) => CmsModel.fromJson(json.decode(str));

String cmsModelToJson(CmsModel data) => json.encode(data.toJson());

class CmsModel {
  String errCode;
  String title;
  String data;

  CmsModel({
    required this.errCode,
    required this.title,
    required this.data,
  });

  factory CmsModel.fromJson(Map<String, dynamic> json) => CmsModel(
        errCode: json["err_code"],
        title: json["title"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "err_code": errCode,
        "title": title,
        "data": data,
      };
}
