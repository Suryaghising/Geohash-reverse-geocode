import 'package:dio/dio.dart';
import 'package:geohash_reverse_geocode/utils/constants.dart';

class NetworkHelper {
  Dio getDioClient({bool connectionTimeout = true}) {
    Dio dio = Dio(BaseOptions(baseUrl: kBaseUrl, connectTimeout: connectionTimeout? const Duration(milliseconds: 20 * 1000): null));
    return dio;
  }

  Future<Response> getRequest(
      String path, {
        final contentType,
      }) async {
    Dio dio = getDioClient();
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
    Options options = Options(headers: contentType ?? headers, responseType: ResponseType.json);
    try {
      final response = await dio.get(
        path,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      if((e.message ?? '').contains('SocketException')) {
        return Response(
          data: {'status': e.error, 'message': 'No internet connection.'},
          statusCode: e.response?.statusCode,
          requestOptions: e.requestOptions,
        );
      }
      if(e.type == DioExceptionType.connectionTimeout) {
        return Response(requestOptions: e.requestOptions, data: {'status': e.error, 'message': 'Connection Timeout. Check your internet connection and try again.'});
      }
      return Response(
        data: e.response?.data,
        statusCode: e.response?.statusCode,
        requestOptions: e.requestOptions,
      );
    }
  }

  Future<Response> patchRequest(
      String path, {
        dynamic data,
        bool? connectionTimeout
      }) async {

    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    Dio dio = getDioClient(connectionTimeout: connectionTimeout ?? true);
    Options options = Options(headers: headers, responseType: ResponseType.json);
    try {
      final response = await dio.patch(
        path,
        data: data,
        options: options,
      );
      return response;

    } on DioException catch (e) {
      if((e.message ?? '').contains('SocketException')) {
        return Response(
          data: {'status': e.error, 'message': 'No internet connection.'},
          statusCode: e.response?.statusCode,
          requestOptions: e.requestOptions,
        );
      }
      if(e.type == DioExceptionType.connectionTimeout) {
        return Response(requestOptions: e.requestOptions, data: {'status': e.error, 'message': 'Connection Timeout. Check your internet connection and try again.'});
      }
      return Response(
        data: e.response?.data,
        statusCode: e.response?.statusCode,
        requestOptions: e.requestOptions,
      );
    }
  }

  Future<Response> postRequest(
      String path, {
        dynamic data,
        bool? connectionTimeout
      }) async {

    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    Dio dio = getDioClient(connectionTimeout: connectionTimeout ?? true);
    Options options = Options(headers: headers, responseType: ResponseType.json);
    try {
      final response = await dio.post(
        path,
        data: data,
        options: options,
      );
      return response;

    } on DioException catch (e) {
      if((e.message ?? '').contains('SocketException')) {
        return Response(
          data: {'status': e.error, 'message': 'No internet connection.'},
          statusCode: e.response?.statusCode,
          requestOptions: e.requestOptions,
        );
      }
      if(e.type == DioExceptionType.connectionTimeout) {
        return Response(requestOptions: e.requestOptions, data: {'status': e.error, 'message': 'Connection Timeout. Check your internet connection and try again.'});
      }
      return Response(
        data: e.response?.data,
        statusCode: e.response?.statusCode,
        requestOptions: e.requestOptions,
      );
    }
  }
}
