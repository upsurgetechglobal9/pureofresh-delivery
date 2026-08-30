// To parse this JSON data, do
//
//     final languagetitlesModel = languagetitlesModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LanguagetitlesModel languagetitlesModelFromJson(String str) => LanguagetitlesModel.fromJson(json.decode(str));

String languagetitlesModelToJson(LanguagetitlesModel data) => json.encode(data.toJson());

class LanguagetitlesModel {
    String welcome;
    String myOrders;

    LanguagetitlesModel({
        required this.welcome,
        required this.myOrders,
    });

    factory LanguagetitlesModel.fromJson(Map<String, dynamic> json) => LanguagetitlesModel(
        welcome: json["Welcome"],
        myOrders: json["My Orders"],
    );

    Map<String, dynamic> toJson() => {
        "Welcome": welcome,
        "My Orders": myOrders,
    };
}
