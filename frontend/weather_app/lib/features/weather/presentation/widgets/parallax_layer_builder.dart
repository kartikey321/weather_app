import 'package:flutter/material.dart';
import 'package:weather_app/features/weather/presentation/widgets/multi_layer_parallax.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_layers.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_particles.dart';

/// Helper class to build weather-appropriate parallax layers
class ParallaxLayerBuilder {
  /// Build parallax layers based on weather conditions
  static List<ParallaxLayer> buildWeatherLayers({
    required int weatherCode,
    required bool isDaytime,
  }) {
    final layers = <ParallaxLayer>[];

    // Background celestial bodies (slowest - furthest away)
    if (isDaytime) {
      // Add sun during day
      layers.add(
        const ParallaxLayer(
          speed: 0.05,
          alignment: Alignment.topCenter,
          child: SunLayer(
            size: 150,
            color: Color(0xFFFFEB3B), // Brighter yellow
          ),
        ),
      );
    } else {
      // Add moon and stars at night
      layers.add(
        const ParallaxLayer(
          speed: 0.03,
          alignment: Alignment.topCenter,
          child: StarsLayer(starCount: 100), // More stars
        ),
      );
      layers.add(
        const ParallaxLayer(
          speed: 0.05,
          alignment: Alignment.topCenter,
          child: MoonLayer(
            size: 120,
            color: Color(0xFFFAFAFA), // Brighter moon
          ),
        ),
      );
    }

    // Cloud layers (medium speed - middle distance)
    if (_shouldShowClouds(weatherCode)) {
      // Background clouds (slower)
      layers.add(
        ParallaxLayer(
          speed: 0.15,
          alignment: Alignment.topCenter,
          child: CloudsLayer(
            cloudCount: _getCloudCount(weatherCode),
            opacity: _getCloudOpacity(weatherCode) * 1.8, // Increased opacity
          ),
        ),
      );

      // Foreground clouds (faster)
      layers.add(
        ParallaxLayer(
          speed: 0.25,
          alignment: Alignment.topCenter,
          child: CloudsLayer(
            cloudCount: (_getCloudCount(weatherCode) * 0.6).round(),
            opacity: _getCloudOpacity(weatherCode) * 1.5, // Increased opacity
          ),
        ),
      );
    }

    // Weather particles (fastest - closest to viewer)
    final particleLayers = _buildParticleLayers(weatherCode);
    layers.addAll(particleLayers);

    return layers;
  }

  /// Determine if clouds should be shown for the given weather code
  static bool _shouldShowClouds(int weatherCode) {
    // Show clouds for:
    // - Partly cloudy (2)
    // - Overcast (3)
    // - Fog (45, 48)
    // - All rain conditions
    // - All snow conditions
    // Don't show for clear skies (0, 1)
    return weatherCode >= 2;
  }

  /// Get cloud count based on weather intensity
  static int _getCloudCount(int weatherCode) {
    if (weatherCode <= 1) return 0; // Clear
    if (weatherCode == 2) return 3; // Partly cloudy
    if (weatherCode == 3) return 6; // Overcast
    if (weatherCode >= 45 && weatherCode <= 48) return 8; // Fog
    return 5; // Default for other conditions
  }

  /// Get cloud opacity based on weather type
  static double _getCloudOpacity(int weatherCode) {
    if (weatherCode == 2) return 0.25; // Partly cloudy - light
    if (weatherCode == 3) return 0.4; // Overcast - heavier
    if (weatherCode >= 45 && weatherCode <= 48) return 0.5; // Fog - very heavy
    return 0.35; // Default
  }

  /// Build particle layers for precipitation effects
  static List<ParallaxLayer> _buildParticleLayers(int weatherCode) {
    final layers = <ParallaxLayer>[];

    // Drizzle (51, 53, 55)
    if (weatherCode >= 51 && weatherCode <= 55) {
      layers.add(
        const ParallaxLayer(
          speed: 0.3,
          child: DrizzleParticlesLayer(particleCount: 60),
        ),
      );
    }

    // Rain (61, 63, 65) - Light, moderate, heavy
    if (weatherCode >= 61 && weatherCode <= 65) {
      final intensity = _getRainIntensity(weatherCode);

      // Background rain layer (slower)
      layers.add(
        ParallaxLayer(
          speed: 0.35,
          child: RainParticlesLayer(
            particleCount: 60,
            intensity: intensity * 0.6,
          ),
        ),
      );

      // Foreground rain layer (faster)
      layers.add(
        ParallaxLayer(
          speed: 0.5,
          child: RainParticlesLayer(
            particleCount: 80,
            intensity: intensity,
          ),
        ),
      );
    }

    // Freezing rain (66, 67)
    if (weatherCode == 66 || weatherCode == 67) {
      layers.add(
        const ParallaxLayer(
          speed: 0.4,
          child: RainParticlesLayer(
            particleCount: 70,
            intensity: 0.7,
            color: Color(0xFFB3E5FC),
          ),
        ),
      );
    }

    // Snow (71, 73, 75, 77) - Light, moderate, heavy, grains
    if (weatherCode >= 71 && weatherCode <= 77) {
      final intensity = _getSnowIntensity(weatherCode);

      // Background snow layer (slower, smaller flakes)
      layers.add(
        ParallaxLayer(
          speed: 0.25,
          child: SnowParticlesLayer(
            particleCount: 50,
            intensity: intensity * 0.7,
          ),
        ),
      );

      // Foreground snow layer (faster, larger flakes)
      layers.add(
        ParallaxLayer(
          speed: 0.4,
          child: SnowParticlesLayer(
            particleCount: 60,
            intensity: intensity,
          ),
        ),
      );
    }

    // Rain showers (80, 81, 82) - Light, moderate, violent
    if (weatherCode >= 80 && weatherCode <= 82) {
      final intensity = weatherCode == 80 ? 0.6 : (weatherCode == 81 ? 0.8 : 1.0);
      layers.add(
        ParallaxLayer(
          speed: 0.5,
          child: RainParticlesLayer(
            particleCount: 100,
            intensity: intensity,
          ),
        ),
      );
    }

    // Snow showers (85, 86)
    if (weatherCode == 85 || weatherCode == 86) {
      final intensity = weatherCode == 85 ? 0.7 : 1.0;
      layers.add(
        ParallaxLayer(
          speed: 0.4,
          child: SnowParticlesLayer(
            particleCount: 70,
            intensity: intensity,
          ),
        ),
      );
    }

    // Thunderstorm (95, 96, 99)
    if (weatherCode >= 95) {
      layers.add(
        const ParallaxLayer(
          speed: 0.55,
          child: RainParticlesLayer(
            particleCount: 120,
            intensity: 1.0,
          ),
        ),
      );
    }

    return layers;
  }

  /// Get rain intensity based on weather code
  static double _getRainIntensity(int weatherCode) {
    if (weatherCode == 61) return 0.5; // Light rain
    if (weatherCode == 63) return 0.75; // Moderate rain
    if (weatherCode == 65) return 1.0; // Heavy rain
    return 0.7; // Default
  }

  /// Get snow intensity based on weather code
  static double _getSnowIntensity(int weatherCode) {
    if (weatherCode == 71) return 0.5; // Light snow
    if (weatherCode == 73) return 0.75; // Moderate snow
    if (weatherCode == 75) return 1.0; // Heavy snow
    if (weatherCode == 77) return 0.6; // Snow grains
    return 0.7; // Default
  }
}
