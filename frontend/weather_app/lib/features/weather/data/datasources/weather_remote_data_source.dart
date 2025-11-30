import 'package:weather_app/core/errors/exceptions.dart';
import 'package:weather_app/core/constants/api_constants.dart';
import 'package:weather_app/core/network/api_client.dart';
import 'package:weather_app/features/weather/data/models/weather_request_dto.dart';
import 'package:weather_app/features/weather/data/models/weather_response_dto.dart';

/// Remote data source for weather (Open-Meteo API)
abstract class WeatherRemoteDataSource {
  /// Get weather forecast (current + hourly + daily)
  Future<WeatherResponseDto> getForecast(WeatherForecastRequestDto request);

  /// Get historical weather data
  Future<WeatherResponseDto> getHistoricalWeather(
    HistoricalWeatherRequestDto request,
  );
}

/// Implementation of WeatherRemoteDataSource
class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final ApiClient apiClient;

  WeatherRemoteDataSourceImpl(this.apiClient);

  @override
  Future<WeatherResponseDto> getForecast(
    WeatherForecastRequestDto request,
  ) async {
    try {
      final response = await apiClient.dio.get(
        ApiConstants.weatherForecast,
        queryParameters: request.toQueryParams(),
      );

      if (response.statusCode == 200) {
        return WeatherResponseDto.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw ServerException('Failed to fetch weather forecast');
      }
    } catch (e) {
      if (e is ServerException ||
          e is NetworkException ||
          e is RateLimitException) {
        rethrow;
      }
      throw ServerException(
        'Failed to fetch weather forecast: ${e.toString()}',
      );
    }
  }

  @override
  Future<WeatherResponseDto> getHistoricalWeather(
    HistoricalWeatherRequestDto request,
  ) async {
    try {
      final response = await apiClient.dio.get(
        ApiConstants.weatherHistorical,
        queryParameters: request.toQueryParams(),
      );

      if (response.statusCode == 200) {
        return WeatherResponseDto.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw ServerException('Failed to fetch historical weather');
      }
    } catch (e) {
      if (e is ServerException ||
          e is NetworkException ||
          e is RateLimitException) {
        rethrow;
      }
      throw ServerException(
        'Failed to fetch historical weather: ${e.toString()}',
      );
    }
  }
}
