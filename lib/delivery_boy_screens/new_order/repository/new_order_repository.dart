import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/new_order/models/cab_new_order_model.dart';

import '../../../../../commons/cod_base_options.dart';
import '../../../commons/shared_prefs.dart';
import '../models/new_order_model.dart';
import '../models/order_accepting_model.dart';

class NewOrderRepository extends BaseApi {
  NewOrderRepository();

  Future<NewOrderDetailsModel> newOrderDetailsApiCall(
      {required String referId, required String? type}) async {
    try {
      final orderMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
        'ref_id': Constants.prefs!.getString("orderId"),
        'type': type,

        // 'ref_id': '$referId'
      };
      print(orderMap);
      FormData data = FormData.fromMap(orderMap);
      final dio = dioClient();
      return await dio.post('Order_view', data: data).then((response) {
        if (response.data['err_code'] == "valid") {
          return NewOrderDetailsModel.fromJson(response.data);
        }
        if (response.data['err_code'] == "invalid") {
          return NewOrderDetailsModel.fromJson(response.data['data']);
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

  Future<CabRideDetailModel> newOrderCabDetailsApiCall(
      {required String referId, String? apptype}) async {
    try {
      final orderMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
        'booking_id': referId,
        'type': apptype,
        // 'ref_id': '$referId'
      };
      FormData data = FormData.fromMap(orderMap);
      final dio = dioClient();
      return await dio.post('rides/view', data: data).then((response) {
        if (response.data['err_code'] == "valid") {
          return CabRideDetailModel.fromJson(response.data);
        }
        if (response.data['err_code'] == "invalid") {
          Fluttertoast.showToast(msg: response.data['message'].toString());

          return CabRideDetailModel.fromJson(response.data['data']);
        } else {
          Fluttertoast.showToast(msg: response.data['message'].toString());

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

  Future<OrderAcceptResponseModel> acceptingOrderApiCall({
    required String referId,
  }) async {
    try {
      final sharedPref = await SharedPreferences.getInstance();
      final orderMap = <String, dynamic>{
        'access_token': sharedPref.getString("token"),
        'ref_id': referId
      };
      FormData data = FormData.fromMap(orderMap);
      final dio = dioClient();
      return await dio
          .post('Update_order_status/accepted', data: data)
          .then((response) {
        if (response.data['err_code'] == "valid") {
          return OrderAcceptResponseModel.fromJson(response.data);
        }
        if (response.data['err_code'] == "invalid") {
          Fluttertoast.showToast(msg: response.data['message'].toString());
          return OrderAcceptResponseModel.fromJson(response.data);
        } else {
          Fluttertoast.showToast(msg: response.data['message'].toString());

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

  Future<OrderAcceptResponseModel> acceptingOrderCabApiCall(
      {required String referId, String? apptype}) async {
    print('>>>>>>>>>>>>>>>>>>>app$apptype');
    try {
      final sharedPref = await SharedPreferences.getInstance();
      final orderMap = <String, dynamic>{
        'access_token': sharedPref.getString("token"),
        'ride_id': referId,
        'type': apptype
      };
      FormData data = FormData.fromMap(orderMap);

      print('>>>>>>>>>>>>>>>>>>>>>>checking data $data');
      final dio = dioClient();
      return await dio.post('rides/accept', data: data).then((response) {
        if (response.data['err_code'] == "valid") {
          return OrderAcceptResponseModel.fromJson(response.data);
        }
        if (response.data['err_code'] == "invalid") {
          return OrderAcceptResponseModel.fromJson(response.data);
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

  Future reachedtoRestarentApiCall({
    required String referId,
  }) async {
    try {
      final orderMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
        'ref_id': Constants.prefs!.getString("orderId"),
        // 'ref_id': '2023082190740'
      };
      FormData data = FormData.fromMap(orderMap);
      final dio = dioClient();
      return await dio
          .post('Update_order_status/pickedup_order', data: data)
          .then((response) {
        if (response.data['err_code'] == "valid") {
          return response.data['err_code'];
        }
        if (response.data['err_code'] == "invalid") {
          Fluttertoast.showToast(msg: response.data['message'].toString());

          return response.data['err_code'];
        } else {
          Fluttertoast.showToast(msg: response.data['message'].toString());

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

  Future<OrderAcceptResponseModel> cabReachedtoRestarentApiCall(
      {required String referId, required String apptype}) async {
    try {
      final orderMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
        'ride_id': referId,
        'type': apptype
        // 'ref_id': '2023082190740'
      };
      FormData data = FormData.fromMap(orderMap);
      final dio = dioClient();
      return await dio
          .post('rides/reached_pickup_location', data: data)
          .then((response) {
        if (response.data['err_code'] == "valid") {
          return OrderAcceptResponseModel.fromJson(response.data);
        }
        if (response.data['err_code'] == "invalid") {
          return OrderAcceptResponseModel.fromJson(response.data);
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

  Future<OrderAcceptResponseModel> otpfromUserApiCall(
      {required String referId,
      required String apptype,
      required String pin}) async {
    try {
      final orderMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
        'ride_id': referId,
        'type': apptype,
        'pin': pin
        // 'ref_id': '2023082190740'
      };
      FormData data = FormData.fromMap(orderMap);
      final dio = dioClient();
      return await dio.post('rides/validatepin', data: data).then((response) {
        if (response.data['err_code'] == "valid") {
          return OrderAcceptResponseModel.fromJson(response.data);
        }
        if (response.data['err_code'] == "invalid") {
          return OrderAcceptResponseModel.fromJson(response.data);
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

  // Future otpfromUserApiCall(
  //     {required String referId,
  //     required String apptype,
  //     required String pin}) async {
  //   try {
  //     final orderMap = <String, dynamic>{
  //       'access_token': Constants.prefs!.getString("token"),
  //       'ride_id': referId,
  //       'type': apptype,
  //       'pin': pin
  //       // 'ref_id': '2023082190740'
  //     };
  //     FormData data = FormData.fromMap(orderMap);
  //     final dio = dioClient();
  //     return await dio.post('rides/validatepin', data: data).then((response) {
  //       if (response.data['err_code'] == "valid") {
  //         return response.data['err_code'];
  //       }
  //       if (response.data['err_code'] == "invalid") {
  //         return response.data['err_code'];
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

  Future completeStopsCabApiCall({
    required String referId,
    required String apptype,
    required String locationId,
  }) async {
    try {
      final orderMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
        'booking_id': referId,
        'type': apptype,
        'location_id': locationId
      };
      FormData data = FormData.fromMap(orderMap);
      final dio = dioClient();
      return await dio
          .post('rides/reached_to_dropping_location', data: data)
          .then((response) {
        if (response.data['err_code'] == "valid") {
          return response.data['err_code'];
        }
        if (response.data['err_code'] == "invalid") {
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

  Future completeOrderCabApiCall({
    required String referId,
    required String apptype,
  }) async {
    try {
      final orderMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
        'ride_id': referId,
        'type': apptype
        // 'ref_id': '2023082190740',
        // 'delivery_otp': '$otp'
      };
      FormData data = FormData.fromMap(orderMap);
      final dio = dioClient();
      return await dio
          .post('rides/confirmComplete', data: data)
          .then((response) {
        if (response.data['err_code'] == "valid") {
          return response.data['err_code'];
        }
        if (response.data['err_code'] == "invalid") {
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

  Future pickUpFromrestarantAndOutforDeliveryApiCall({
    required String referId,
    required String exchangeItem1,
    required String exchangeItem2,
    required String exchangeItem3,
  }) async {
    try {
      final orderMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
        'ref_id': Constants.prefs!.getString("orderId"),
        'exchange_item1': exchangeItem1,
        'exchange_item2': exchangeItem2,
        'exchange_item3': exchangeItem3
        // 'ref_id': '$referId'
      };
      FormData data = FormData.fromMap(orderMap);

      final dio = dioClient();
      return await dio
          .post('Update_order_status/out_for_delivery', data: data)
          .then((response) {
        if (response.data['err_code'] == "valid") {
          return response.data['err_code'];
        }
        if (response.data['err_code'] == "invalid") {
          Fluttertoast.showToast(msg: response.data['message']);
          return response.data['err_code'];
        }
        if (response.data['err_code'] == "invalid_complete") {
          Fluttertoast.showToast(msg: response.data['message']);
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

  Future reachedDeliveryApiCall({
    required String referId,
  }) async {
    try {
      final orderMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
        'ref_id': Constants.prefs!.getString("orderId"),
        // 'ref_id': '$referId'
      };
      FormData data = FormData.fromMap(orderMap);
      final dio = dioClient();
      return await dio
          .post('Update_order_status/reached_delivery_order', data: data)
          .then((response) {
        if (response.data['err_code'] == "valid") {
          return response.data['err_code'];
        }
        if (response.data['err_code'] == "invalid") {
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

  // Future collectingCashApiCall({
  //   required String ammount,
  // }) async {
  //   try {
  //     final orderMap = <String, dynamic>{
  //       'access_token': Constants.prefs!.getString("token"),
  //       'cod_amount': '$ammount'
  //     };
  //     FormData data = FormData.fromMap(orderMap);
  //     final dio = dioClient();
  //     return await dio.post('Update_cod_cash', data: data).then((response) {
  //       if (response.data['err_code'] == "valid") {
  //         return response.data['err_code'];
  //       }
  //       if (response.data['err_code'] == "invalid") {
  //         return response.data['err_code'];
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

  // Future otpfromUserApiCall({
  Future completeOrderApiCall({required String otp,}) async {
    try {
      final orderMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
        'ref_id': Constants.prefs!.getString("orderId"),
        'delivery_otp': '$otp'
      };
      FormData data = FormData.fromMap(orderMap);

      final dio = dioClient();
      return await dio
          .post('Update_order_status/mark_as_delivered', data: data)
          .then((response) {
        if (response.data['err_code'] == "valid") {
          return response.data['err_code'];
        }
        if (response.data['err_code'] == "invalid") {
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
