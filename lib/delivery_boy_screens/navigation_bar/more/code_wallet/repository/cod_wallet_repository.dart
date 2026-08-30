import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../commons/cod_base_options.dart';
import '../../../../../commons/shared_prefs.dart';
import '../models/razorpay_payment_model.dart';
import '../models/wallet_history_data_model.dart';

class WalletRepository extends BaseApi {
  WalletRepository();

  Future<WalletHistoryDataModel> loadMoreWalletHistory({int page = 1}) async {
    try {
      final updateMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString('token'),
        'page_no': page,
      };

      FormData data = FormData.fromMap(updateMap);
      print(data.fields);
      final dio = dioClient();
      return await dio.post('cod_wallet', data: data).then((response) {
        final res = jsonDecode(response.data);
        if (res['err_code'] == "valid") {
          return WalletHistoryDataModel.fromJson(res['data']);
        } else {
          throw (res['message']);
        }
      });
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw ("Server error");
        } else {
          throw ("Unable to get restaurants");
        }
      } else {
        rethrow;
      }
    }
  }

  Future<int> genarateOrderid() async {
    try {
      final dio = dioClient();
      return await dio.get('cod_wallet/generate_order_id').then((response) {
        final res = jsonDecode(response.data);

        if (res['err_code'] == "valid") {
          return res['data'];
        } else {
          throw (res['err_code']);
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

  Future<RazorpayPaymentModel> initiatePayment({
    required int orderId,
    required String amount,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': Constants.prefs!.getString('token'),
        'order_id': orderId,
        'amount': amount,
      });
      final dio = dioClient();
      return await dio
          .post('cod_wallet/initiate_order', data: data)
          .then((response) {
        final res = jsonDecode(response.data);

        if (res['err_code'] == "valid") {
          return RazorpayPaymentModel.fromJson(res);
        } else {
          throw (res['message'] ?? res['err_code']);
        }
      });
    } catch (e) {
      print('Error in initiatePayment: $e');
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw ("Server error");
        } else {
          throw ("Unable to initiate payment");
        }
      } else {
        rethrow;
      }
    }
  }

  Future<String> confirmPaymentSuccess({
    required String orderId,
    required String paymentId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': Constants.prefs!.getString('token'),
        'order_id': orderId.toString(),
        'payment_id': paymentId,
      });
      print("Hello Hari>>>> ${data.files}");
      final dio = dioClient();
      return await dio
          .get('cod_wallet/payment_success/$orderId')
          .then((response) {
        final res = jsonDecode(response.data);

        if (res['err_code'] == "valid") {
          return res['message'] ?? 'Payment confirmed successfully';
        } else {
          throw (res['message'] ?? res['err_code']);
        }
      });
    } catch (e) {
      print('Error in confirmPaymentSuccess: $e');
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw ("Server error");
        } else {
          throw ("Unable to confirm payment");
        }
      } else {
        rethrow;
      }
    }
  }

  Future<String> confirmPaymentFail({
    required String orderId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': Constants.prefs!.getString('token'),
        'order_id': orderId.toString(),
      });
      print("Hello Hari>>>> ${data.files}");
      final dio = dioClient();
      return await dio.get('cod_wallet/payment_fail/$orderId').then((response) {
        final res = jsonDecode(response.data);

        if (res['err_code'] == "valid") {
          return res['message'] ?? 'Payment confirmed successfully';
        } else {
          throw (res['message'] ?? res['err_code']);
        }
      });
    } catch (e) {
      print('Error in confirmPaymentSuccess: $e');
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw ("Server error");
        } else {
          throw ("Unable to confirm payment");
        }
      } else {
        rethrow;
      }
    }
  }
}
