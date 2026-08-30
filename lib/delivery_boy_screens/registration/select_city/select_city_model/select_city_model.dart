// To parse this JSON data, do
//
//     final selectCityModel = selectCityModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SelectCityModel selectCityModelFromJson(String str) => SelectCityModel.fromJson(json.decode(str));

String selectCityModelToJson(SelectCityModel data) => json.encode(data.toJson());

class SelectCityModel {
    String errCode;
    Data data;

    SelectCityModel({
        required this.errCode,
        required this.data,
    });

    factory SelectCityModel.fromJson(Map<String, dynamic> json) => SelectCityModel(
        errCode: json["err_code"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "err_code": errCode,
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
        totalResultsFound: json["total_results_found"],
        totalPages: json["total_pages"],
        results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "total_results_found": totalResultsFound,
        "total_pages": totalPages,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
    };
}

class Result {
    String id;
    String name;

    Result({
        required this.id,
        required this.name,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
