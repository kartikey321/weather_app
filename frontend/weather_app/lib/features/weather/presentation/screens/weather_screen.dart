import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/services/deep_link_tracker.dart';
import 'package:weather_app/core/services/location_service.dart';
import 'package:weather_app/core/utils/responsive.dart';
import 'package:weather_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:weather_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:weather_app/features/auth/presentation/screens/login_screen.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/entities/weather_query.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_event.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_state.dart';
import 'package:weather_app/features/weather/presentation/widgets/daily_forecast_card.dart';
import 'package:weather_app/features/weather/presentation/widgets/parallax_background.dart';
import 'package:weather_app/features/weather/presentation/widgets/temperature_display.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_animation_helper.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_info_card.dart';
import 'package:weather_app/features/weather/presentation/widgets/video_background.dart';
import 'package:weather_app/injection_container.dart';

/// Weather screen
class WeatherScreen extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final String? city;
  final bool fromDeepLink;

  WeatherScreen({
    super.key,
    this.latitude,
    this.longitude,
    this.city,
    this.fromDeepLink = false,
  }) : assert(
         (latitude != null && longitude != null) ||
             (city != null && city.isNotEmpty),
         'WeatherScreen requires either coordinates or a city name',
       );

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late ScrollController _scrollController;
  late WeatherQuery _query;
  bool _deepLinkResultSent = false;
  bool _deepLinkActive = false;
  bool _fallbackInProgress = false;
  late final DeepLinkTracker _deepLinkTracker;
  StreamSubscription<WeatherQuery>? _deepLinkSubscription;
  final LocationService _fallbackLocationService = sl<LocationService>();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    final trimmedCity = widget.city?.trim();
    _query = WeatherQuery(
      latitude: widget.latitude,
      longitude: widget.longitude,
      city: (trimmedCity != null && trimmedCity.isNotEmpty)
          ? trimmedCity
          : null,
    );
    _deepLinkTracker = DeepLinkTracker.instance;
    _deepLinkSubscription = _deepLinkTracker.stream.listen(
      _handleExternalDeepLink,
    );
    _deepLinkActive = widget.fromDeepLink;

    _loadWeather();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _deepLinkSubscription?.cancel();
    super.dispose();
  }

  void _loadWeather({bool forceRefresh = false}) {
    context.read<WeatherBloc>().add(
      LoadWeatherForecastEvent(
        latitude: _query.latitude,
        longitude: _query.longitude,
        city: _query.city,
        forceRefresh: forceRefresh,
      ),
    );
    if (_deepLinkActive) {
      _deepLinkResultSent = false;
    }
  }

  void _refreshWeather() {
    context.read<WeatherBloc>().add(
      RefreshWeatherEvent(
        latitude: _query.latitude,
        longitude: _query.longitude,
        city: _query.city,
      ),
    );
  }

  Future<void> _openCitySearch() async {
    final controller = TextEditingController(text: _query.city ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search by City'),
          content: TextField(
            controller: controller,
            autofocus: true,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              labelText: 'City Name',
              hintText: 'e.g. Berlin',
            ),
            onSubmitted: (value) => Navigator.of(context).pop(value),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).pop(controller.text.trim()),
              child: const Text('Search'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (result != null) {
      final trimmed = result.trim();
      if (trimmed.isNotEmpty) {
        if (!mounted) return;
        setState(() {
          _query = _query.copyWith(city: trimmed, clearCoordinates: true);
        });
        _updateBrowserUrl();
        _loadWeather(forceRefresh: true);
      }
    }
  }

  void _handleExternalDeepLink(WeatherQuery query) {
    if (!mounted) return;
    setState(() {
      _query = _query.copyWith(
        latitude: query.latitude,
        longitude: query.longitude,
        city: query.city,
        clearCoordinates: !query.hasCoordinates,
        clearCity: !query.hasCity,
      );
      _deepLinkActive = true;
      _deepLinkResultSent = false;
    });
    _updateBrowserUrl();
    _loadWeather(forceRefresh: true);
  }

  Future<void> _copyDeepLink(WeatherForecast forecast) async {
    final uri = _buildDeepLink(forecast);
    await Clipboard.setData(ClipboardData(text: uri.toString()));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deep link copied to clipboard\n${uri.toString()}'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Uri _buildDeepLink(WeatherForecast forecast) {
    final params = <String, String>{};

    if (_query.city != null && _query.city!.isNotEmpty) {
      params['city'] = _query.city!;
    } else if (forecast.location.name != null &&
        forecast.location.name!.isNotEmpty) {
      params['city'] = forecast.location.name!;
    } else {
      params['lat'] = forecast.location.latitude.toStringAsFixed(4);
      params['lon'] = forecast.location.longitude.toStringAsFixed(4);
    }

    if (kIsWeb) {
      final base = Uri.base;
      return base.replace(queryParameters: params);
    }

    return Uri(
      scheme: 'weatherapp',
      host: 'weather',
      path: '/',
      queryParameters: params,
    );
  }

  void _syncQueryWithForecast(WeatherForecast forecast) {
    if (!_query.hasCoordinates ||
        _query.latitude != forecast.location.latitude ||
        _query.longitude != forecast.location.longitude) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _query = _query.copyWith(
            latitude: forecast.location.latitude,
            longitude: forecast.location.longitude,
          );
        });
        _updateBrowserUrl();
      });
    }
  }

  void _notifyDeepLinkResult(bool success) {
    if (!_deepLinkActive || _deepLinkResultSent) {
      return;
    }
    _deepLinkResultSent = true;
    _deepLinkActive = false;
    if (success) {
      DeepLinkTracker.instance.completeSuccess();
    } else {
      DeepLinkTracker.instance.completeFailure();
    }
  }

  void _updateBrowserUrl() {
    if (!kIsWeb) return;

    final params = <String, String>{};

    if (_query.city != null && _query.city!.isNotEmpty) {
      params['city'] = _query.city!;
    } else if (_query.latitude != null && _query.longitude != null) {
      params['lat'] = _query.latitude!.toStringAsFixed(4);
      params['lon'] = _query.longitude!.toStringAsFixed(4);
    }

    final updated = Uri.base.replace(
      queryParameters: params.isEmpty ? null : params,
    );

    SystemNavigator.routeInformationUpdated(uri: updated);
  }

  String _formatLocationTitle(Location location) {
    if (location.name != null && location.name!.isNotEmpty) {
      if (location.country != null && location.country!.isNotEmpty) {
        return '${location.name}, ${location.country}';
      }
      return location.name!;
    }

    if (location.displayName != null && location.displayName!.isNotEmpty) {
      return location.displayName!;
    }

    return '${location.latitude.toStringAsFixed(2)}, ${location.longitude.toStringAsFixed(2)}';
  }

  Widget _buildLocationHeader(Location location) {
    final subtitleParts = <String>[];
    if (location.state != null && location.state!.isNotEmpty) {
      subtitleParts.add(location.state!);
    }
    if (location.country != null && location.country!.isNotEmpty) {
      subtitleParts.add(location.country!);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _formatLocationTitle(location),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        if (subtitleParts.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            subtitleParts.join(' • '),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(
              avatar: const Icon(Icons.schedule, size: 18),
              label: Text(location.timezoneAbbreviation),
            ),
            Chip(
              avatar: const Icon(Icons.public, size: 18),
              label: Text(
                'Lat ${location.latitude.toStringAsFixed(2)}, '
                'Lon ${location.longitude.toStringAsFixed(2)}',
              ),
            ),
            if (location.source != null && location.source!.isNotEmpty)
              Chip(
                avatar: const Icon(Icons.location_searching, size: 18),
                label: Text(
                  location.source! == 'reverse'
                      ? 'Reverse geocoded'
                      : location.source!,
                ),
              ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WeatherLoaded) {
            final forecast = state.forecast;
            _syncQueryWithForecast(forecast);
            final current = forecast.current;
            if (current == null) {
              return const Center(
                child: Text('No current weather data available'),
              );
            }
            _notifyDeepLinkResult(true);
            final condition = current.condition;

            // Get weather-based gradient and animation
            final isDaytime = WeatherAnimationHelper.isDaytime();
            final gradientColors = WeatherAnimationHelper.getGradientColors(
              condition.code,
              isDaytime,
            );
            final weatherAnimation =
                WeatherAnimationHelper.getAnimationForWeatherCode(
                  condition.code,
                );

            return Stack(
              children: [
                // Weather animations in background
                if (weatherAnimation != null)
                  Positioned.fill(child: weatherAnimation),

                // Main content with parallax
                ParallaxBackground(
                  scrollController: _scrollController,
                  gradientColors: gradientColors,
                  backgroundWidget: VideoBackground(
                    weatherCode: condition.code,
                    isDaytime: isDaytime,
                  ),
                  child: RefreshIndicator(
                    onRefresh: () async => _refreshWeather(),
                    child: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        // App bar
                        SliverAppBar(
                          expandedHeight: 200,
                          pinned: true,
                          actions: [
                            IconButton(
                              icon: const Icon(Icons.search),
                              tooltip: 'Search city',
                              onPressed: _openCitySearch,
                            ),
                            IconButton(
                              icon: const Icon(Icons.link),
                              tooltip: 'Copy deep link',
                              onPressed: () => _copyDeepLink(forecast),
                            ),
                            // Sign-in button (show only if not authenticated)
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, authState) {
                                if (authState is! Authenticated) {
                                  return IconButton(
                                    icon: const Icon(Icons.login),
                                    tooltip: 'Sign In',
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen(),
                                        ),
                                      );
                                    },
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                          backgroundColor: Colors.transparent,
                          flexibleSpace: FlexibleSpaceBar(
                            title: Text(
                              _formatLocationTitle(forecast.location),
                              style: const TextStyle(
                                shadows: [
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 3.0,
                                    color: Colors.black45,
                                  ),
                                ],
                              ),
                            ),
                            background: Container(color: Colors.transparent),
                          ),
                        ),

                        // Content
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  Responsive.getPadding(context) +
                                  Responsive.getHorizontalMargin(context),
                              vertical: Responsive.getPadding(context),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildLocationHeader(forecast.location),
                                const SizedBox(height: 24),
                                // Current temperature
                                Center(
                                  child: TemperatureDisplay(
                                    temperature: current.temperature,
                                    description: condition.description,
                                    icon: condition.icon,
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Weather details
                                GridView.count(
                                  crossAxisCount: Responsive.getGridColumns(
                                    context,
                                  ),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  childAspectRatio:
                                      Responsive.getGridChildAspectRatio(
                                        context,
                                      ),
                                  children: [
                                    WeatherInfoCard(
                                      icon: Icons.thermostat,
                                      label: 'Feels Like',
                                      value:
                                          '${current.apparentTemperature.round()}°C',
                                    ),
                                    WeatherInfoCard(
                                      icon: Icons.water_drop,
                                      label: 'Humidity',
                                      value: '${current.relativeHumidity}%',
                                    ),
                                    WeatherInfoCard(
                                      icon: Icons.air,
                                      label: 'Wind Speed',
                                      value:
                                          '${current.windSpeed.toStringAsFixed(1)} km/h',
                                    ),
                                    WeatherInfoCard(
                                      icon: Icons.speed,
                                      label: 'Pressure',
                                      value:
                                          '${current.pressureMsl.round()} hPa',
                                    ),
                                    WeatherInfoCard(
                                      icon: Icons.cloud,
                                      label: 'Cloud Cover',
                                      value: '${current.cloudCover}%',
                                    ),
                                    WeatherInfoCard(
                                      icon: Icons.opacity,
                                      label: 'Precipitation',
                                      value:
                                          '${current.precipitation.toStringAsFixed(1)} mm',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // Daily forecast
                                if (forecast.daily != null &&
                                    forecast.daily!.isNotEmpty) ...[
                                  Text(
                                    '7-Day Forecast',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.headlineMedium,
                                  ),
                                  const SizedBox(height: 16),
                                  ...forecast.daily!.map(
                                    (daily) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 8.0,
                                      ),
                                      child: DailyForecastCard(daily: daily),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (state is WeatherError) {
            // Show error with cached data if available
            if (state.cachedForecast != null) {
              final forecast = state.cachedForecast!;
              final current = forecast.current;
              if (current == null) {
                return const Center(
                  child: Text('No cached weather data available'),
                );
              }
              _notifyDeepLinkResult(true);
              final condition = current.condition;

              return RefreshIndicator(
                onRefresh: () async => _refreshWeather(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: Colors.orange,
                        child: Row(
                          children: [
                            const Icon(Icons.warning, color: Colors.white),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Showing cached data. ${state.message}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: TemperatureDisplay(
                            temperature: current.temperature,
                            description: condition.description,
                            icon: condition.icon,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final wasDeepLink = _deepLinkActive;
            _notifyDeepLinkResult(false);
            if (wasDeepLink) {
              _fallbackToCurrentLocation();
            }

            // Show error without cached data
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _refreshWeather,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Initial state
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<void> _fallbackToCurrentLocation() async {
    if (_fallbackInProgress) return;
    _fallbackInProgress = true;

    final position =
        await _fallbackLocationService.getCurrentPosition() ??
        await _fallbackLocationService.getLastKnownPosition();

    _fallbackInProgress = false;

    if (position == null || !mounted) {
      return;
    }

    setState(() {
      _query = WeatherQuery(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      _deepLinkResultSent = false;
    });
    _updateBrowserUrl();
    _loadWeather(forceRefresh: true);
  }
}
