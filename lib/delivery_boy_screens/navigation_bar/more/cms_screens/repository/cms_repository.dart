import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../commons/cod_base_options.dart';
import '../../../../../commons/shared_prefs.dart';
import '../models/cms_model.dart';

class CmsRepository extends BaseApi {
  CmsRepository();

  Future<CmsModel> cmsApiCall({required String apiname}) async {
    try {
      final loginUserMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
      };
      FormData data = FormData.fromMap(loginUserMap);
      final dio = dioClient();
      return await dio.post(apiname, data: data).then((response) {
      
        if (response.data['err_code'] == "valid") {
          return CmsModel.fromJson(response.data);
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
