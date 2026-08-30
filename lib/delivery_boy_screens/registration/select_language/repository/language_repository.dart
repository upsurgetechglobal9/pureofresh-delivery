import 'package:dio/dio.dart';

import '../../../../../commons/cod_base_options.dart';
import '../models/language_model.dart';

class LanguagesRepository extends BaseApi {
  LanguagesRepository();

  Future<LanguageModel> gettingLanuages() async {
    try {
      final dio = dioClient();
      return await dio.post('delivery_language_settings').then((response) {
        if (response.data['err_code'] == "valid") {
          return LanguageModel.fromJson(response.data);
        } else {
          throw (response.data['title']);
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

  Future<dynamic> continueWithLanguage({required String language}) async {
    try {
      final dio = dioClient();
      final languageId = <String, dynamic>{
        'language_id': language.toString(),
      };
      FormData myData = FormData.fromMap(languageId);
      return await dio.post('Language_settings', data: myData).then((response) {
        if (response.data['err_code'] == "valid") {
          return response.data['language_titles'];
          // return LanguagetitlesModel.fromJson(response.data['language_titles']);

          // return response.data['err_code'];
        } else {
          throw (response.data['title']);
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
