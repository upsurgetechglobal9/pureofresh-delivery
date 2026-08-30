import 'package:dio/dio.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/more/cms_screens/models/faqs_model.dart';

import '../../../../../commons/cod_base_options.dart';

class FaqsRepository extends BaseApi {
  FaqsRepository();

  Future<FaqsResponseModel> featchFaqs() async {
    try {
      final dio = dioClient();
      return await dio.get("faqs").then((response) {
        if (response.data['err_code'] == "valid") {
          var results = response.data;
          return FaqsResponseModel.fromJson(results);
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
