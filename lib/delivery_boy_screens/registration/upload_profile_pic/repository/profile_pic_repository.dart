import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pure_o_fresh_rider_app/commons/shared_prefs.dart';

import '../../../../../commons/cod_base_options.dart';

class UploadImageRepository extends BaseApi {
  UploadImageRepository();

  Future<String> uploadImageApi({
    required String image,
  }) async {
    try {
      final checkOutDetails = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
        'profile_photo': image
      };

      FormData data = FormData.fromMap(checkOutDetails);
      final dio = dioClient();
      return await dio
          .post('register/profile_image_update', data: data)
          .then((response) {
        if (response.data['err_code'] == "valid") {
          // Fluttertoast.showToast(msg: "${response.data['message']}");

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
