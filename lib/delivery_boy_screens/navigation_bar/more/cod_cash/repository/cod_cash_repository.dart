import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../commons/cod_base_options.dart';
import '../../../../../commons/shared_prefs.dart';
import '../models/cod_cash_model.dart';

class CODRepository extends BaseApi {
  CODRepository();

  Future<CodCashModel> codCash({
    required String userName,
  }) async {
    print('hello---');

    try {
      final loginUserMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
      };
      FormData data = FormData.fromMap(loginUserMap);
      final dio = dioClient();
      return await dio.post('Cod_cash_wallet', data: data).then((response) {
        if (response.data['err_code'] == "valid") {
          // print(response.data['message']);
          return CodCashModel.fromJson(response.data);
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

  // Future<String> verifyOTP({
  //   required String mobile,
  //   required String otp,
  // }) async {
  //   try {
  //     final verifyOTPMap = <String, dynamic>{'mobile': mobile, 'otp': otp};
  //     FormData data = FormData.fromMap(verifyOTPMap);
  //     final dio = dioClient();
  //     return await dio
  //         .post('vendor/login/verify_otp', data: data)
  //         .then((response) {
  //       print(jsonEncode(response.data));
  //       if (response.data['err_code'] == "valid") {
  //         return (response.data['data']['access_token']).toString();
  //       } else {
  //         throw (response.data['message']);
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
