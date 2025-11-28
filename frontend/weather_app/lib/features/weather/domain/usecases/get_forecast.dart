import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/core/errors/failures.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';

/// Get weather forecast use case (current + hourly + daily)
class GetForecast {
  final WeatherRepository repository;

  GetForecast(this.repository);

  Future<Either<Failure, WeatherForecast>> call(
    GetForecastParams params,
  ) async {
    return await repository.getForecast(
      latitude: params.latitude,
      longitude: params.longitude,
      city: params.city,
      temperatureUnit: params.temperatureUnit,
      windSpeedUnit: params.windSpeedUnit,
      precipitationUnit: params.precipitationUnit,
      timezone: params.timezone,
      forecastDays: params.forecastDays,
      pastDays: params.pastDays,
      forceRefresh: params.forceRefresh,
    );
  }
}

/// Get forecast parameters
class GetForecastParams extends Equatable {
  final double? latitude;
  final double? longitude;
  final String? city;
  final String temperatureUnit;
  final String windSpeedUnit;
  final String precipitationUnit;
  final String timezone;
  final int forecastDays;
  final int pastDays;
  final bool forceRefresh;

  GetForecastParams({
    this.latitude,
    this.longitude,
    this.city,
    this.temperatureUnit = 'celsius',
    this.windSpeedUnit = 'kmh',
    this.precipitationUnit = 'mm',
    this.timezone = 'auto',
    this.forecastDays = 7,
    this.pastDays = 0,
    this.forceRefresh = false,
  }) : assert(
         (latitude != null && longitude != null) ||
             (city != null && city.isNotEmpty),
         'Either coordinates or a city name must be provided',
       );

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    city,
    temperatureUnit,
    windSpeedUnit,
    precipitationUnit,
    timezone,
    forecastDays,
    pastDays,
    forceRefresh,
  ];
}
