import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../commons/cod_base_options.dart';
import '../../../../../commons/shared_prefs.dart';
import '../model/my_order_history_model.dart';

class MyOrderHistorRepository extends BaseApi {
  MyOrderHistorRepository();

  Future<MyOrdersHistoryModel> myOrderHistoryApiCall({
    required String date,
    required String searchType,

  }) async {
    try {
      final myOrderDetailsMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
        'date': date,
        'type': searchType,
      };
      
      FormData data = FormData.fromMap(myOrderDetailsMap);
      final dio = dioClient();
      return await dio
          .post('My_orders/order_history', data: data)
          .then((response) {
        if (response.data['err_code'] == "valid") {
          return MyOrdersHistoryModel.fromJson(response.data);
        }
        if (response.data['err_code'] == "invalid") {
          return MyOrdersHistoryModel.fromJson(response.data);
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
