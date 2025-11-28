import 'package:dartz/dartz.dart';
import 'package:weather_app/core/errors/failures.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';

/// Weather repository interface (Open-Meteo API)
abstract class WeatherRepository {
  /// Get weather forecast (current + hourly + daily)
  Future<Either<Failure, WeatherForecast>> getForecast({
    double? latitude,
    double? longitude,
    String? city,
    String temperatureUnit = 'celsius',
    String windSpeedUnit = 'kmh',
    String precipitationUnit = 'mm',
    String timezone = 'auto',
    int forecastDays = 7,
    int pastDays = 0,
    bool forceRefresh = false,
  });

  /// Get historical weather data
  Future<Either<Failure, WeatherForecast>> getHistoricalWeather({
    double? latitude,
    double? longitude,
    String? city,
    required String startDate,
    required String endDate,
    String temperatureUnit = 'celsius',
    String windSpeedUnit = 'kmh',
    String precipitationUnit = 'mm',
    String timezone = 'auto',
  });
}
