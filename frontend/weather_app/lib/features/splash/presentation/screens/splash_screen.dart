import 'package:flutter/material.dart';
import 'package:weather_app/core/services/deep_link_tracker.dart';
import 'package:weather_app/core/services/location_service.dart';
import 'package:weather_app/features/weather/presentation/screens/weather_screen.dart';
import 'package:weather_app/features/weather/presentation/widgets/manual_location_entry.dart';
import 'package:weather_app/injection_container.dart';

/// Splash screen that handles location fetching
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LocationService _locationService = sl<LocationService>();
  bool _showManualEntry = false;
  String _statusMessage = 'Getting your location...';
  bool _locationInitStarted = false;
  late final DeepLinkTracker _deepLinkTracker;

  @override
  void initState() {
    super.initState();
    _deepLinkTracker = DeepLinkTracker.instance;
    _deepLinkTracker.statusNotifier.addListener(_handleDeepLinkStatus);

    if (!_attemptDeepLinkNavigation()) {
      _startLocationFlow();
    }
  }

  void _handleDeepLinkStatus() {
    final status = _deepLinkTracker.status;
    if (!mounted) return;

    if (status == DeepLinkStatus.pending) {
      _attemptDeepLinkNavigation();
      return;
    }

    if (status == DeepLinkStatus.failure) {
      _deepLinkTracker.resetStatus();
      _startLocationFlow();
      return;
    }

    if (status == DeepLinkStatus.success) {
      _deepLinkTracker.resetStatus();
      return;
    }

    if (status == DeepLinkStatus.idle && !_locationInitStarted) {
      _startLocationFlow();
    }
  }

  bool _attemptDeepLinkNavigation() {
    final query = _deepLinkTracker.consumePendingQuery();
    if (query == null) {
      return false;
    }

    setState(() {
      _statusMessage = 'Opening shared location...';
      _showManualEntry = false;
      _locationInitStarted = true;
    });

    _navigateToWeather(
      latitude: query.latitude,
      longitude: query.longitude,
      city: query.city,
      fromDeepLink: true,
    );
    return true;
  }

  void _startLocationFlow() {
    if (_locationInitStarted) return;
    _locationInitStarted = true;
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    setState(() {
      _statusMessage = 'Getting your location...';
    });

    // Try to get current position
    final position = await _locationService.getCurrentPosition();

    if (position != null) {
      // Got location successfully
      _navigateToWeather(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } else {
      // Try to get last known position
      final lastPosition = await _locationService.getLastKnownPosition();

      if (lastPosition != null) {
        _navigateToWeather(
          latitude: lastPosition.latitude,
          longitude: lastPosition.longitude,
        );
      } else {
        // Show manual entry
        setState(() {
          _showManualEntry = true;
          _statusMessage = 'Location permission required';
        });
      }
    }
  }

  void _navigateToWeather({
    double? latitude,
    double? longitude,
    String? city,
    bool fromDeepLink = false,
  }) {
    if ((latitude == null || longitude == null) &&
        (city == null || city.isEmpty)) {
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => WeatherScreen(
          latitude: latitude,
          longitude: longitude,
          city: city,
          fromDeepLink: fromDeepLink,
        ),
      ),
    );
  }

  void _onManualLocationEntered({
    double? latitude,
    double? longitude,
    String? city,
  }) {
    _navigateToWeather(latitude: latitude, longitude: longitude, city: city);
  }

  void _onRetryLocation() {
    setState(() {
      _showManualEntry = false;
    });
    _startLocationFlow();
  }

  Future<void> _openSettings() async {
    await _locationService.openLocationSettings();
  }

  @override
  void dispose() {
    _deepLinkTracker.statusNotifier.removeListener(_handleDeepLinkStatus);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _showManualEntry
              ? SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ManualLocationEntry(
                        onLocationEntered: _onManualLocationEntered,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            onPressed: _onRetryLocation,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          ),
                          const SizedBox(width: 16),
                          TextButton.icon(
                            onPressed: _openSettings,
                            icon: const Icon(Icons.settings),
                            label: const Text('Settings'),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Loading indicator
                    const CircularProgressIndicator(),
                    const SizedBox(height: 24),

                    // Status message
                    Text(
                      _statusMessage,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),

                    // App name/logo
                    Text(
                      'Weather App',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
