import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../commons/cod_base_options.dart';
import '../models/ratings_view_model.dart';

class RatingsViewRepository extends BaseApi {
  RatingsViewRepository();

  Future<RatingsViewModel> getRatingDetails({
    required String accessToken,
  }) async {
    try {
      final loginUserMap = <String, dynamic>{
        'access_token': accessToken,
      };
      FormData data = FormData.fromMap(loginUserMap);
      final dio = dioClient();
      return await dio
          .post('ratings', data: data)
          .then((response) {
        print('hello MK---$accessToken');
        print(jsonEncode(response.data));
        if (response.data['err_code'] == "valid") {
          print(response.data['message']);
          return RatingsViewModel.fromJson(response.data);
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
