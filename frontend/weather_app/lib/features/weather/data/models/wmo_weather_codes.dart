/// WMO Weather Interpretation Codes
/// Based on WMO standard used by Open-Meteo API
class WMOWeatherCodes {
  static const Map<int, String> descriptions = {
    0: 'Clear sky',
    1: 'Mainly clear',
    2: 'Partly cloudy',
    3: 'Overcast',
    45: 'Fog',
    48: 'Depositing rime fog',
    51: 'Light drizzle',
    53: 'Moderate drizzle',
    55: 'Dense drizzle',
    56: 'Light freezing drizzle',
    57: 'Dense freezing drizzle',
    61: 'Slight rain',
    63: 'Moderate rain',
    65: 'Heavy rain',
    66: 'Light freezing rain',
    67: 'Heavy freezing rain',
    71: 'Slight snow fall',
    73: 'Moderate snow fall',
    75: 'Heavy snow fall',
    77: 'Snow grains',
    80: 'Slight rain showers',
    81: 'Moderate rain showers',
    82: 'Violent rain showers',
    85: 'Slight snow showers',
    86: 'Heavy snow showers',
    95: 'Thunderstorm',
    96: 'Thunderstorm with slight hail',
    99: 'Thunderstorm with heavy hail',
  };

  /// Map WMO codes to weather icon names
  /// You can customize these to match your icon set
  static const Map<int, String> icons = {
    0: 'clear_day',
    1: 'mostly_clear_day',
    2: 'partly_cloudy_day',
    3: 'cloudy',
    45: 'fog',
    48: 'fog',
    51: 'drizzle',
    53: 'drizzle',
    55: 'drizzle',
    56: 'freezing_drizzle',
    57: 'freezing_drizzle',
    61: 'rain',
    63: 'rain',
    65: 'heavy_rain',
    66: 'freezing_rain',
    67: 'freezing_rain',
    71: 'snow',
    73: 'snow',
    75: 'heavy_snow',
    77: 'snow',
    80: 'rain_showers',
    81: 'rain_showers',
    82: 'heavy_rain_showers',
    85: 'snow_showers',
    86: 'heavy_snow_showers',
    95: 'thunderstorm',
    96: 'thunderstorm_hail',
    99: 'thunderstorm_hail',
  };

  static String getDescription(int code) {
    return descriptions[code] ?? 'Unknown';
  }

  static String getIcon(int code, {bool isDay = true}) {
    String baseIcon = icons[code] ?? 'unknown';

    // Adjust icon for night time if it's a clear/partly cloudy condition
    if (!isDay && [0, 1, 2].contains(code)) {
      baseIcon = baseIcon.replaceAll('_day', '_night');
    }

    return baseIcon;
  }
}
