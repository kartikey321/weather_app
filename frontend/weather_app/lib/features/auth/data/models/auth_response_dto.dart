import 'package:weather_app/features/auth/data/models/user_model.dart';

/// Auth response DTO
class AuthResponseDto {
  final bool success;
  final String? message;
  final AuthDataDto? data;

  const AuthResponseDto({required this.success, this.message, this.data});

  /// Create from JSON
  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    return AuthResponseDto(
      success: json['success'] as bool,
      message: json['message'] as String?,
      data: json['data'] != null
          ? AuthDataDto.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Auth data DTO containing user and token
class AuthDataDto {
  final UserModel user;
  final String token;

  const AuthDataDto({required this.user, required this.token});

  /// Create from JSON
  factory AuthDataDto.fromJson(Map<String, dynamic> json) {
    return AuthDataDto(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
    );
  }
}
