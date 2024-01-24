// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';

class RequestsServices {
  static Future<Response> post(String url, Map<String, dynamic>? data) async {
    try {
      Dio dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60)));
      //  Response response = await dio.post("rl", data: data, options: options);
      Response response = await dio.post(url, data: data);
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      } else {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          Response response = Response(
              statusCode: 504,
              requestOptions: RequestOptions(path: ''),
              statusMessage:
                  "Tempo para tentativa de conexão excedido, caso o erro persista entre em contato com a DTI");

          return response;
        } else {
          Response response = Response(
              statusCode: 403,
              requestOptions: RequestOptions(path: ''),
              statusMessage:
                  "Não foi possível estabelecer conexão com o servidor. Por favor verifique se a internet está nula ou limitada e tente novamente.");

          return response;
        }
      }
    }
  }

  static Future<Response> postOptions(
      String url, Map<String, dynamic>? data, Options options) async {
    try {
      // CancelToken token = CancelToken();
      Dio dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60)));
      //  Response response = await dio.post("rl", data: data, options: options);
      Response response = await dio.post(url, data: data, options: options);
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      } else {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          Response response = Response(
              statusCode: 504,
              requestOptions: RequestOptions(path: ''),
              statusMessage:
                  "Tempo para tentativa de conexão excedido, caso o erro persista entre em contato com a DTI");

          return response;
        } else {
          Response response = Response(
              statusCode: 403,
              requestOptions: RequestOptions(path: ''),
              statusMessage:
                  "Não foi possível estabelecer conexão com o servidor. Por favor verifique se a internet está nula ou limitada e tente novamente.");

          return response;
        }
      }
    }
  }

  static Future<Response> postOptionsWithByteArrayResponse(
      String url, Map<String, dynamic>? data, Options options) async {
    try {
      Dio dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60)));
      options.responseType = ResponseType.bytes;
      var response = await dio.post(url, data: data, options: options);

      return response;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        return e.response!;
      }
      if (e.response != null) {
        return e.response!;
      } else {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          var response = Response(
              statusCode: 504,
              requestOptions: RequestOptions(path: ''),
              statusMessage:
                  "Tempo para tentativa de conexão excedido, caso o erro persista entre em contato com a DTI");

          return response;
        } else {
          var response = Response(
              statusCode: 403,
              requestOptions: RequestOptions(path: ''),
              statusMessage:
                  "Não foi possível estabelecer conexão com o servidor. Por favor verifique se a internet está nula ou limitada e tente novamente.");

          return response;
        }
      }
    }
  }

  static Future<Response> get(String url, Options options) async {
    try {
      Dio dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60)));
      Response response = await dio.post(url, options: options);

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      } else {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          Response response = Response(
              statusCode: 504,
              requestOptions: RequestOptions(path: ''),
              statusMessage:
                  "Tempo para tentativa de conexão excedido, caso o erro persista entre em contato com a DTI");

          return response;
        } else {
          Response response = Response(
              statusCode: 403,
              requestOptions: RequestOptions(path: ''),
              statusMessage:
                  "Não foi possível estabelecer conexão com o servidor. Por favor verifique se a internet está nula ou limitada e tente novamente.");

          return response;
        }
      }
    }
  }
}
