import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/core/errors/failures.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';

/// Get historical weather use case
class GetHistoricalWeather {
  final WeatherRepository repository;

  GetHistoricalWeather(this.repository);

  Future<Either<Failure, WeatherForecast>> call(
    GetHistoricalWeatherParams params,
  ) async {
    return await repository.getHistoricalWeather(
      latitude: params.latitude,
      longitude: params.longitude,
      city: params.city,
      startDate: params.startDate,
      endDate: params.endDate,
      temperatureUnit: params.temperatureUnit,
      windSpeedUnit: params.windSpeedUnit,
      precipitationUnit: params.precipitationUnit,
      timezone: params.timezone,
    );
  }
}

/// Get historical weather parameters
class GetHistoricalWeatherParams extends Equatable {
  final double? latitude;
  final double? longitude;
  final String? city;
  final String startDate; // YYYY-MM-DD
  final String endDate; // YYYY-MM-DD
  final String temperatureUnit;
  final String windSpeedUnit;
  final String precipitationUnit;
  final String timezone;

  GetHistoricalWeatherParams({
    this.latitude,
    this.longitude,
    this.city,
    required this.startDate,
    required this.endDate,
    this.temperatureUnit = 'celsius',
    this.windSpeedUnit = 'kmh',
    this.precipitationUnit = 'mm',
    this.timezone = 'auto',
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
    startDate,
    endDate,
    temperatureUnit,
    windSpeedUnit,
    precipitationUnit,
    timezone,
  ];
}
