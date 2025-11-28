import 'package:equatable/equatable.dart';

/// Weather condition entity (simplified for Open-Meteo)
class WeatherCondition extends Equatable {
  final int code; // WMO weather code
  final String description;
  final String icon;

  const WeatherCondition({
    required this.code,
    required this.description,
    required this.icon,
  });

  @override
  List<Object?> get props => [code, description, icon];
}

/// Current weather entity
class CurrentWeather extends Equatable {
  final DateTime time;
  final double temperature;
  final double apparentTemperature;
  final int relativeHumidity;
  final bool isDay;
  final double precipitation;
  final double rain;
  final double showers;
  final double snowfall;
  final int weatherCode;
  final int cloudCover;
  final double pressureMsl;
  final double surfacePressure;
  final double windSpeed;
  final int windDirection;
  final double windGusts;
  final WeatherCondition condition;

  const CurrentWeather({
    required this.time,
    required this.temperature,
    required this.apparentTemperature,
    required this.relativeHumidity,
    required this.isDay,
    required this.precipitation,
    required this.rain,
    required this.showers,
    required this.snowfall,
    required this.weatherCode,
    required this.cloudCover,
    required this.pressureMsl,
    required this.surfacePressure,
    required this.windSpeed,
    required this.windDirection,
    required this.windGusts,
    required this.condition,
  });

  @override
  List<Object?> get props => [
    time,
    temperature,
    apparentTemperature,
    relativeHumidity,
    isDay,
    precipitation,
    rain,
    showers,
    snowfall,
    weatherCode,
    cloudCover,
    pressureMsl,
    surfacePressure,
    windSpeed,
    windDirection,
    windGusts,
    condition,
  ];
}

/// Hourly forecast entity
class HourlyWeather extends Equatable {
  final DateTime time;
  final double temperature;
  final double apparentTemperature;
  final int relativeHumidity;
  final int precipitationProbability;
  final double precipitation;
  final double rain;
  final double showers;
  final double snowfall;
  final int weatherCode;
  final double pressureMsl;
  final double surfacePressure;
  final int cloudCover;
  final double visibility;
  final double windSpeed;
  final int windDirection;
  final double windGusts;
  final WeatherCondition condition;

  const HourlyWeather({
    required this.time,
    required this.temperature,
    required this.apparentTemperature,
    required this.relativeHumidity,
    required this.precipitationProbability,
    required this.precipitation,
    required this.rain,
    required this.showers,
    required this.snowfall,
    required this.weatherCode,
    required this.pressureMsl,
    required this.surfacePressure,
    required this.cloudCover,
    required this.visibility,
    required this.windSpeed,
    required this.windDirection,
    required this.windGusts,
    required this.condition,
  });

  @override
  List<Object?> get props => [
    time,
    temperature,
    apparentTemperature,
    relativeHumidity,
    precipitationProbability,
    precipitation,
    rain,
    showers,
    snowfall,
    weatherCode,
    pressureMsl,
    surfacePressure,
    cloudCover,
    visibility,
    windSpeed,
    windDirection,
    windGusts,
    condition,
  ];
}

/// Daily forecast entity
class DailyWeather extends Equatable {
  final DateTime date;
  final int weatherCode;
  final double temperatureMax;
  final double temperatureMin;
  final double apparentTemperatureMax;
  final double apparentTemperatureMin;
  final String sunrise;
  final String sunset;
  final double uvIndexMax;
  final double precipitationSum;
  final double rainSum;
  final double showersSum;
  final double snowfallSum;
  final double precipitationHours;
  final int precipitationProbabilityMax;
  final double windSpeedMax;
  final double windGustsMax;
  final int windDirectionDominant;
  final WeatherCondition condition;

  const DailyWeather({
    required this.date,
    required this.weatherCode,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.apparentTemperatureMax,
    required this.apparentTemperatureMin,
    required this.sunrise,
    required this.sunset,
    required this.uvIndexMax,
    required this.precipitationSum,
    required this.rainSum,
    required this.showersSum,
    required this.snowfallSum,
    required this.precipitationHours,
    required this.precipitationProbabilityMax,
    required this.windSpeedMax,
    required this.windGustsMax,
    required this.windDirectionDominant,
    required this.condition,
  });

  @override
  List<Object?> get props => [
    date,
    weatherCode,
    temperatureMax,
    temperatureMin,
    apparentTemperatureMax,
    apparentTemperatureMin,
    sunrise,
    sunset,
    uvIndexMax,
    precipitationSum,
    rainSum,
    showersSum,
    snowfallSum,
    precipitationHours,
    precipitationProbabilityMax,
    windSpeedMax,
    windGustsMax,
    windDirectionDominant,
    condition,
  ];
}

/// Location entity
class Location extends Equatable {
  final double latitude;
  final double longitude;
  final double elevation;
  final String timezone;
  final String timezoneAbbreviation;
  final String? name;
  final String? displayName;
  final String? country;
  final String? state;
  final String? county;
  final String? source;

  const Location({
    required this.latitude,
    required this.longitude,
    required this.elevation,
    required this.timezone,
    required this.timezoneAbbreviation,
    this.name,
    this.displayName,
    this.country,
    this.state,
    this.county,
    this.source,
  });

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    elevation,
    timezone,
    timezoneAbbreviation,
    name,
    displayName,
    country,
    state,
    county,
    source,
  ];
}

/// Complete weather forecast data entity
class WeatherForecast extends Equatable {
  final Location location;
  final CurrentWeather? current;
  final List<HourlyWeather>? hourly;
  final List<DailyWeather>? daily;

  const WeatherForecast({
    required this.location,
    this.current,
    this.hourly,
    this.daily,
  });

  @override
  List<Object?> get props => [location, current, hourly, daily];
}
