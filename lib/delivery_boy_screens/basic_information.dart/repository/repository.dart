import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pure_o_fresh_rider_app/commons/shared_prefs.dart';

import '../../../../../commons/cod_base_options.dart';

class BasicInformationRepository extends BaseApi {
  BasicInformationRepository();

  Future<String> basicRegisteration({
    required String name,
    required String email,
    required String mobileNumber,
    required String gender,
    required String age,
    required String laguages,
    required String latitude,
    required String longitude,
  }) async {
    try {
      final loginUserMap = <String, dynamic>{
        'person_name': name,
        'email': email,
        'mobile_number': mobileNumber,
        'gender': gender,
        'age': age,
        'languages_known': laguages,
        'latitude': latitude,
        'longitude': longitude,
      };
      FormData data = FormData.fromMap(loginUserMap);
      final dio = dioClient();
      return await dio.post('register', data: data).then((response) {
        if (response.data['err_code'] == "valid") {
          return response.data['message'];
        }
        if (response.data['err_code'] == "invalid") {
          Fluttertoast.showToast(
            msg: "${response.data['message']}",
          );
          return response.data['message'];
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw ("Server error");
        } else {
          throw ("Unable to login");
        }
      } else {
        rethrow;
      }
    }
  }

  Future<bool> basicRegisterationNew({
    required String selectedTypeId,
    required String vechileTypeId,
    required String name,
    required String email,
    required String mobileNumber,
    required String gender,
    required String age,
    required String laguages,
    required String latitude,
    required String longitude,
  }) async {
    try {
      final loginUserMap = <String, dynamic>{
        'delivery_type': selectedTypeId,
        'vechile_type_id': vechileTypeId,
        'person_name': name,
        'email': email,
        'mobile_number': mobileNumber,
        'gender': gender,
        'age': age,
        'languages_known': laguages,
        'latitude': latitude ?? '',
        'longitude': longitude ?? '',
      };
      FormData data = FormData.fromMap(loginUserMap);
      final dio = dioClient();
      return await dio.post('register', data: data).then((response) {
        if (response.data['err_code'] == "valid") {
          return response.data['err_code'] == "valid";
        }
        if (response.data['err_code'] == "invalid") {
          Fluttertoast.showToast(
            msg: "${response.data['message']}",
          );
          return response.data['message'];
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw ("Server error");
        } else {
          throw ("Unable to login");
        }
      } else {
        rethrow;
      }
    }
  }

  Future<String> verifyOTP(
      {required String mobileNumber,
      required String otp,
      required String type}) async {
    try {
      final otpDetails = <String, dynamic>{
        'mobile': mobileNumber,
        'otp': otp,
        'type': type
      };
      FormData data = FormData.fromMap(otpDetails);
      final dio = dioClient();
      return await dio.post('login/verify_otp', data: data).then((response) {
        if (response.data['err_code'] == "valid") {
          Constants.prefs!.setString(
              'token', response.data['user_details']['access_token']);
          Fluttertoast.showToast(
              msg: "${response.data['message']}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green.shade100,
              textColor: Colors.black,
              fontSize: 16.0);
          return response.data['err_code'];
        }
        if (response.data['err_code'] == "invalid") {
          Fluttertoast.showToast(
            msg: "${response.data['message']}",
          );
          return response.data['err_code'];
        } else {
          Fluttertoast.showToast(msg: response.data['message']);
          throw (response.data['message']);
        }
      });
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw ("Server error");
        } else {
          throw ("Unable to login");
        }
      } else {
        rethrow;
      }
    }
  }
}
