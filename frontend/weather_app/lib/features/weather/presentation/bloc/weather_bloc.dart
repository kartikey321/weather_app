import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/features/weather/domain/usecases/get_forecast.dart';
import 'package:weather_app/features/weather/domain/usecases/get_historical_weather.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_event.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_state.dart';

/// Weather BLoC (Open-Meteo)
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetForecast getForecastUseCase;
  final GetHistoricalWeather getHistoricalWeatherUseCase;

  WeatherBloc({
    required this.getForecastUseCase,
    required this.getHistoricalWeatherUseCase,
  }) : super(const WeatherInitial()) {
    on<LoadWeatherForecastEvent>(_onLoadWeatherForecast);
    on<RefreshWeatherEvent>(_onRefreshWeather);
    on<LoadHistoricalWeatherEvent>(_onLoadHistoricalWeather);
  }

  /// Handle load weather forecast event
  Future<void> _onLoadWeatherForecast(
    LoadWeatherForecastEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(const WeatherLoading());

    final params = GetForecastParams(
      latitude: event.latitude,
      longitude: event.longitude,
      city: event.city,
      forceRefresh: event.forceRefresh,
    );

    final result = await getForecastUseCase(params);

    result.fold(
      (failure) => emit(WeatherError(message: failure.message)),
      (forecast) =>
          emit(WeatherLoaded(forecast: forecast, lastUpdated: DateTime.now())),
    );
  }

  /// Handle refresh weather event
  Future<void> _onRefreshWeather(
    RefreshWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    // Keep the current state while refreshing
    final currentState = state;

    final params = GetForecastParams(
      latitude: event.latitude,
      longitude: event.longitude,
      city: event.city,
      forceRefresh: true,
    );

    final result = await getForecastUseCase(params);

    result.fold(
      (failure) {
        // If refresh fails and we have cached data, show error with cached data
        if (currentState is WeatherLoaded) {
          emit(
            WeatherError(
              message: failure.message,
              cachedForecast: currentState.forecast,
            ),
          );
        } else {
          emit(WeatherError(message: failure.message));
        }
      },
      (forecast) =>
          emit(WeatherLoaded(forecast: forecast, lastUpdated: DateTime.now())),
    );
  }

  /// Handle load historical weather event
  Future<void> _onLoadHistoricalWeather(
    LoadHistoricalWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(const WeatherLoading());

    final params = GetHistoricalWeatherParams(
      latitude: event.latitude,
      longitude: event.longitude,
      city: event.city,
      startDate: event.startDate,
      endDate: event.endDate,
    );

    final result = await getHistoricalWeatherUseCase(params);

    result.fold(
      (failure) => emit(WeatherError(message: failure.message)),
      (forecast) =>
          emit(WeatherLoaded(forecast: forecast, lastUpdated: DateTime.now())),
    );
  }
}
