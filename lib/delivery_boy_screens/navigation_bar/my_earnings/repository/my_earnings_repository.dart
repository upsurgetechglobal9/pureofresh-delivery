import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../commons/cod_base_options.dart';
import '../../../../commons/shared_prefs.dart';
import '../models/my_earnings_model.dart';

class MyEarningsRepository extends BaseApi {
  MyEarningsRepository();

  Future<MyEarningsModel> myearningsApiCall({
    required String fromDate,
    required String toDate,
  }) async {
    try {
      final mapData = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
        "from_date": fromDate,
        "to_date": toDate
      };
      FormData data = FormData.fromMap(mapData);
      final dio = dioClient();
      return await dio.post('Incentives_info', data: data).then((response) {
        if (response.data['err_code'] == "valid") {
          return MyEarningsModel.fromJson(response.data);
        }
        if (response.data['err_code'] == "invalid") {
          return MyEarningsModel.fromJson(response.data);
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      if (e is DioException) {
        if (e.response!.statusCode == 500) {
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
