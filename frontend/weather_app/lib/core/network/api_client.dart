import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:weather_app/core/constants/api_constants.dart';
import 'package:weather_app/core/constants/storage_keys.dart';
import 'package:weather_app/core/errors/exceptions.dart';

/// API Client with Dio
class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  ApiClient(this._dio, this._secureStorage) {
    _dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Add interceptors
    _dio.interceptors.addAll([
      _authInterceptor(),
      _errorInterceptor(),
      // PrettyDioLogger(
      //   requestHeader: true,
      //   requestBody: true,
      //   responseHeader: true,
      //   responseBody: true,
      //   error: true,
      //   compact: true,
      // ),
    ]);
  }

  /// Auth interceptor - Adds JWT token to requests
  InterceptorsWrapper _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Get JWT token from secure storage
        final token = await _secureStorage.read(key: StorageKeys.jwtToken);

        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(options);
      },
    );
  }

  /// Error interceptor - Handles errors and converts to exceptions
  InterceptorsWrapper _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) async {
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.sendTimeout) {
          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: NetworkException('Connection timeout'),
            ),
          );
        }

        if (error.type == DioExceptionType.connectionError) {
          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: NetworkException('No internet connection'),
            ),
          );
        }

        final statusCode = error.response?.statusCode;

        if (statusCode != null) {
          switch (statusCode) {
            case 400:
              return handler.reject(
                DioException(
                  requestOptions: error.requestOptions,
                  error: ValidationException(
                    _extractErrorMessage(error),
                  ),
                ),
              );
            case 401:
            case 403:
              // Clear stored token on auth failure
              await _secureStorage.delete(key: StorageKeys.jwtToken);
              return handler.reject(
                DioException(
                  requestOptions: error.requestOptions,
                  error: AuthenticationException(
                    _extractErrorMessage(error),
                  ),
                ),
              );
            case 404:
              return handler.reject(
                DioException(
                  requestOptions: error.requestOptions,
                  error: NotFoundException(
                    _extractErrorMessage(error),
                  ),
                ),
              );
            case 429:
              return handler.reject(
                DioException(
                  requestOptions: error.requestOptions,
                  error: RateLimitException(
                    _extractErrorMessage(error),
                  ),
                ),
              );
            case 500:
            case 502:
            case 503:
            case 504:
              return handler.reject(
                DioException(
                  requestOptions: error.requestOptions,
                  error: ServerException(
                    _extractErrorMessage(error),
                  ),
                ),
              );
          }
        }

        return handler.next(error);
      },
    );
  }

  /// Extract error message from response
  String _extractErrorMessage(DioException error) {
    try {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        // Backend error format: { "success": false, "error": { "message": "..." } }
        if (data['error'] != null && data['error']['message'] != null) {
          return data['error']['message'];
        }
        // Fallback to message field
        if (data['message'] != null) {
          return data['message'];
        }
      }
    } catch (_) {}

    return error.message ?? 'An unexpected error occurred';
  }

  /// Get Dio instance
  Dio get dio => _dio;
}
