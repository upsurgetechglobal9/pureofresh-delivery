// To parse this JSON data, do
//
//     final languageModel = languageModelFromJson(jsonString);

// import 'dart:convert';

// LanguageModel languageModelFromJson(String str) => LanguageModel.fromJson(json.decode(str));

// String languageModelToJson(LanguageModel data) => json.encode(data.toJson());

// class LanguageModel {
//     int langId;
//     String langName;

//     LanguageModel({
//         required this.langId,
//         required this.langName,
//     });

//     factory LanguageModel.fromJson(Map<String, dynamic> json) => LanguageModel(
//         langId: json["lang_id"],
//         langName: json["lang_name"],
//     );

//     Map<String, dynamic> toJson() => {
//         "lang_id": langId,
//         "lang_name": langName,
//     };
// }

// To parse this JSON data, do
//
//     final languageModel = languageModelFromJson(jsonString);

// import 'package:meta/meta.dart';
// import 'dart:convert';

// List<LanguageModel> languageModelFromJson(String str) =>
//     List<LanguageModel>.from(
//         json.decode(str).map((x) => LanguageModel.fromJson(x)));

// String languageModelToJson(List<LanguageModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class LanguageModel {
//   String id;
//   String name;

//   LanguageModel({
//     required this.id,
//     required this.name,
//   });

//   factory LanguageModel.fromJson(Map<String, dynamic> json) => LanguageModel(
//         id: json["id"],
//         name: json["name"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//       };
// }

// To parse this JSON data, do
//
//     final languageModel = languageModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LanguageModel languageModelFromJson(String str) =>
    LanguageModel.fromJson(json.decode(str));

String languageModelToJson(LanguageModel data) => json.encode(data.toJson());

class LanguageModel {
  String errCode;
  String title;
  List<Datum> data;

  LanguageModel({
    required this.errCode,
    required this.title,
    required this.data,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) => LanguageModel(
        errCode: json["err_code"],
        title: json["title"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "err_code": errCode,
        "title": title,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String id;
  String name;

  Datum({
    required this.id,
    required this.name,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
