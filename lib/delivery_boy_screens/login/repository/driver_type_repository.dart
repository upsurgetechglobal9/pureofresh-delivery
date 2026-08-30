import 'package:dio/dio.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/login/models/driver_type_model.dart';

import '../../../../../commons/cod_base_options.dart';

class RiderTypeRepository extends BaseApi {
  RiderTypeRepository();

  Future<RiderTypeResponseModel> featchRiderTypes() async {
    try {
      final dio = dioClient();
      return await dio.get("Vehicle_types").then((response) {
        if (response.data['err_code'] == "valid") {
          var results = response.data;
          return RiderTypeResponseModel.fromJson(results);
        } else {
          throw (response.data['err_code']);
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
}
