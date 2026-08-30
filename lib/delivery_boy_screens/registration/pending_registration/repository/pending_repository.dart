import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../commons/cod_base_options.dart';
import '../../../../../commons/shared_prefs.dart';
import '../model/pending_registaion_model.dart';

class PendingRepository extends BaseApi {
  PendingRepository();

  Future<RegistrationPendingModel> pendingScreens() async {
    try {
      final dio = dioClient();
      final mapData = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
      };

      print(mapData);
      FormData data = FormData.fromMap(mapData);
      return await dio
          .post('register/validate_details', data: data)
          .then((response) {
        print(jsonEncode(response.data));
        if (response.data['err_code'] == "valid") {
          print(response.data['data']);
          return RegistrationPendingModel.fromJson(response.data);
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
}
