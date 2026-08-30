// To parse this JSON data, do
//
//     final myProfileDetailsModel = myProfileDetailsModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

MyProfileDetailsModel myProfileDetailsModelFromJson(String str) =>
    MyProfileDetailsModel.fromJson(json.decode(str));

String myProfileDetailsModelToJson(MyProfileDetailsModel data) =>
    json.encode(data.toJson());

class MyProfileDetailsModel {
  String errCode;
  String title;
  String message;
  DeliveryPersonDetails deliveryPersonDetails;

  MyProfileDetailsModel({
    required this.errCode,
    required this.title,
    required this.message,
    required this.deliveryPersonDetails,
  });

  factory MyProfileDetailsModel.fromJson(Map<String, dynamic> json) =>
      MyProfileDetailsModel(
        errCode: json["err_code"],
        title: json["title"],
        message: json["message"],
        deliveryPersonDetails:
            DeliveryPersonDetails.fromJson(json["delivery_person_details"]),
      );

  Map<String, dynamic> toJson() => {
        "err_code": errCode,
        "title": title,
        "message": message,
        "delivery_person_details": deliveryPersonDetails.toJson(),
      };
}

class DeliveryPersonDetails {
  String personName;
  String walletAmount;
  String latitude;
  String longitude;
  String email;
  String gender;
  String age;
  String mobileNumber;
  String profilePhoto;
  String accessToken;
  String isOnline;
  String vehicleNumber;
  String vehicleName;
  String vehicleValidity;
  String vehicleType;
  String vehiclePhoto;
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
  String referBonus;
  String languagesKnown;
  String cityName;
  String locationName;
  String lastLogin;

  DeliveryPersonDetails({
    required this.personName,
    required this.walletAmount,
    required this.latitude,
    required this.longitude,
    required this.email,
    required this.gender,
    required this.age,
    required this.mobileNumber,
    required this.profilePhoto,
    required this.accessToken,
    required this.isOnline,
    required this.vehicleNumber,
    required this.vehicleName,
    required this.vehicleValidity,
    required this.vehicleType,
    required this.vehiclePhoto,
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
    required this.languagesKnown,
    required this.cityName,
    required this.locationName,
    required this.lastLogin,
  });

  factory DeliveryPersonDetails.fromJson(Map<String, dynamic> json) =>
      DeliveryPersonDetails(
        personName: json["person_name"] ?? '',
        walletAmount: json["wallet_amount"] ?? '',
        latitude: json["latitude"] ?? '',
        longitude: json["longitude"] ?? '',
        email: json["email"] ?? '',
        gender: json["gender"] ?? '',
        age: json["age"] ?? '',
        mobileNumber: json["mobile_number"] ?? '',
        profilePhoto: json["profile_photo"] ?? '',
        accessToken: json["access_token"] ?? '',
        isOnline: json["is_online"] ?? '',
        vehicleNumber: json["vehicle_number"] ?? '',
        vehicleName: json["vehicle_name"] ?? '',
        vehicleValidity: json["vehicle_validity"] ?? '',
        vehicleType: json["vehicle_type"] ?? '',
        vehiclePhoto: json["vehicle_photo"] ?? '',
        drivingLicense: json["driving_license"] ?? '',
        drivingLicenseNumber: json["driving_license_number"] ?? '',
        aadharCard: json["aadhar_card"] ?? '',
        aadharCardNumber: json["aadhar_card_number"] ?? '',
        aadharCardName: json["aadhar_card_name"] ?? '',
        panCardName: json["pan_card_name"] ?? '',
        panCardNumber: json["pan_card_number"] ?? '',
        panCardGender: json["pan_card_gender"] ?? '',
        panCardFathername: json["pan_card_fathername"] ?? '',
        panCard: json["pan_card"] ?? '',
        pushNotificationToken: json["push_notification_token"] ?? '',
        mobileVerified: json["mobile_verified"] ?? '',
        countriesId: json["countries_id"] ?? '',
        citiesId: json["cities_id"] ?? '',
        locationsId: json["locations_id"] ?? '',
        registerThrough: json["register_through"] ?? '',
        otp: json["otp"] ?? '',
        codCashLimit: json["cod_cash_limit"] ?? '',
        codCashWallet: json["cod_cash_wallet"] ?? '',
        referBonus: json["refer_bonus"] ?? '',
        languagesKnown: json["languages_known"] ?? '',
        cityName: json["city_name"] ?? '',
        locationName: json["location_name"] ?? '',
        lastLogin: json["last_login"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "person_name": personName,
        "wallet_amount": walletAmount,
        "latitude": latitude,
        "longitude": longitude,
        "email": email,
        "gender": gender,
        "age": age,
        "mobile_number": mobileNumber,
        "profile_photo": profilePhoto,
        "access_token": accessToken,
        "is_online": isOnline,
        "vehicle_number": vehicleNumber,
        "vehicle_name": vehicleName,
        "vehicle_validity": vehicleValidity,
        "vehicle_type": vehicleType,
        "vehicle_photo": vehiclePhoto,
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
        "languages_known": languagesKnown,
        "city_name": cityName,
        "location_name": locationName,
        "last_login": lastLogin,
      };
}
