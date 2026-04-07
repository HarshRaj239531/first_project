import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import 'storage_service.dart';

/// Professional Dio-based API client with interceptors.
class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
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
    } on DioException catch (e) {
      return {'success': false, 'error': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> post(String url, dynamic body) async {
    try {
      final response = await _dio.post(url, data: body);
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'error': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> put(String url, dynamic body) async {
    try {
      final response = await _dio.put(url, data: body);
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'error': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> delete(String url) async {
    try {
      await _dio.delete(url);
      return {'success': true};
    } on DioException catch (e) {
      return {'success': false, 'error': _handleError(e)};
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      return e.response?.data['message'] ?? 'Something went wrong';
    }
    return e.message ?? 'Unknown error';
  }

  void dispose() {}
}

