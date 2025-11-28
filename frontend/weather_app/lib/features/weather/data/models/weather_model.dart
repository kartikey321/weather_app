import 'package:weather_app/features/weather/data/models/wmo_weather_codes.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';

/// Weather condition model
class WeatherConditionModel extends WeatherCondition {
  const WeatherConditionModel({
    required super.code,
    required super.description,
    required super.icon,
  });

  factory WeatherConditionModel.fromWMOCode(int code, {bool isDay = true}) {
    return WeatherConditionModel(
      code: code,
      description: WMOWeatherCodes.getDescription(code),
      icon: WMOWeatherCodes.getIcon(code, isDay: isDay),
    );
  }
}

/// Current weather model
class CurrentWeatherModel extends CurrentWeather {
  const CurrentWeatherModel({
    required super.time,
    required super.temperature,
    required super.apparentTemperature,
    required super.relativeHumidity,
    required super.isDay,
    required super.precipitation,
    required super.rain,
    required super.showers,
    required super.snowfall,
    required super.weatherCode,
    required super.cloudCover,
    required super.pressureMsl,
    required super.surfacePressure,
    required super.windSpeed,
    required super.windDirection,
    required super.windGusts,
    required super.condition,
  });

  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    final weatherCode = json['weather_code'] as int;
    final isDay = (json['is_day'] as int) == 1;

    return CurrentWeatherModel(
      time: DateTime.parse(json['time'] as String),
      temperature: (json['temperature_2m'] as num).toDouble(),
      apparentTemperature: (json['apparent_temperature'] as num).toDouble(),
      relativeHumidity: json['relative_humidity_2m'] as int,
      isDay: isDay,
      precipitation: (json['precipitation'] as num).toDouble(),
      rain: (json['rain'] as num).toDouble(),
      showers: (json['showers'] as num).toDouble(),
      snowfall: (json['snowfall'] as num).toDouble(),
      weatherCode: weatherCode,
      cloudCover: json['cloud_cover'] as int,
      pressureMsl: (json['pressure_msl'] as num).toDouble(),
      surfacePressure: (json['surface_pressure'] as num).toDouble(),
      windSpeed: (json['wind_speed_10m'] as num).toDouble(),
      windDirection: json['wind_direction_10m'] as int,
      windGusts: (json['wind_gusts_10m'] as num).toDouble(),
      condition: WeatherConditionModel.fromWMOCode(weatherCode, isDay: isDay),
    );
  }
}

/// Hourly weather model
class HourlyWeatherModel extends HourlyWeather {
  const HourlyWeatherModel({
    required super.time,
    required super.temperature,
    required super.apparentTemperature,
    required super.relativeHumidity,
    required super.precipitationProbability,
    required super.precipitation,
    required super.rain,
    required super.showers,
    required super.snowfall,
    required super.weatherCode,
    required super.pressureMsl,
    required super.surfacePressure,
    required super.cloudCover,
    required super.visibility,
    required super.windSpeed,
    required super.windDirection,
    required super.windGusts,
    required super.condition,
  });

  /// Parse hourly data from Open-Meteo's array-based response
  static List<HourlyWeatherModel> fromJsonArrays(Map<String, dynamic> json) {
    final times = (json['time'] as List).cast<String>();
    final temperatures = (json['temperature_2m'] as List).cast<num>();
    final apparentTemps = (json['apparent_temperature'] as List).cast<num>();
    final humidity = (json['relative_humidity_2m'] as List).cast<int>();
    final precipProb = (json['precipitation_probability'] as List).cast<int>();
    final precip = (json['precipitation'] as List).cast<num>();
    final rain = (json['rain'] as List).cast<num>();
    final showers = (json['showers'] as List).cast<num>();
    final snowfall = (json['snowfall'] as List).cast<num>();
    final weatherCodes = (json['weather_code'] as List).cast<int>();
    final pressure = (json['pressure_msl'] as List).cast<num>();
    final surfacePressure = (json['surface_pressure'] as List).cast<num>();
    final cloudCover = (json['cloud_cover'] as List).cast<int>();
    final visibility = (json['visibility'] as List).cast<num>();
    final windSpeed = (json['wind_speed_10m'] as List).cast<num>();
    final windDirection = (json['wind_direction_10m'] as List).cast<int>();
    final windGusts = (json['wind_gusts_10m'] as List).cast<num>();

    final List<HourlyWeatherModel> hourlyData = [];

    for (int i = 0; i < times.length; i++) {
      final time = DateTime.parse(times[i]);
      final hour = time.hour;
      final isDay = hour >= 6 && hour < 20; // Simple day/night logic

      hourlyData.add(
        HourlyWeatherModel(
          time: time,
          temperature: temperatures[i].toDouble(),
          apparentTemperature: apparentTemps[i].toDouble(),
          relativeHumidity: humidity[i],
          precipitationProbability: precipProb[i],
          precipitation: precip[i].toDouble(),
          rain: rain[i].toDouble(),
          showers: showers[i].toDouble(),
          snowfall: snowfall[i].toDouble(),
          weatherCode: weatherCodes[i],
          pressureMsl: pressure[i].toDouble(),
          surfacePressure: surfacePressure[i].toDouble(),
          cloudCover: cloudCover[i],
          visibility: visibility[i].toDouble(),
          windSpeed: windSpeed[i].toDouble(),
          windDirection: windDirection[i],
          windGusts: windGusts[i].toDouble(),
          condition: WeatherConditionModel.fromWMOCode(
            weatherCodes[i],
            isDay: isDay,
          ),
        ),
      );
    }

    return hourlyData;
  }
}

/// Daily weather model
class DailyWeatherModel extends DailyWeather {
  const DailyWeatherModel({
    required super.date,
    required super.weatherCode,
    required super.temperatureMax,
    required super.temperatureMin,
    required super.apparentTemperatureMax,
    required super.apparentTemperatureMin,
    required super.sunrise,
    required super.sunset,
    required super.uvIndexMax,
    required super.precipitationSum,
    required super.rainSum,
    required super.showersSum,
    required super.snowfallSum,
    required super.precipitationHours,
    required super.precipitationProbabilityMax,
    required super.windSpeedMax,
    required super.windGustsMax,
    required super.windDirectionDominant,
    required super.condition,
  });

  /// Parse daily data from Open-Meteo's array-based response
  static List<DailyWeatherModel> fromJsonArrays(Map<String, dynamic> json) {
    final times = (json['time'] as List).cast<String>();
    final weatherCodes = (json['weather_code'] as List).cast<int>();
    final tempMax = (json['temperature_2m_max'] as List).cast<num>();
    final tempMin = (json['temperature_2m_min'] as List).cast<num>();
    final apparentTempMax = (json['apparent_temperature_max'] as List)
        .cast<num>();
    final apparentTempMin = (json['apparent_temperature_min'] as List)
        .cast<num>();
    final sunrise = (json['sunrise'] as List).cast<String>();
    final sunset = (json['sunset'] as List).cast<String>();
    final uvIndexMax = (json['uv_index_max'] as List).cast<num>();
    final precipSum = (json['precipitation_sum'] as List).cast<num>();
    final rainSum = (json['rain_sum'] as List).cast<num>();
    final showersSum = (json['showers_sum'] as List).cast<num>();
    final snowfallSum = (json['snowfall_sum'] as List).cast<num>();
    final precipHours = (json['precipitation_hours'] as List).cast<num>();
    final precipProbMax = (json['precipitation_probability_max'] as List)
        .cast<int>();
    final windSpeedMax = (json['wind_speed_10m_max'] as List).cast<num>();
    final windGustsMax = (json['wind_gusts_10m_max'] as List).cast<num>();
    final windDirDominant = (json['wind_direction_10m_dominant'] as List)
        .cast<int>();

    final List<DailyWeatherModel> dailyData = [];

    for (int i = 0; i < times.length; i++) {
      dailyData.add(
        DailyWeatherModel(
          date: DateTime.parse(times[i]),
          weatherCode: weatherCodes[i],
          temperatureMax: tempMax[i].toDouble(),
          temperatureMin: tempMin[i].toDouble(),
          apparentTemperatureMax: apparentTempMax[i].toDouble(),
          apparentTemperatureMin: apparentTempMin[i].toDouble(),
          sunrise: sunrise[i],
          sunset: sunset[i],
          uvIndexMax: uvIndexMax[i].toDouble(),
          precipitationSum: precipSum[i].toDouble(),
          rainSum: rainSum[i].toDouble(),
          showersSum: showersSum[i].toDouble(),
          snowfallSum: snowfallSum[i].toDouble(),
          precipitationHours: precipHours[i].toDouble(),
          precipitationProbabilityMax: precipProbMax[i],
          windSpeedMax: windSpeedMax[i].toDouble(),
          windGustsMax: windGustsMax[i].toDouble(),
          windDirectionDominant: windDirDominant[i],
          condition: WeatherConditionModel.fromWMOCode(weatherCodes[i]),
        ),
      );
    }

    return dailyData;
  }
}

/// Location model
class LocationModel extends Location {
  const LocationModel({
    required super.latitude,
    required super.longitude,
    required super.elevation,
    required super.timezone,
    required super.timezoneAbbreviation,
    super.name,
    super.displayName,
    super.country,
    super.state,
    super.county,
    super.source,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    final meta = json['location'] as Map<String, dynamic>?;
    final displayName = meta != null
        ? (meta['displayName'] as String? ?? meta['display_name'] as String?)
        : null;

    return LocationModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      elevation: (json['elevation'] as num).toDouble(),
      timezone: json['timezone'] as String,
      timezoneAbbreviation: json['timezone_abbreviation'] as String,
      name: meta?['name'] as String?,
      displayName: displayName,
      country: meta?['country'] as String?,
      state: meta?['state'] as String?,
      county: meta?['county'] as String?,
      source: meta?['source'] as String?,
    );
  }
}

/// Weather forecast model
class WeatherForecastModel extends WeatherForecast {
  const WeatherForecastModel({
    required super.location,
    super.current,
    super.hourly,
    super.daily,
  });

  factory WeatherForecastModel.fromJson(Map<String, dynamic> json) {
    return WeatherForecastModel(
      location: LocationModel.fromJson(json),
      current: json['current'] != null
          ? CurrentWeatherModel.fromJson(
              json['current'] as Map<String, dynamic>,
            )
          : null,
      hourly: json['hourly'] != null
          ? HourlyWeatherModel.fromJsonArrays(
              json['hourly'] as Map<String, dynamic>,
            )
          : null,
      daily: json['daily'] != null
          ? DailyWeatherModel.fromJsonArrays(
              json['daily'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}
