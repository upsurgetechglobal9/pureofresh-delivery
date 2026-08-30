import 'package:dio/dio.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/more/cms_screens/models/delivery_preferences_data_model.dart';

import '../../../../../commons/cod_base_options.dart';
import '../../../../../commons/shared_prefs.dart';
import '../models/vehicles_as_per_preferences_model.dart';

class DeliveryPreferencesRepository extends BaseApi {
  DeliveryPreferencesRepository();

  Future<DeliveryPreferencesResponseModel> featchDeliveryPreferences() async {
    try {
      final loginUserMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
      };
      FormData data = FormData.fromMap(loginUserMap);
      final dio = dioClient();
      return await dio
          .post("delivery_preferences", data: data)
          .then((response) {
        if (response.data['err_code'] == "valid") {
          var results = response.data;
          return DeliveryPreferencesResponseModel.fromJson(results);
        } else if (response.data['err_code'] == "invalid") {
          return DeliveryPreferencesResponseModel(data: []);
        } else {
          throw (response.data['err_code']);
        }
      });
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw ("Server error");
        } else {
          throw ("preferences not avalible wow");
        }
      } else {
        rethrow;
      }
    }
  }

  Future<List<PreferVehicleData>> fetchVechiles(String deliveryTypeId) async {
    try {
      final vechileIdMap = <String, dynamic>{
        'delivery_type_id': deliveryTypeId,
      };
      FormData data = FormData.fromMap(vechileIdMap);
      final dio = dioClient();
      return await dio.post("register/get_vehicles", data: data).then(
        (response) {
          if (response.data['err_code'] == "valid") {
            return VehicleAsPerPrefernceModelResponse.fromMap(response.data)
                .statesPreferVechileList;
          } else {
            return VehicleAsPerPrefernceModelResponse.emptyList()
                .statesPreferVechileList;
          }
        },
      );
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw ("Server error");
        } else {
          throw ("Unable to fetch service name.");
        }
      } else {
        rethrow;
      }
    }
  }

  Future<String> featchDeliveryType() async {
    try {
      final loginUserMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
      };
      FormData data = FormData.fromMap(loginUserMap);
      final dio = dioClient();
      return await dio.post('profile', data: data).then((response) {
        if (response.data['err_code'] == "valid") {
          return response.data['delivery_person_details']['delivery_type_id'];
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

  Future<bool> updateDeliveryPreferences(String selectedIds) async {
    try {
      final loginUserMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString("token"),
        'delivery_preferences': selectedIds,
      };
      FormData data = FormData.fromMap(loginUserMap);

      final dio = dioClient();
      return await dio
          .post("Delivery_preferences/update_preferences", data: data)
          .then((response) {
        if (response.data['err_code'] == "valid") {
          return response.data['err_code'] == "valid";
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
