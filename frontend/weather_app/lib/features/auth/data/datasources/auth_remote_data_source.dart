import 'package:weather_app/core/errors/exceptions.dart';
import 'package:weather_app/core/network/api_client.dart';
import 'package:weather_app/features/auth/data/models/auth_response_dto.dart';
import 'package:weather_app/features/auth/data/models/login_request_dto.dart';
import 'package:weather_app/features/auth/data/models/register_request_dto.dart';

/// Remote data source for authentication
abstract class AuthRemoteDataSource {
  /// Login user
  Future<AuthResponseDto> login(LoginRequestDto request);

  /// Register user
  Future<AuthResponseDto> register(RegisterRequestDto request);
}

/// Implementation of AuthRemoteDataSource
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<AuthResponseDto> login(LoginRequestDto request) async {
    try {
      final response = await apiClient.dio.post(
        '/auth/login',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return AuthResponseDto.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException('Login failed');
      }
    } catch (e, trace) {
      print(trace);
      if (e is ServerException ||
          e is NetworkException ||
          e is AuthenticationException) {
        rethrow;
      }
      throw ServerException('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<AuthResponseDto> register(RegisterRequestDto request) async {
    try {
      final response = await apiClient.dio.post(
        '/auth/register',
        data: request.toJson(),
      );

      if (response.statusCode == 201) {
        return AuthResponseDto.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException('Registration failed');
      }
    } catch (e) {
      if (e is ServerException ||
          e is NetworkException ||
          e is ValidationException) {
        rethrow;
      }
      throw ServerException('Registration failed: ${e.toString()}');
    }
  }
}
