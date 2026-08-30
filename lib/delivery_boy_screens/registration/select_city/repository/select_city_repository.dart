import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../commons/cod_base_options.dart';
import '../../../../../commons/shared_prefs.dart';
import '../select_city_model/select_city_model.dart';

class SelectCityRepository extends BaseApi {
  SelectCityRepository();

  Future<SelectCityModel> gettingCities({required String searchWord}) async {
    try {
      final dio = dioClient();
      final searchKy = <String, dynamic>{
        'city_name': searchWord,
      };
      FormData data = FormData.fromMap(searchKy);
      return await dio.post('cities', data: data).then((response) {
        if (response.data['err_code'] == "valid") {
          return SelectCityModel.fromJson(response.data);
        } else {
          throw (response.data['err_code']);
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

  // Future<String> continueWithLanguage({required String language}) async {
  //   try {
  //     final dio = dioClient();
  //     return await dio.post('Language_settings').then((response) {
  //       if (response.data['err_code'] == "valid") {
  //         return response.data['err_code'];
  //       } else {
  //         throw (response.data['title']);
  //       }
  //     });
  //   } catch (e) {
  //     if (e is DioException) {
  //       if (e.response?.statusCode == 500) {
  //         throw ("Server error");
  //       } else {
  //         throw ("Unable to login");
  //       }
  //     } else {
  //       rethrow;
  //     }
  //   }
  // }
}
