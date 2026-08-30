import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pure_o_fresh_rider_app/commons/shared_prefs.dart';

import '../../../../../commons/cod_base_options.dart';
import '../model/select_work_area_model.dart';

class SelectWorkAreaRepository extends BaseApi {
  SelectWorkAreaRepository();

  Future<SelectWorkAreaModel> selectingWorkArea({
    required String cityId,
    required String keyWord,
  }) async {
    try {
      final workAreas = <String, dynamic>{
        'cities_id': cityId,
        'location_name': keyWord
      };
      FormData data = FormData.fromMap(workAreas);
      final dio = dioClient();
      return await dio.post('locations', data: data).then((response) {
        if (response.data['err_code'] == "valid") {
          return SelectWorkAreaModel.fromJson(response.data);
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

  Future<String> setupWorkLocation({
    required String cityId,
    required String locationId,
  }) async {
    try {
      final locationDetails = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
        'cities_id': cityId,
        'locations_id': locationId,
      };
      FormData data = FormData.fromMap(locationDetails);
      final dio = dioClient();
      return await dio
          .post('register/city_location_details_update', data: data)
          .then((response) {
        if (response.data['err_code'] == "valid") {
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
