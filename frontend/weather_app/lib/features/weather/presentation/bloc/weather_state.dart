import 'package:equatable/equatable.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';

/// Base class for all weather states
abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

/// Loading state
class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

/// Loaded state
class WeatherLoaded extends WeatherState {
  final WeatherForecast forecast;
  final DateTime lastUpdated;

  const WeatherLoaded({
    required this.forecast,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [forecast, lastUpdated];
}

/// Error state
class WeatherError extends WeatherState {
  final String message;
  final WeatherForecast? cachedForecast; // Optional cached data to show

  const WeatherError({
    required this.message,
    this.cachedForecast,
  });

  @override
  List<Object?> get props => [message, cachedForecast];
}
