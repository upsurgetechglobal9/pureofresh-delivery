import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pure_o_fresh_rider_app/commons/shared_prefs.dart';

import '../../../../../commons/cod_base_options.dart';

class VerificationDocumentsRepository extends BaseApi {
  VerificationDocumentsRepository();

  Future<String> documentDetailsUploading(
      {required String panNumber,
      required String panName,
      required String panGender,
      required String panFather,
      required String adharPic,
      required String panPic,
      required String adharName,
      required String adharNumber,
      required String adharBack}) async {
    try {
      // var adharFinalPic = await dios.MultipartFile.fromFile(adharPic.path);
      // var panFinalPic = await dios.MultipartFile.fromFile(panPic.path);
      final vehicleDetails = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
        'pan_card_number': panNumber,
        'pan_card_name': panName,
        'pan_card_gender': panGender,
        'pan_card_fathername': panFather,
        'aadhar_card': adharPic,
        'pan_card': panPic,
        'aadhar_card_name': adharName,
        'aadhar_card_number': adharNumber,
        'aadhar_card_back': adharBack,
      };
      FormData data = FormData.fromMap(vehicleDetails);
      final dio = dioClient();
      return await dio
          .post('register/pan_adhar_update', data: data)
          .then((response) {
        if (response.data['err_code'] == "valid") {
          Fluttertoast.showToast(
              msg: "${response.data['message']}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green.shade100,
              textColor: Colors.black,
              fontSize: 16.0);
          return response.data['err_code'];
        } else {
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
