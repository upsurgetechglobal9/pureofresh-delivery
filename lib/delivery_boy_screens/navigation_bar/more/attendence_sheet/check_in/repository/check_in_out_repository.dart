import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dios;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pure_o_fresh_rider_app/commons/shared_prefs.dart';

import '../../../../../../commons/cod_base_options.dart';
import '../../../../../../commons/url_links.dart';
import '../../../../../../main.dart';
import '../../../../../../tools/background_service.dart';

class CheckInOutRepository extends BaseApi {
  CheckInOutRepository();
  final backgroundService = BackgroundService();

  Future<String> checkInApi({
    required String checkinWearHelmet,
    required String checkinWearTshirt,
    required String checkinWearMask,
    required File checkInImage,
  }) async {
    try {
      var checkInImageFinal =
          await dios.MultipartFile.fromFile(checkInImage.path);
      final checkInDetails = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
        'checkin_wear_helmet': "$checkinWearHelmet",
        'checkin_wear_tshirt': "$checkinWearTshirt",
        'checkin_wear_mask': "$checkinWearMask",
        'image': await dios.MultipartFile.fromFile(checkInImage.path)
      };

      FormData data = FormData.fromMap(checkInDetails);
      final dio = dioClient();
      return await dio
          .post('delivery_person_attendance/checkin', data: data)
          .then((response) {
        if (response.data['err_code'] == "valid") {
          Fluttertoast.showToast(msg: "${response.data['message']}");

          return response.data['message'];
        }
        if (response.data['err_code'] == "invalid") {
          Fluttertoast.showToast(msg: "${response.data['message']}");
          return response.data['message'];
        }

        throw (response.data['message']);
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

  Future<String> checkOutApi({
    required String checkoutWearHelmet,
    required String checkoutWearTshirt,
    required String checkoutWearMask,
    required File checkoutImage,
  }) async {
    try {
      var checkOutImageFinal =
          await dios.MultipartFile.fromFile(checkoutImage.path);
      final checkOutDetails = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
        'checkout_wear_helmet': "$checkoutWearHelmet",
        'checkout_wear_tshirt': "$checkoutWearTshirt",
        'checkout_wear_mask': "$checkoutWearMask",
        'image': checkOutImageFinal
      };

      final batteryPercentage = await battery.batteryLevel;
      debugPrint('current battery percentage: $batteryPercentage');

      final formData = FormData.fromMap({
        'access_token': Constants.prefs!.getString("token"),
        'is_online': Constants.prefs!.getBool("status"),
        'battery_percent': batteryPercentage
      });
      FormData data = FormData.fromMap(checkOutDetails);
      final dio = dioClient();
      return await dio
          .post('delivery_person_attendance/checkout', data: data)
          .then((response) {
        if (response.data['err_code'] == "valid") {
          dio
              .post("${UrlLinksData.serverUrl}Online_or_offline_status/update",
                  data: formData)
              .then((value) {
            backgroundService.stopService();
          });
          Fluttertoast.showToast(msg: "${response.data['message']}");
          return response.data['message'];
        } else if (response.data['err_code'] == "invalid") {
          Fluttertoast.showToast(msg: "${response.data['message']}");

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
}
