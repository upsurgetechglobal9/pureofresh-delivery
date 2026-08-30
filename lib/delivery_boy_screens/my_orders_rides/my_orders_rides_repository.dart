import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pure_o_fresh_rider_app/commons/cod_base_options.dart';
import 'package:pure_o_fresh_rider_app/commons/shared_prefs.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/my_orders_rides/my_orders_model.dart';

class MyOrdersRidesRepository extends BaseApi {
  Future<MyOrdersRideModel> fecthRideList({
    required String type,
  }) async {
    try {
      final loginUserMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
        'type': type
      };
      FormData data = FormData.fromMap(loginUserMap);
      final dio = dioClient();
      return await dio.post('rides/ongoing_rides', data: data).then((response) {
        if (response.data['err_code'] == "valid") {
          // print(response.data['message']);
          return MyOrdersRideModel.fromJson(response.data);
        } else {
          return MyOrdersRideModel(data: [], errCode: "invalid");
          // throw (response.data['message']);
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
