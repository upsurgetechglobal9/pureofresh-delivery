import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/notifications/models/notifications_data_model.dart';

import '../../../../../commons/cod_base_options.dart';
import '../../../../../commons/shared_prefs.dart';
import '../models/notifications_model.dart';

class NotificationsRepository extends BaseApi {
  NotificationsRepository();

  Future<NotificationsModel> notificationsDetails({
    required String start,
    required String seenStatus,
  }) async {
    try {
      final loginUserMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
        'start': start,
        'seen_status': seenStatus
      };
      FormData data = FormData.fromMap(loginUserMap);
      final dio = dioClient();
      return await dio.post('Notifications', data: data).then((response) {
        if (response.data['err_code'] == "valid") {
          return NotificationsModel.fromJson(response.data);
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

  Future<NotificationsDataNewResponseModel> notificationsDetailsNew({
    int page = 1,
    required String seenStatus,
  }) async {
    try {
      final loginUserMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
        'start': page,
        'seen_status': seenStatus,
        'limit': 10,
      };
      FormData data = FormData.fromMap(loginUserMap);
      final dio = dioClient();
      return await dio.post('Notifications', data: data).then((response) {
        if (response.data['err_code'] == "valid") {
          return NotificationsDataNewResponseModel.fromJson(
              response.data['data']);
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

  Future<bool> singleViewNotifications({required String id}) async {
    try {
      final accesstoken = Constants.prefs!.getString("token");
      FormData data = FormData.fromMap({
        'access_token': accesstoken,
        'id': id,
      });
      final dio = dioClient();
      return await dio
          .post("Notifications/mark_as_read_single", data: data)
          .then((response) {
        if (response.data['err_code'] == "valid") {
          return response.data['err_code'] == "valid";
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw ("Server error");
        }
      }
      rethrow;
    }
  }

  Future<bool> markAsReasAllNotifications() async {
    try {
      final accesstoken = Constants.prefs!.getString("token");
      FormData data = FormData.fromMap({
        'access_token': accesstoken,
      });
      final dio = dioClient();
      return await dio
          .post("Notifications/mark_as_read_all", data: data)
          .then((response) {
        if (response.data['err_code'] == "valid") {
          return response.data['err_code'] == "valid";
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw ("Server error");
        }
      }
      rethrow;
    }
  }

  Future<String> notificationSeen({
    required String id,
  }) async {
    try {
      final loginUserMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
        'id': id,
      };
      FormData data = FormData.fromMap(loginUserMap);
      final dio = dioClient();
      return await dio
          .post('Notifications/mark_as_read_single', data: data)
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

  Future<String> notificationMarkAllSeen() async {
    try {
      final loginUserMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
      };
      FormData data = FormData.fromMap(loginUserMap);
      final dio = dioClient();
      return await dio
          .post('Notifications/mark_as_read_all', data: data)
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
