import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/notifications/models/delivery_preferences_model.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/notifications/models/on_going_rides_list_data_model.dart';

import '../../../../commons/cod_base_options.dart';
import '../../../../commons/shared_prefs.dart';
import '../../../../main.dart';
import '../models/dashboard_details_model.dart';
import '../models/orders_list_in_dashboard_model.dart';
import '../notifications/models/single_ongoing_order_model.dart';

class DashBoardDetailsReposotory extends BaseApi {
  DashBoardDetailsReposotory();

  Future<DashBoardDetailsModel> dashBoardDetails({
    required String accessToken,
  }) async {
    try {
      final loginUserMap = <String, dynamic>{
        'access_token': accessToken,
      };
      FormData data = FormData.fromMap(loginUserMap);
      final dio = dioClient();
      return await dio.post('stats/today', data: data).then((response) {
        debugPrint('state/Today response');
        debugPrint(response.data.toString());
        if (response.data['err_code'] == "valid") {
          return DashBoardDetailsModel.fromJson(response.data);
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

  Future updatePushKey({
    required String accessToken,
    required String fireBaseToken,
    required String deviceId,
  }) async {
    try {
      final firebaseKeyData = <String, dynamic>{
        'access_token': accessToken,
        'firebase_token': fireBaseToken,
        'device_id': deviceId
      };
      print('****************PUSHNOTIFICATION KEY*****************');
      print({
        'access_token': accessToken,
        'firebase_token': fireBaseToken,
        'device_id': deviceId
      });
      print('****************PUSHNOTIFICATION KEY*****************');

      FormData data = FormData.fromMap(firebaseKeyData);
      final dio = dioClient();
      return await dio
          .post('Update_firebase_token', data: data)
          .then((response) {
        print('****************$response*****************');
        if (response.data['err_code'] == "valid") {
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      print('****************CATCHHHHHHH*****************');
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

  Future<String> backgroundLocationUpdate({
    required String accessToken,
    required String latitude,
    required String longitude,
  }) async {
    final batteryPercentage = await battery.batteryLevel;
    debugPrint('current battery percentage: $batteryPercentage');
    try {
      final statusdata = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
        'latitude': latitude,
        'longitude': longitude,
        'battery_percent': batteryPercentage
      };
      FormData data = FormData.fromMap(statusdata);
      final dio = dioClient();
      return await dio.post('Update_location', data: data).then((response) {
        if (response.data['err_code'] == "valid") {
          return response.data['data'].toString();
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

  Future<MyOrdersListDashBoardModel> ordersListApiCall({
    required String latitude,
    required String longitude,
  }) async {
    try {
      final statusdata = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
        'latitude': latitude,
        'longitude': longitude
      };
      FormData data = FormData.fromMap(statusdata);
      final dio = dioClient();
      return await dio
          .post('orders/accepted_notcompleted_orders', data: data)
          .then((response) {
        if (response.data['err_code'] == "valid") {
          return MyOrdersListDashBoardModel.fromJson(response.data);
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

  Future<OngoingRidesResponseModel> fetchOngingRides(String type) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': Constants.prefs!.getString("token"),
        // 'type': type,
      });
      final dio = dioClient();
      return await dio
          .post("rides/ongoing_not_completed_rides", data: data)
          .then((response) {
        if (response.data['err_code'] == "valid") {
          return OngoingRidesResponseModel.fromJson(response.data);
        } else if (response.data['err_code'] == "invalid") {
          return OngoingRidesResponseModel(
            errCode: '',
            data: [],
          );
        }
        {
          return OngoingRidesResponseModel(
            errCode: '',
            data: [],
          );
        }
      });
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw ("Unable to connect to the server at this time. Please try again");
        }
      }
      rethrow;
    }
  }

  Future<DeliveryServiceResponse> fetchDeliveryPreferences() async {
    try {
      FormData data = FormData.fromMap({
        'access_token': Constants.prefs!.getString(
            "token"), //'1711017918',//Constants.prefs!.getString("token"),
      });
      final dio = dioClient();
      return await dio.post("status_check", data: data).then((response) {
        print(response);
        if (response.data['err_code'] == "valid") {
          return DeliveryServiceResponse.fromJson(response.data);
        } else {
          throw 'DeliveryServiceNotFound';
        }
      });
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw ("Unable to connect to the server at this time. Please try again");
        }
      }
      rethrow;
    }
  }

  Future<SingleOngoingOrderModel> fetchSingleOrderList() async {
    try {
      FormData data = FormData.fromMap({
        'access_token': Constants.prefs!.getString("token"),
      });
      final dio = dioClient();
      return await dio
          .post("rides/ongoing_not_completed_rides", data: data)
          .then((response) {
        if (response.data['err_code'] == 'valid') {
          return SingleOngoingOrderModel.fromJson(response.data);
        } else {
          return SingleOngoingOrderModel(errCode: 'invalid', data: []);
        }
      });
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw ("Unable to connect to the server at this time. Please try again");
        }
      }
      rethrow;
    }
  }

  Future<bool> statusUpdateApi({
    required String accessToken,
    required bool status,
  }) async {
    try {
      final batteryPercentage = await battery.batteryLevel;
      debugPrint('current battery percentage: $batteryPercentage');

      final loginUserMap = <String, dynamic>{
        'access_token': accessToken,
        'is_online': status,
        'battery_percent': batteryPercentage
      };
      FormData data = FormData.fromMap(loginUserMap);
      final dio = dioClient();
      return await dio
          .post('Online_or_offline_status/update', data: data)
          .then((response) async {
        if (response.data['err_code'] == "valid") {
          print('*************valid******************');
          print(response.data['data']);
          print('**************valid*****************');
          await Constants.prefs!.setBool("status", response.data['data']);

          return response.data['data'];
        } else if (response.data['err_code'] == "invalid") {
          return false;
        } else {
          return false;
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
