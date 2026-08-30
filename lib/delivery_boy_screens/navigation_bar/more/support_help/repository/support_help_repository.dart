import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pure_o_fresh_rider_app/commons/shared_prefs.dart';

import '../../../../../commons/cod_base_options.dart';
import '../models/my_profile_details_model.dart';

class SupportHelpRepository extends BaseApi {
  SupportHelpRepository();

  Future<MyProfileDetailsModel> myProfileDetails() async {
    try {
      final profileMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString('token')
      };
      FormData data = FormData.fromMap(profileMap);
      final dio = dioClient();
      return await dio.post('profile', data: data).then((response) {
        if (response.data['err_code'] == "valid") {
          return MyProfileDetailsModel.fromJson(response.data);
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

  Future<String> addingProfileDetails(
      {required String image,
      required String name,
      required String languages}) async {
    try {
      final profileMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString('token'),
        'profile_photo': image,
        'person_name': name,
        'languages_known': languages,
      };
      FormData data = FormData.fromMap(profileMap);
      final dio = dioClient();
      return await dio.post('profile/update', data: data).then((response) {
        if (response.data['err_code'] == "valid") {
          return response.data['err_code'];
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

  Future<String> orderEarningIssueApiCall(
      {required String description,
      required String orderId,
      required String image}) async {
    try {
      final profileMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString('token'),
        'order_id': orderId,
        'description': description,
        'image': image,
      };
      FormData data = FormData.fromMap(profileMap);
      final dio = dioClient();
      return await dio
          .post('issues/raise_order_earning', data: data)
          .then((response) {
        if (response.data['err_code'] == "valid") {
          return response.data['err_code'];
        } else if (response.data['err_code'] == "invalid_form") {
          return response.data['err_code'];
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

  Future<String> incentivesIssueApiCall(
      {required String description,
      required String transId,
      required String image}) async {
    try {
      final profileMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString('token'),
        'transaction_id': transId,
        'description': description,
        'image': image,
      };
      FormData data = FormData.fromMap(profileMap);
      final dio = dioClient();
      return await dio
          .post('issues/raise_incentive_earning', data: data)
          .then((response) {
        if (response.data['err_code'] == "valid") {
          return response.data['err_code'];
        } else if (response.data['err_code'] == "invalid_form") {
          return response.data['err_code'];
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

  Future<String> codCashIssueApiCall(
      {required String description,
      required String transId,
      required String image}) async {
    try {
      final profileMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString('token'),
        'transaction_id': transId,
        'description': description,
        'image': image,
      };
      FormData data = FormData.fromMap(profileMap);
      final dio = dioClient();
      return await dio
          .post('issues/raise_cod_issue', data: data)
          .then((response) {
        if (response.data['err_code'] == "valid") {
          return response.data['err_code'];
        } else if (response.data['err_code'] == "invalid_form") {
          return response.data['err_code'];
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

  Future<String> anyOtherIssueApiCall({
    required String description,
    required String image,
  }) async {
    try {
      final profileMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString('token'),
        'description': description,
        'image': image,
      };
      FormData data = FormData.fromMap(profileMap);
      final dio = dioClient();
      return await dio
          .post('issues/raise_other_issue', data: data)
          .then((response) {
        if (response.data['err_code'] == "valid") {
          return response.data['err_code'];
        } else if (response.data['err_code'] == "invalid_form") {
          return response.data['err_code'];
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
