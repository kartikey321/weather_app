import 'package:flutter/material.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_animations.dart';

/// Helper class to determine weather animation based on WMO weather code
class WeatherAnimationHelper {
  /// Get weather animation widget based on WMO weather code
  static Widget? getAnimationForWeatherCode(int weatherCode) {
    // WMO Weather interpretation codes (WW)
    // 0: Clear sky
    // 1-3: Mainly clear, partly cloudy, overcast
    // 45, 48: Fog
    // 51-55: Drizzle
    // 56-57: Freezing drizzle
    // 61-65: Rain
    // 66-67: Freezing rain
    // 71-75: Snow fall
    // 77: Snow grains
    // 80-82: Rain showers
    // 85-86: Snow showers
    // 95: Thunderstorm
    // 96, 99: Thunderstorm with hail

    if (weatherCode == 0) {
      // Clear sky - sun rays
      return const SunRaysAnimation();
    } else if (weatherCode >= 1 && weatherCode <= 3) {
      // Partly cloudy - clouds
      return const CloudsAnimation(cloudCount: 3);
    } else if (weatherCode >= 45 && weatherCode <= 48) {
      // Fog - dense clouds
      return const CloudsAnimation(cloudCount: 8);
    } else if (weatherCode >= 51 && weatherCode <= 57) {
      // Drizzle - light rain
      return const RainAnimation(dropCount: 30);
    } else if (weatherCode >= 61 && weatherCode <= 67) {
      // Rain - moderate to heavy rain
      return const RainAnimation(dropCount: 60);
    } else if (weatherCode >= 71 && weatherCode <= 77) {
      // Snow - snow animation
      return const SnowAnimation(flakeCount: 40);
    } else if (weatherCode >= 80 && weatherCode <= 82) {
      // Rain showers - heavy rain
      return const RainAnimation(dropCount: 80);
    } else if (weatherCode >= 85 && weatherCode <= 86) {
      // Snow showers - heavy snow
      return const SnowAnimation(flakeCount: 60);
    } else if (weatherCode >= 95 && weatherCode <= 99) {
      // Thunderstorm - heavy rain with clouds
      return const Stack(
        children: [
          CloudsAnimation(cloudCount: 6),
          RainAnimation(dropCount: 100),
        ],
      );
    }

    // Default - clouds for other codes
    return const CloudsAnimation(cloudCount: 4);
  }

  /// Get gradient colors based on weather code
  static List<Color> getGradientColors(int weatherCode, bool isDaytime) {
    if (weatherCode == 0) {
      // Clear sky
      return isDaytime
          ? [const Color(0xFF87CEEB), const Color(0xFF4A90E2)]
          : [const Color(0xFF0F2027), const Color(0xFF203A43)];
    } else if (weatherCode >= 1 && weatherCode <= 3) {
      // Partly cloudy
      return isDaytime
          ? [const Color(0xFF6DB3F2), const Color(0xFF54A0E2)]
          : [const Color(0xFF1C3642), const Color(0xFF2C5364)];
    } else if (weatherCode >= 51 && weatherCode <= 82) {
      // Rainy
      return isDaytime
          ? [const Color(0xFF536976), const Color(0xFF292E49)]
          : [const Color(0xFF232526), const Color(0xFF414345)];
    } else if (weatherCode >= 71 && weatherCode <= 86) {
      // Snowy
      return isDaytime
          ? [const Color(0xFFE6DADA), const Color(0xFF9FA8DA)]
          : [const Color(0xFF304352), const Color(0xFF304352)];
    } else if (weatherCode >= 95 && weatherCode <= 99) {
      // Thunderstorm
      return [const Color(0xFF373B44), const Color(0xFF4286F4)];
    }

    // Default cloudy
    return isDaytime
        ? [const Color(0xFF7F8C99), const Color(0xFF52616B)]
        : [const Color(0xFF2C3E50), const Color(0xFF34495E)];
  }

  /// Determine if it's daytime based on current hour
  static bool isDaytime() {
    final hour = DateTime.now().hour;
    return hour >= 6 && hour < 18;
  }
}
