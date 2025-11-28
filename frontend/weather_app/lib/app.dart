import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_links/uni_links.dart';
import 'package:weather_app/core/theme/app_theme.dart';
import 'package:weather_app/core/services/deep_link_tracker.dart';
import 'package:weather_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:weather_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:weather_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:weather_app/features/weather/domain/entities/weather_query.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weather_app/injection_container.dart';

/// Main application widget
class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  StreamSubscription<Uri?>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initializeDeepLinks();
  }

  Future<void> _initializeDeepLinks() async {
    if (kIsWeb) {
      final initialUri = Uri.base;
      if (_hasWeatherParams(initialUri)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _handleIncomingLink(initialUri);
        });
      }
      return;
    }

    try {
      final initialUri = await getInitialUri();
      if (initialUri != null && _hasWeatherParams(initialUri)) {
        _handleIncomingLink(initialUri);
      }
    } on PlatformException catch (e) {
      debugPrint('Failed to read initial deep link: ${e.message}');
    } on FormatException catch (e) {
      debugPrint('Malformed initial deep link: ${e.message}');
    }

    _linkSubscription = uriLinkStream.listen(
      (Uri? uri) {
        if (!mounted || uri == null) return;
        if (_hasWeatherParams(uri)) {
          _handleIncomingLink(uri);
        }
      },
      onError: (Object err) {
        debugPrint('Deep link stream error: $err');
      },
    );
  }

  bool _hasWeatherParams(Uri uri) {
    final city = uri.queryParameters['city'];
    final latParam = uri.queryParameters['lat'];
    final lonParam = uri.queryParameters['lon'];

    return (city != null && city.isNotEmpty) ||
        (latParam != null && lonParam != null);
  }

  WeatherQuery? _buildQueryFromUri(Uri uri) {
    final city = uri.queryParameters['city'];
    if (city != null && city.isNotEmpty) {
      return WeatherQuery(city: city);
    }

    final latParam = uri.queryParameters['lat'];
    final lonParam = uri.queryParameters['lon'];

    if (latParam != null && lonParam != null) {
      final latitude = double.tryParse(latParam);
      final longitude = double.tryParse(lonParam);

      if (latitude != null && longitude != null) {
        return WeatherQuery(latitude: latitude, longitude: longitude);
      }
    }

    return null;
  }

  void _handleIncomingLink(Uri uri) {
    final query = _buildQueryFromUri(uri);
    if (query == null) {
      return;
    }

    DeepLinkTracker.instance.submitQuery(query);
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<AuthBloc>()..add(const CheckAuthStatusEvent()),
        ),
        BlocProvider(create: (_) => sl<WeatherBloc>()),
      ],
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'Weather App',
        debugShowCheckedModeBanner: false,

        // Theme
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,

        // Home - Skip auth, go directly to splash screen
        home: const SplashScreen(),
      ),
    );
  }
}
