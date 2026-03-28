import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'storage_service.dart';

/// Professional Dio-based API client with interceptors.
class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = StorageService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          if (kDebugMode) {
            print('[API] REQUEST[${options.method}] => PATH: ${options.path}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('[API] RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (kDebugMode) {
            print('[API] ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> get(String url) async {
    try {
      final response = await _dio.get(url);
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> post(String url, Map<String, dynamic> body) async {
    try {
      final response = await _dio.post(url, data: body);
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> put(String url, Map<String, dynamic> body) async {
    try {
      final response = await _dio.put(url, data: body);
      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> delete(String url) async {
    try {
      await _dio.delete(url);
      return {'success': true};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  void dispose() {}
}

