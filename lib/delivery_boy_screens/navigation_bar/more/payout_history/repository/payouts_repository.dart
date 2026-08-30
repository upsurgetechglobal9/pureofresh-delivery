import 'package:dio/dio.dart';

import '../../../../../commons/cod_base_options.dart';
import '../../../../../commons/shared_prefs.dart';
import '../model/payout_history_model.dart';

class PayoutHistorysRepository extends BaseApi {
  PayoutHistorysRepository();

  Future<PayoutHistoryModel> PayoutHistoryApiCall({
    required String fromDate,
    required String toDate,
  }) async {
    try {
      final mapData = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
        "from_date": fromDate,
        "to_date": toDate
      };
      FormData data = FormData.fromMap(mapData);
      final dio = dioClient();
      return await dio.post('Payouts', data: data).then((response) {
        if (response.data['err_code'] == "valid") {
          return PayoutHistoryModel.fromJson(response.data);
        }
        if (response.data['err_code'] == "invalid") {
          return PayoutHistoryModel.fromJson(response.data);
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
