import 'package:weather_app/features/weather/data/models/weather_model.dart';

/// Weather API response DTO
class WeatherResponseDto {
  final bool success;
  final String? message;
  final WeatherForecastModel? data;
  final bool? cached;

  const WeatherResponseDto({
    required this.success,
    this.message,
    this.data,
    this.cached,
  });

  factory WeatherResponseDto.fromJson(Map<String, dynamic> json) {
    return WeatherResponseDto(
      success: json['success'] as bool,
      message: json['message'] as String?,
      cached: json['cached'] as bool?,
      data: json['data'] != null
          ? WeatherForecastModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}
