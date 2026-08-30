import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../commons/cod_base_options.dart';
import '../../../../commons/shared_prefs.dart';
import '../models/my_orders_model.dart';

class MyOrdersRepository extends BaseApi {
  MyOrdersRepository();

  

  Future<MyOrdersDetailsModel> myOrderDetailsApiCall({
    required String type,
    required String searchType,

  }) async {
    try {
      final myOrderDetailsMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
        'type': type,
        'search_type': searchType,
      };

      FormData data = FormData.fromMap(myOrderDetailsMap);
      final dio = dioClient();
      return await dio.post('My_orders', data: data).then((response) {
        if (response.data['err_code'] == "valid") {

          return MyOrdersDetailsModel.fromJson(response.data);
        }
        if (response.data['err_code'] == "invalid") {
          Fluttertoast.showToast(msg: response.data['message']);
          throw (response.data['message']);
        } else {
          throw 'Server Error';
        }
      });
    } catch (e) {
      if (e is DioException) {
        if (e.response!.statusCode == 500) {
          throw ("No Order Found");
        } else {
          throw ("Unable to login");
        }
      } else {
        rethrow;
      }
    }
  }




   Future<MyOrdersDetailsModel> myCustomOrderDetailsApiCall({
    required String type,
    required String fromdate,
    required String todate,
    required String searchType,

  }) async {
    try {
      final myOrderDetailsMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
        'type': type,
        'fromdate': fromdate,
        'todate': todate,
        'search_type': searchType,
      };
   

      FormData data = FormData.fromMap(myOrderDetailsMap);
      final dio = dioClient();
      return await dio.post('My_orders', data: data).then((response) {
        if (response.data['err_code'] == "valid") {
          return MyOrdersDetailsModel.fromJson(response.data);
        }
        if (response.data['err_code'] == "invalid") {
          throw (response.data['message']);
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
