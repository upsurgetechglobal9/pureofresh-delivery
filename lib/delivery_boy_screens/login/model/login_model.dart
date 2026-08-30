// To parse this JSON data, do
//
//     final loginRespondModel = loginRespondModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LoginRespondModel loginRespondModelFromJson(String str) =>
    LoginRespondModel.fromJson(json.decode(str));

String loginRespondModelToJson(LoginRespondModel data) =>
    json.encode(data.toJson());

class LoginRespondModel {
  String errCode;
  String errorType;
  String message;
  Data data;

  LoginRespondModel({
    required this.errCode,
    required this.errorType,
    required this.message,
    required this.data,
  });

  factory LoginRespondModel.fromJson(Map<String, dynamic> json) =>
      LoginRespondModel(
        errCode: json["err_code"],
        errorType: json["error_type"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "err_code": errCode,
        "error_type": errorType,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  String personName;
  String walletAmount;
  String latitude;
  String longitude;
  String email;
  String mobileNumber;
  String profilePhoto;
  String accessToken;
  String isOnline;
  String vehicleNumber;
  String vehicleName;
  DateTime vehicleValidity;
  String vehicleType;
  String drivingLicense;
  String drivingLicenseNumber;
  String aadharCard;
  String aadharCardNumber;
  String aadharCardName;
  String panCardName;
  String panCardNumber;
  String panCardGender;
  String panCardFathername;
  String panCard;
  String pushNotificationToken;
  String mobileVerified;
  String countriesId;
  String citiesId;
  String locationsId;
  String registerThrough;
  String otp;
  String codCashLimit;
  String codCashWallet;
  dynamic referBonus;

  Data({
    required this.personName,
    required this.walletAmount,
    required this.latitude,
    required this.longitude,
    required this.email,
    required this.mobileNumber,
    required this.profilePhoto,
    required this.accessToken,
    required this.isOnline,
    required this.vehicleNumber,
    required this.vehicleName,
    required this.vehicleValidity,
    required this.vehicleType,
    required this.drivingLicense,
    required this.drivingLicenseNumber,
    required this.aadharCard,
    required this.aadharCardNumber,
    required this.aadharCardName,
    required this.panCardName,
    required this.panCardNumber,
    required this.panCardGender,
    required this.panCardFathername,
    required this.panCard,
    required this.pushNotificationToken,
    required this.mobileVerified,
    required this.countriesId,
    required this.citiesId,
    required this.locationsId,
    required this.registerThrough,
    required this.otp,
    required this.codCashLimit,
    required this.codCashWallet,
    required this.referBonus,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        personName: json["person_name"],
        walletAmount: json["wallet_amount"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        email: json["email"],
        mobileNumber: json["mobile_number"],
        profilePhoto: json["profile_photo"],
        accessToken: json["access_token"],
        isOnline: json["is_online"],
        vehicleNumber: json["vehicle_number"],
        vehicleName: json["vehicle_name"],
        vehicleValidity: DateTime.parse(json["vehicle_validity"]),
        vehicleType: json["vehicle_type"],
        drivingLicense: json["driving_license"],
        drivingLicenseNumber: json["driving_license_number"],
        aadharCard: json["aadhar_card"],
        aadharCardNumber: json["aadhar_card_number"],
        aadharCardName: json["aadhar_card_name"],
        panCardName: json["pan_card_name"],
        panCardNumber: json["pan_card_number"],
        panCardGender: json["pan_card_gender"],
        panCardFathername: json["pan_card_fathername"],
        panCard: json["pan_card"],
        pushNotificationToken: json["push_notification_token"],
        mobileVerified: json["mobile_verified"],
        countriesId: json["countries_id"],
        citiesId: json["cities_id"],
        locationsId: json["locations_id"],
        registerThrough: json["register_through"],
        otp: json["otp"],
        codCashLimit: json["cod_cash_limit"],
        codCashWallet: json["cod_cash_wallet"],
        referBonus: json["refer_bonus"],
      );

  Map<String, dynamic> toJson() => {
        "person_name": personName,
        "wallet_amount": walletAmount,
        "latitude": latitude,
        "longitude": longitude,
        "email": email,
        "mobile_number": mobileNumber,
        "profile_photo": profilePhoto,
        "access_token": accessToken,
        "is_online": isOnline,
        "vehicle_number": vehicleNumber,
        "vehicle_name": vehicleName,
        "vehicle_validity":
            "${vehicleValidity.year.toString().padLeft(4, '0')}-${vehicleValidity.month.toString().padLeft(2, '0')}-${vehicleValidity.day.toString().padLeft(2, '0')}",
        "vehicle_type": vehicleType,
        "driving_license": drivingLicense,
        "driving_license_number": drivingLicenseNumber,
        "aadhar_card": aadharCard,
        "aadhar_card_number": aadharCardNumber,
        "aadhar_card_name": aadharCardName,
        "pan_card_name": panCardName,
        "pan_card_number": panCardNumber,
        "pan_card_gender": panCardGender,
        "pan_card_fathername": panCardFathername,
        "pan_card": panCard,
        "push_notification_token": pushNotificationToken,
        "mobile_verified": mobileVerified,
        "countries_id": countriesId,
        "cities_id": citiesId,
        "locations_id": locationsId,
        "register_through": registerThrough,
        "otp": otp,
        "cod_cash_limit": codCashLimit,
        "cod_cash_wallet": codCashWallet,
        "refer_bonus": referBonus,
      };
}
