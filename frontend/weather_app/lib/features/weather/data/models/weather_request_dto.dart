import 'package:weather_app/core/utils/hash_util.dart';

/// Weather forecast request DTO (for Open-Meteo API)
class WeatherForecastRequestDto {
  final double? latitude;
  final double? longitude;
  final String? city;
  final String temperatureUnit;
  final String windSpeedUnit;
  final String precipitationUnit;
  final String timezone;
  final int forecastDays;
  final int pastDays;

  WeatherForecastRequestDto({
    this.latitude,
    this.longitude,
    this.city,
    this.temperatureUnit = 'celsius',
    this.windSpeedUnit = 'kmh',
    this.precipitationUnit = 'mm',
    this.timezone = 'auto',
    this.forecastDays = 7,
    this.pastDays = 0,
  }) : assert(
          (latitude != null && longitude != null) ||
              ((city ?? '').isNotEmpty),
          'Either latitude/longitude or city must be provided',
        );

  /// Generate cache hash for this request
  String generateHash() {
    final cityName = city;
    final params = {
      'endpoint': 'forecast',
      'temperature_unit': temperatureUnit,
      'wind_speed_unit': windSpeedUnit,
      'precipitation_unit': precipitationUnit,
      'timezone': timezone,
      'forecast_days': forecastDays.toString(),
      'past_days': pastDays.toString(),
    };

    if (cityName != null && cityName.isNotEmpty) {
      params['city'] = cityName.toLowerCase();
    } else {
      final lat = latitude;
      final lon = longitude;
      if (lat == null || lon == null) {
        throw StateError('Latitude and longitude are required');
      }
      params['lat'] = lat.toStringAsFixed(4);
      params['lon'] = lon.toStringAsFixed(4);
    }

    return HashUtil.generateCacheHash(params);
  }

  /// Convert to query parameters
  Map<String, dynamic> toQueryParams() {
    final cityName = city;
    final params = <String, dynamic>{
      'temperature_unit': temperatureUnit,
      'wind_speed_unit': windSpeedUnit,
      'precipitation_unit': precipitationUnit,
      'timezone': timezone,
      'forecast_days': forecastDays,
      'past_days': pastDays,
      'hash': generateHash(),
    };

    if (cityName != null && cityName.isNotEmpty) {
      params['city'] = cityName;
    } else {
      final lat = latitude;
      final lon = longitude;
      if (lat == null || lon == null) {
        throw StateError('Latitude and longitude are required');
      }
      params['lat'] = lat;
      params['lon'] = lon;
    }

    return params;
  }
}

/// Historical weather request DTO (for Open-Meteo Archive API)
class HistoricalWeatherRequestDto {
  final double? latitude;
  final double? longitude;
  final String? city;
  final String startDate; // YYYY-MM-DD
  final String endDate; // YYYY-MM-DD
  final String temperatureUnit;
  final String windSpeedUnit;
  final String precipitationUnit;
  final String timezone;

  HistoricalWeatherRequestDto({
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
              ((city ?? '').isNotEmpty),
          'Either latitude/longitude or city must be provided',
        );

  /// Generate cache hash for this request
  String generateHash() {
    final cityName = city;
    final params = {
      'endpoint': 'historical',
      'start_date': startDate,
      'end_date': endDate,
      'temperature_unit': temperatureUnit,
      'wind_speed_unit': windSpeedUnit,
      'precipitation_unit': precipitationUnit,
      'timezone': timezone,
    };

    if (cityName != null && cityName.isNotEmpty) {
      params['city'] = cityName.toLowerCase();
    } else {
      final lat = latitude;
      final lon = longitude;
      if (lat == null || lon == null) {
        throw StateError('Latitude and longitude are required');
      }
      params['lat'] = lat.toStringAsFixed(4);
      params['lon'] = lon.toStringAsFixed(4);
    }

    return HashUtil.generateCacheHash(params);
  }

  /// Convert to query parameters
  Map<String, dynamic> toQueryParams() {
    final cityName = city;
    final params = <String, dynamic>{
      'start_date': startDate,
      'end_date': endDate,
      'temperature_unit': temperatureUnit,
      'wind_speed_unit': windSpeedUnit,
      'precipitation_unit': precipitationUnit,
      'timezone': timezone,
      'hash': generateHash(),
    };

    if (cityName != null && cityName.isNotEmpty) {
      params['city'] = cityName;
    } else {
      final lat = latitude;
      final lon = longitude;
      if (lat == null || lon == null) {
        throw StateError('Latitude and longitude are required');
      }
      params['lat'] = lat;
      params['lon'] = lon;
    }

    return params;
  }
}
