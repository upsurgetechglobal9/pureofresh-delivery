import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../commons/cod_base_options.dart';
import '../../../../../commons/shared_prefs.dart';
import '../models/incentive_business_model.dart';

class IncentivesReposotory extends BaseApi {
  IncentivesReposotory();

  Future<IncentivesDataModel> incentivesApiCall({
    required String type,
  }) async {
    try {
      final incentivesData = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
        'type': type
      };
      FormData data = FormData.fromMap(incentivesData);
      final dio = dioClient();
      return await dio.post('Incentive_plans', data: data).then((response) {
        print(jsonEncode(response.data));

        if (response.data['err_code'] == "valid") {
          print(response.data['message']);
          for (var element in response.data['data']) {
            print("LAMBA $element");
          }
          return IncentivesDataModel.fromJson(response.data);
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
