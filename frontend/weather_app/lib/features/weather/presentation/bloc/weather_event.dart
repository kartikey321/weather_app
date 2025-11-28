import 'package:equatable/equatable.dart';

/// Base class for all weather events
abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load weather forecast (current + hourly + daily)
class LoadWeatherForecastEvent extends WeatherEvent {
  final double? latitude;
  final double? longitude;
  final String? city;
  final bool forceRefresh;

  LoadWeatherForecastEvent({
    this.latitude,
    this.longitude,
    this.city,
    this.forceRefresh = false,
  }) : assert(
         (latitude != null && longitude != null) ||
             (city != null && city.isNotEmpty),
         'Either coordinates or a city must be provided',
       );

  @override
  List<Object?> get props => [latitude, longitude, city, forceRefresh];
}

/// Event to refresh weather
class RefreshWeatherEvent extends WeatherEvent {
  final double? latitude;
  final double? longitude;
  final String? city;

  RefreshWeatherEvent({this.latitude, this.longitude, this.city})
    : assert(
        (latitude != null && longitude != null) ||
            (city != null && city.isNotEmpty),
        'Either coordinates or a city must be provided',
      );

  @override
  List<Object?> get props => [latitude, longitude, city];
}

/// Event to load historical weather
class LoadHistoricalWeatherEvent extends WeatherEvent {
  final double? latitude;
  final double? longitude;
  final String? city;
  final String startDate; // YYYY-MM-DD
  final String endDate; // YYYY-MM-DD

  LoadHistoricalWeatherEvent({
    this.latitude,
    this.longitude,
    this.city,
    required this.startDate,
    required this.endDate,
  }) : assert(
         (latitude != null && longitude != null) ||
             (city != null && city.isNotEmpty),
         'Either coordinates or a city must be provided',
       );

  @override
  List<Object?> get props => [latitude, longitude, city, startDate, endDate];
}
