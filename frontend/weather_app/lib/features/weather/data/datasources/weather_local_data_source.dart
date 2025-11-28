import 'package:hive/hive.dart';
import 'package:weather_app/core/constants/storage_keys.dart';
import 'package:weather_app/core/errors/exceptions.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';

/// Local data source for weather (Open-Meteo)
abstract class WeatherLocalDataSource {
  /// Get cached weather data by location
  Future<WeatherForecastModel?> getCachedWeather(String locationKey);

  /// Cache weather data
  Future<void> cacheWeather(String locationKey, WeatherForecastModel weather);

  /// Clear all cached weather data
  Future<void> clearCache();

  /// Get last updated timestamp
  Future<DateTime?> getLastUpdated(String locationKey);
}

/// Implementation of WeatherLocalDataSource
class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  static const String _timestampPrefix = 'timestamp_';

  @override
  Future<WeatherForecastModel?> getCachedWeather(String locationKey) async {
    // TODO: Implement proper caching with toJson/fromJson for WeatherForecastModel
    // For now, return null to always fetch fresh data
    return null;
  }

  @override
  Future<void> cacheWeather(String locationKey, WeatherForecastModel weather) async {
    // TODO: Implement proper caching with toJson for WeatherForecastModel
    // For now, caching is disabled
    try {
      final box = await Hive.openBox(StorageKeys.weatherBox);
      await box.put(
        '$_timestampPrefix$locationKey',
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      // Silently fail - caching is not critical
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final box = await Hive.openBox(StorageKeys.weatherBox);
      await box.clear();
    } catch (e) {
      throw CacheException('Failed to clear cache: ${e.toString()}');
    }
  }

  @override
  Future<DateTime?> getLastUpdated(String locationKey) async {
    try {
      final box = await Hive.openBox(StorageKeys.weatherBox);
      final timestampStr = box.get('$_timestampPrefix$locationKey') as String?;

      if (timestampStr != null && timestampStr.isNotEmpty) {
        return DateTime.parse(timestampStr);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get last updated: ${e.toString()}');
    }
  }
}
