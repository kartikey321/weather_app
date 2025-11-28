import 'package:dartz/dartz.dart';
import 'package:weather_app/core/errors/exceptions.dart';
import 'package:weather_app/core/errors/failures.dart';
import 'package:weather_app/core/network/network_info.dart';
import 'package:weather_app/features/weather/data/datasources/weather_local_data_source.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weather_app/features/weather/data/models/weather_request_dto.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';

/// Implementation of WeatherRepository (Open-Meteo API)
class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  /// Cache validity duration (10 minutes - Open-Meteo updates frequently)
  static const Duration cacheValidity = Duration(minutes: 10);

  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  /// Generate location key for caching
  String _getLocationKey({double? latitude, double? longitude, String? city}) {
    if (city != null && city.isNotEmpty) {
      return 'city_${city.toLowerCase()}';
    }

    if (latitude != null && longitude != null) {
      return 'coords_${latitude.toStringAsFixed(4)}_${longitude.toStringAsFixed(4)}';
    }

    throw ArgumentError('Either coordinates or city must be provided');
  }

  /// Check if cached data is still valid
  Future<bool> _isCacheValid(String locationKey) async {
    try {
      final lastUpdated = await localDataSource.getLastUpdated(locationKey);
      if (lastUpdated == null) return false;

      final now = DateTime.now();
      final difference = now.difference(lastUpdated);
      return difference < cacheValidity;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either<Failure, WeatherForecast>> getForecast({
    double? latitude,
    double? longitude,
    String? city,
    String temperatureUnit = 'celsius',
    String windSpeedUnit = 'kmh',
    String precipitationUnit = 'mm',
    String timezone = 'auto',
    int forecastDays = 7,
    int pastDays = 0,
    bool forceRefresh = false,
  }) async {
    if ((latitude == null || longitude == null) &&
        (city == null || city.isEmpty)) {
      return Left(
        const ValidationFailure(
          'Please provide either coordinates or a city name for weather data',
        ),
      );
    }

    final locationKey = _getLocationKey(
      latitude: latitude,
      longitude: longitude,
      city: city,
    );

    // Try to get from cache if not forcing refresh
    if (!forceRefresh && await _isCacheValid(locationKey)) {
      try {
        final cachedWeather = await localDataSource.getCachedWeather(
          locationKey,
        );
        if (cachedWeather != null) {
          return Right(cachedWeather);
        }
      } catch (e) {
        // Continue to fetch from remote if cache fails
      }
    }

    // Check network connectivity
    if (!await networkInfo.isConnected) {
      // Try to return cached data even if expired
      try {
        final cachedWeather = await localDataSource.getCachedWeather(
          locationKey,
        );
        if (cachedWeather != null) {
          return Right(cachedWeather);
        }
      } catch (e) {
        return Left(
          NetworkFailure('No internet connection and no cached data'),
        );
      }
      return Left(NetworkFailure('No internet connection'));
    }

    // Fetch from remote
    try {
      final request = WeatherForecastRequestDto(
        latitude: latitude,
        longitude: longitude,
        city: city,
        temperatureUnit: temperatureUnit,
        windSpeedUnit: windSpeedUnit,
        precipitationUnit: precipitationUnit,
        timezone: timezone,
        forecastDays: forecastDays,
        pastDays: pastDays,
      );

      final response = await remoteDataSource.getForecast(request);

      if (response.success && response.data != null) {
        final weatherData = response.data!;

        // Cache the data
        try {
          await localDataSource.cacheWeather(locationKey, weatherData);

          // Also cache by resolved coordinates if available and city-based request
          if (city != null) {
            final resolvedKey = _getLocationKey(
              latitude: weatherData.location.latitude,
              longitude: weatherData.location.longitude,
            );
            await localDataSource.cacheWeather(resolvedKey, weatherData);
          }
        } catch (e) {
          // Continue even if caching fails
        }

        return Right(weatherData);
      } else {
        return Left(
          ServerFailure(response.message ?? 'Failed to fetch weather'),
        );
      }
    } on RateLimitException catch (e) {
      return Left(RateLimitFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, WeatherForecast>> getHistoricalWeather({
    double? latitude,
    double? longitude,
    String? city,
    required String startDate,
    required String endDate,
    String temperatureUnit = 'celsius',
    String windSpeedUnit = 'kmh',
    String precipitationUnit = 'mm',
    String timezone = 'auto',
  }) async {
    // Check network connectivity
    if ((latitude == null || longitude == null) &&
        (city == null || city.isEmpty)) {
      return Left(
        const ValidationFailure(
          'Please provide coordinates or a city name for historical data',
        ),
      );
    }

    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final request = HistoricalWeatherRequestDto(
        latitude: latitude,
        longitude: longitude,
        city: city,
        startDate: startDate,
        endDate: endDate,
        temperatureUnit: temperatureUnit,
        windSpeedUnit: windSpeedUnit,
        precipitationUnit: precipitationUnit,
        timezone: timezone,
      );

      final response = await remoteDataSource.getHistoricalWeather(request);

      if (response.success && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(
          ServerFailure(
            response.message ?? 'Failed to fetch historical weather',
          ),
        );
      }
    } on RateLimitException catch (e) {
      return Left(RateLimitFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }
}
