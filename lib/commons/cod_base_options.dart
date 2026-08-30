import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:pure_o_fresh_rider_app/commons/show_chuk_notification.dart';

import 'url_links.dart';

class BaseApi {
  static BaseOptions _options() {
    return BaseOptions(
      baseUrl: UrlLinksData.serverUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      responseType: ResponseType.json,
      contentType: Headers.jsonContentType,
    );
  }

  Dio dioClient() {
    Dio dio = Dio(_options());
    addChuck(dio);
    dio.interceptors.add(PrettyDioLogger());
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
    return dio;
  }
}
