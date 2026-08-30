import 'package:dio/dio.dart';

import '../../../../../commons/cod_base_options.dart';
import '../models/customer_tips_model.dart';

class CustomerTipsRepository extends BaseApi {
  CustomerTipsRepository();

  Future<CustomerTipsModel> customerTips({
    required String accessToken,
  }) async {
    try {
      final loginUserMap = <String, dynamic>{
        'access_token': accessToken,
      };
      FormData data = FormData.fromMap(loginUserMap);
      final dio = dioClient();
      return await dio.post('tips', data: data).then((response) {
        if (response.data['err_code'] == "valid") {
          return CustomerTipsModel.fromJson(response.data);
        }
        // if (response.data['err_code'] == "invalid") {
        //   return CustomerTipsModel.fromJson(response.data['data']);
        // }

        else {
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
