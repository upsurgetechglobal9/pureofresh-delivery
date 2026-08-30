import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pure_o_fresh_rider_app/commons/shared_prefs.dart';

import '../../../../../commons/cod_base_options.dart';

class SelectVehicleRepository extends BaseApi {
  SelectVehicleRepository();

  Future<String> vehicleRegisteration({
    required String vehicleType,
    required String vehicleNumber,
    required String vehicleValidity,
    required String drivingLicenseNumber,
    required String drivingLicensePhoto,
    required String vehiclePhoto,
    required String vehiclePhoto2,
    required String rc1,
    required String rc2,
    required String vehicleName,
    required String drivingLicensePhotoTwo,
  }) async {
    try {
      final vehicleDetails = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
        //'vehicle_type': vehicleType,
        'vehicle_number': vehicleNumber,
        'vehicle_validity': vehicleValidity,
        'driving_license_number': drivingLicenseNumber,
        'driving_license': drivingLicensePhoto,
        'vehicle_photo': vehiclePhoto,
        'vehicle_photo_back': vehiclePhoto2,
        'rc_photo_front': rc1,
        'rc_photo_back': rc2,
        'vehicle_name': vehicleName,
        'driving_license2': drivingLicensePhotoTwo
      };
      print(vehicleDetails);
      FormData data = FormData.fromMap(vehicleDetails);
      final dio = dioClient();
      return await dio
          .post('register/vehicle_details_update', data: data)
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
        }
        if (response.data['err_code'] == "invalid") {
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
