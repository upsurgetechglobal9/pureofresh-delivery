import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../commons/cod_base_options.dart';
import '../models/attendence_sheet_model.dart';

class AttendanceSheetReposotory extends BaseApi {
  AttendanceSheetReposotory();

  Future<AttendanceDetailsModel> attendanceDetails({
    required String accessToken,
  }) async {
    try {
      final loginUserMap = <String, dynamic>{
        'access_token': accessToken,
      };
      FormData data = FormData.fromMap(loginUserMap);
      final dio = dioClient();
      return await dio
          .post('delivery_person_attendance', data: data)
          .then((response) {
        if (response.data['err_code'] == "valid") {
          return AttendanceDetailsModel.fromJson(response.data);
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

  Future<String> checkInValidationDetails({
    required String accessToken,
  }) async {
    try {
      final loginUserMap = <String, dynamic>{
        'access_token': accessToken,
      };
      FormData data = FormData.fromMap(loginUserMap);
      final dio = dioClient();
      return await dio
          .post('delivery_person_attendance/checkin_validation', data: data)
          .then((response) {
        if (response.data['err_code'] == "valid") {
          return response.data['err_code'];
        } else if (response.data['err_code'] == "invalid") {
          return response.data['err_code'];
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

  Future<String> checkOutValidationDetails({
    required String accessToken,
  }) async {
    try {
      final loginUserMap = <String, dynamic>{
        'access_token': accessToken,
      };
      FormData data = FormData.fromMap(loginUserMap);
      final dio = dioClient();
      return await dio
          .post('delivery_person_attendance/checkout_validation', data: data)
          .then((response) {
        if (response.data['err_code'] == "valid") {
          return response.data['err_code'];
        } else if (response.data['err_code'] == "invalid") {
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
