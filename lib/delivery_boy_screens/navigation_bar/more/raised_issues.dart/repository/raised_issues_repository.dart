import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../commons/cod_base_options.dart';
import '../../../../../commons/shared_prefs.dart';
import '../model/raised_issues_model.dart';

class RaisedIssuesRepository extends BaseApi {
  RaisedIssuesRepository();

  Future<RaisedIssuesModel> raisedIssuesDetails({required String type}) async {
    try {
      final loginUserMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString('token'),
        'type_issue': type
      };
      FormData data = FormData.fromMap(loginUserMap);
      final dio = dioClient();
      return await dio.post('issues', data: data).then((response) {
        print(jsonEncode(response.data));
        if (response.data['err_code'] == "valid") {
          print(response.data['message']);
          return RaisedIssuesModel.fromJson(response.data);
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
