import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../commons/cod_base_options.dart';
import '../models/refer_a_friend_model.dart';
import '../models/referral_data_model.dart';
import '../models/referrals_model.dart';

class RefferalRepository extends BaseApi {
  RefferalRepository();

  Future<ReferralsDataModel> referralData({
    required String accessToken,
  }) async {
    print('hello MK---$accessToken');

    try {
      final loginUserMap = <String, dynamic>{
        'access_token': "$accessToken",
      };
      FormData data = FormData.fromMap(loginUserMap);
      final dio = dioClient();
      return await dio.post('refer_friend/list', data: data).then((response) {
        print(jsonEncode(response.data));
        if (response.data['err_code'] == "valid") {
          print(response.data['message']);
          return ReferralsDataModel.fromJson(response.data);
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

  Future<ReferAFriendModel> referAFriend({
    required String accessToken,
    required String mobileNumber,
    required String name,
    required String age,
    required String vehicleType,
    required String city,
    required String workTime,
  }) async {
    print('hello MK---$accessToken');

    try {
      final loginUserMap = <String, dynamic>{
        'access_token': "$accessToken",
        'mobile': "$mobileNumber",
        'name': "$name",
        'age': "$age",
        'vehicle_type': "$vehicleType",
        'city': "$city",
        'work_time': "$workTime",
      };
      print(loginUserMap);
      FormData data = FormData.fromMap(loginUserMap);
      final dio = dioClient();
      return await dio.post('refer_friend', data: data).then((response) {
        print(jsonEncode(response.data));
        if (response.data['err_code'] == "valid") {
          print(response.data['message']);
          Fluttertoast.showToast(
              msg: "${response.data['message']}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green.shade100,
              textColor: Colors.black,
              fontSize: 16.0);
          return ReferAFriendModel.fromJson(response.data);
        }
        // else if (response.data['err_code'] == "invalid") {
        //   Fluttertoast.showToast(msg: response.data['message']);
        //   return (response.data['message']);
        // }
        else {
          throw Fluttertoast.showToast(msg: response.data['message']);
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

  Future<String> getBannerData() async {
    try {
      final dio = dioClient();
      return await dio.post('refer_friend/get_banner_text').then((response) {
        print(jsonEncode(response.data));
        if (response.data['err_code'] == "valid") {
          return response.data['banner_text'];
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
