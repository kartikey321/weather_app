# Weather App Frontend - Implementation Plan

**Platform:** Flutter (Multi-platform: iOS, Android, Web, Desktop)
**Backend API:** Cloudflare Workers (Hono + D1 + KV)
**Last Updated:** 2025-11-22
**Status:** Planning Phase

---

## 1. Project Overview

A modern, cross-platform weather application built with Flutter that integrates with our custom weather API backend. The app features JWT authentication, intelligent caching, and a beautiful, responsive UI.

### 1.1 Current State
- ✅ Fresh Flutter project (SDK ^3.10.0)
- ✅ Basic project structure
- ✅ Default counter app (to be replaced)

---

## 2. Architecture

### 2.1 Chosen Pattern: **Clean Architecture + BLoC**

**Why Clean Architecture?**
- Clear separation of concerns
- Testable business logic
- Independent of frameworks/UI
- Scalable for future features

**Why BLoC?**
- Recommended by Flutter team
- Predictable state management
- Easy testing
- Strong typing with Dart
- Good DevTools support

### 2.2 Layer Structure

```
Presentation Layer (UI)
    ↓
BLoC Layer (State Management)
    ↓
Domain Layer (Business Logic)
    ↓
Data Layer (API, Local Storage)
```

---

## 3. Folder Structure

```
lib/
├── main.dart                    # App entry point
├── app.dart                     # Material App configuration
│
├── core/
│   ├── constants/
│   │   ├── api_constants.dart   # API endpoints, base URL
│   │   ├── app_constants.dart   # App-wide constants
│   │   └── storage_keys.dart    # Local storage keys
│   ├── errors/
│   │   ├── failures.dart        # Failure types
│   │   └── exceptions.dart      # Custom exceptions
│   ├── network/
│   │   ├── api_client.dart      # HTTP client wrapper
│   │   └── network_info.dart    # Connectivity check
│   ├── utils/
│   │   ├── hash_util.dart       # SHA256 hash generation
│   │   ├── date_util.dart       # Date formatting
│   │   └── validators.dart      # Input validation
│   └── theme/
│       ├── app_theme.dart       # Light/Dark themes
│       ├── colors.dart          # Color palette
│       └── text_styles.dart     # Typography
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   ├── datasources/
│   │   │   │   ├── auth_remote_datasource.dart
│   │   │   │   └── auth_local_datasource.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login.dart
│   │   │       ├── register.dart
│   │   │       ├── logout.dart
│   │   │       └── get_current_user.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │   │       └── auth_state.dart
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   ├── register_page.dart
│   │       │   └── profile_page.dart
│   │       └── widgets/
│   │           ├── auth_form.dart
│   │           └── password_field.dart
│   │
│   ├── weather/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── weather_model.dart
│   │   │   │   ├── forecast_model.dart
│   │   │   │   └── location_model.dart
│   │   │   ├── datasources/
│   │   │   │   ├── weather_remote_datasource.dart
│   │   │   │   └── weather_local_datasource.dart
│   │   │   └── repositories/
│   │   │       └── weather_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── weather.dart
│   │   │   │   ├── forecast.dart
│   │   │   │   └── location.dart
│   │   │   ├── repositories/
│   │   │   │   └── weather_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_current_weather.dart
│   │   │       ├── get_forecast.dart
│   │   │       ├── get_day_summary.dart
│   │   │       └── get_weather_overview.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── weather_bloc.dart
│   │       │   ├── weather_event.dart
│   │       │   └── weather_state.dart
│   │       ├── pages/
│   │       │   ├── home_page.dart
│   │       │   ├── forecast_page.dart
│   │       │   └── search_page.dart
│   │       └── widgets/
│   │           ├── weather_card.dart
│   │           ├── forecast_list.dart
│   │           ├── temperature_display.dart
│   │           └── weather_icon.dart
│   │
│   └── settings/
│       ├── presentation/
│       │   ├── pages/
│       │   │   └── settings_page.dart
│       │   └── widgets/
│       │       └── theme_toggle.dart
│       └── domain/
│           └── entities/
│               └── user_preferences.dart
│
└── injection_container.dart     # Dependency injection setup
```

---

## 4. Dependencies

### 4.1 State Management & Architecture
```yaml
dependencies:
  # State Management
  flutter_bloc: ^8.1.6
  equatable: ^2.0.5

  # Dependency Injection
  get_it: ^8.0.2
  injectable: ^2.5.0

  # Functional Programming
  dartz: ^0.10.1
```

### 4.2 Network & Data
```yaml
dependencies:
  # HTTP Client
  dio: ^5.7.0
  retrofit: ^4.5.0
  json_annotation: ^4.9.0

  # Local Storage
  shared_preferences: ^2.3.4
  flutter_secure_storage: ^9.2.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # Connectivity
  connectivity_plus: ^6.1.2
```

### 4.3 UI & UX
```yaml
dependencies:
  # Icons & Fonts
  cupertino_icons: ^1.0.8
  google_fonts: ^6.2.1
  flutter_svg: ^2.0.10+1

  # Animations
  lottie: ^3.1.3
  shimmer: ^3.0.0

  # UI Components
  cached_network_image: ^3.4.1
  flutter_spinkit: ^5.2.1
```

### 4.4 Location & Permissions
```yaml
dependencies:
  # Location
  geolocator: ^13.0.2
  geocoding: ^3.0.0
  permission_handler: ^11.3.1
```

### 4.5 Utilities
```yaml
dependencies:
  # Date & Time
  intl: ^0.20.1

  # Crypto
  crypto: ^3.0.5

  # Logging
  logger: ^2.5.0
```

### 4.6 Dev Dependencies
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter

  # Code Generation
  build_runner: ^2.4.14
  injectable_generator: ^2.6.2
  json_serializable: ^6.9.2
  retrofit_generator: ^9.1.8
  hive_generator: ^2.0.1

  # Testing
  mockito: ^5.4.4
  bloc_test: ^9.1.7
  mocktail: ^1.0.4

  # Linting
  flutter_lints: ^6.0.0
  very_good_analysis: ^6.0.0
```

---

## 5. Features Implementation

### 5.1 Authentication Feature

**Use Cases:**
- ✅ Register new user
- ✅ Login existing user
- ✅ Logout user
- ✅ Get current user profile
- ✅ Auto-login with stored token
- ✅ Token refresh (if backend supports)

**Data Flow:**
```
UI Event (Login Button)
    ↓
AuthBloc receives LoginRequested event
    ↓
LoginUseCase executes
    ↓
AuthRepository calls API
    ↓
Store JWT in SecureStorage
    ↓
Emit AuthAuthenticated state
    ↓
UI navigates to Home
```

**Local Storage:**
- JWT token (Secure Storage)
- User profile (SharedPreferences)
- Remember me preference

---

### 5.2 Weather Feature

**Use Cases:**
- ✅ Get current weather by coordinates
- ✅ Get weather forecast (hourly/daily)
- ✅ Get day summary
- ✅ Get AI weather overview
- ✅ Search location
- ✅ Get weather by current location
- ✅ Save favorite locations
- ✅ View cached weather data offline

**Hash Generation:**
```dart
// lib/core/utils/hash_util.dart
import 'dart:convert';
import 'package:crypto/crypto.dart';

class HashUtil {
  static String generateCacheHash(Map<String, dynamic> params) {
    // Sort keys for consistent hashing
    final sortedKeys = params.keys.toList()..sort();
    final paramString = sortedKeys
        .map((key) => '$key:${params[key]}')
        .join('|');

    // Generate SHA256 hash
    final bytes = utf8.encode(paramString);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}

// Usage
final hash = HashUtil.generateCacheHash({
  'lat': 37.7749,
  'lon': -122.4194,
  'units': 'metric',
});
```

**Caching Strategy:**
- Local cache (Hive) for offline support
- API cache indication in response
- Cache expiration (10 minutes to match backend)
- Refresh indicator for manual update

---

### 5.3 Settings Feature

**Preferences:**
- ✅ Units (Metric/Imperial)
- ✅ Theme (Light/Dark/System)
- ✅ Language
- ✅ Default location
- ✅ Notifications enabled
- ✅ Auto-refresh interval

---

## 6. API Integration

### 6.1 API Client Setup

```dart
// lib/core/network/api_client.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  ApiClient(this._dio, this._secureStorage) {
    _dio.options.baseUrl = 'YOUR_BACKEND_URL/api/v1';
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    // Request Interceptor (Add JWT token)
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _secureStorage.read(key: 'jwt_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        // Handle 401 Unauthorized (token expired)
        if (error.response?.statusCode == 401) {
          // Logout or refresh token
        }
        return handler.next(error);
      },
    ));
  }

  Dio get dio => _dio;
}
```

### 6.2 API Endpoints (Retrofit)

```dart
// lib/features/weather/data/datasources/weather_api.dart
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'weather_api.g.dart';

@RestApi()
abstract class WeatherApi {
  factory WeatherApi(Dio dio) = _WeatherApi;

  @GET('/weather/current')
  Future<WeatherResponse> getCurrentWeather(
    @Query('lat') double lat,
    @Query('lon') double lon,
    @Query('units') String units,
    @Query('hash') String hash,
  );

  @GET('/weather/forecast')
  Future<ForecastResponse> getForecast(
    @Query('lat') double lat,
    @Query('lon') double lon,
    @Query('units') String units,
    @Query('hash') String hash,
  );

  @GET('/weather/day-summary')
  Future<DaySummaryResponse> getDaySummary(
    @Query('lat') double lat,
    @Query('lon') double lon,
    @Query('date') String date,
    @Query('hash') String hash,
  );

  @GET('/weather/overview')
  Future<OverviewResponse> getWeatherOverview(
    @Query('lat') double lat,
    @Query('lon') double lon,
    @Query('hash') String hash,
  );
}
```

---

## 7. UI/UX Design

### 7.1 Design System

**Color Palette:**
- Primary: Blue shades (sky/weather theme)
- Secondary: Orange/Yellow (sun theme)
- Success: Green
- Error: Red
- Surface colors for light/dark modes

**Typography:**
- Google Fonts: Inter or Poppins
- Heading sizes: 24, 20, 18, 16
- Body sizes: 14, 12

**Components:**
- Custom weather icons
- Gradient backgrounds based on time/weather
- Glassmorphism cards
- Smooth animations

### 7.2 Screen Designs

**Home Screen:**
- Current location weather (large card)
- Temperature, feels like, weather description
- Hourly forecast (horizontal scroll)
- Daily forecast (vertical list)
- Search bar at top
- Pull to refresh

**Search Screen:**
- Location search with autocomplete
- Recent searches
- Favorite locations
- Add to favorites button

**Forecast Screen:**
- Detailed hourly forecast
- Daily forecast with all metrics
- Weather overview (AI summary)
- Charts (temperature, precipitation)

**Profile Screen:**
- User info
- Favorite locations management
- Settings access
- Logout button

**Settings Screen:**
- Units selection
- Theme toggle (Light/Dark/Auto)
- Language selection
- About app
- Version info

### 7.3 Animations

- **Splash Screen:** Lottie weather animation
- **Weather Icons:** Animated SVG/Lottie
- **Loading:** Shimmer effect for cards
- **Transitions:** Hero animations between screens
- **Pull to Refresh:** Custom indicator

---

## 8. State Management (BLoC Pattern)

### 8.1 Weather BLoC Example

```dart
// Events
abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
}

class GetWeatherRequested extends WeatherEvent {
  final double lat;
  final double lon;

  const GetWeatherRequested(this.lat, this.lon);

  @override
  List<Object> get props => [lat, lon];
}

// States
abstract class WeatherState extends Equatable {
  const WeatherState();
}

class WeatherInitial extends WeatherState {
  @override
  List<Object> get props => [];
}

class WeatherLoading extends WeatherState {
  @override
  List<Object> get props => [];
}

class WeatherLoaded extends WeatherState {
  final Weather weather;
  final bool fromCache;

  const WeatherLoaded(this.weather, {this.fromCache = false});

  @override
  List<Object> get props => [weather, fromCache];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeather getCurrentWeather;

  WeatherBloc({required this.getCurrentWeather})
      : super(WeatherInitial()) {
    on<GetWeatherRequested>(_onGetWeatherRequested);
  }

  Future<void> _onGetWeatherRequested(
    GetWeatherRequested event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());

    final result = await getCurrentWeather(
      WeatherParams(lat: event.lat, lon: event.lon)
    );

    result.fold(
      (failure) => emit(WeatherError(failure.message)),
      (weather) => emit(WeatherLoaded(weather)),
    );
  }
}
```

---

## 9. Error Handling

### 9.1 Failure Types

```dart
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message);
}
```

### 9.2 Error Display

- Snackbar for temporary errors
- Error state in UI with retry button
- Offline indicator
- Detailed error messages in debug mode

---

## 10. Testing Strategy

### 10.1 Unit Tests
- ✅ UseCases
- ✅ Repositories
- ✅ BLoCs
- ✅ Utilities (Hash, Validators)
- ✅ Models (fromJson/toJson)

### 10.2 Widget Tests
- ✅ Individual widgets
- ✅ Page layouts
- ✅ Form validation

### 10.3 Integration Tests
- ✅ End-to-end flows
- ✅ API integration
- ✅ Navigation

### 10.4 Test Coverage Goal
- **Target:** 80%+
- **Critical paths:** 100% (Auth, Weather API calls)

---

## 11. Implementation Phases

### Phase 1: Setup & Foundation (Week 1)
- [ ] Set up dependencies
- [ ] Configure folder structure
- [ ] Implement core utilities (Hash, Validators)
- [ ] Set up theme and constants
- [ ] Configure DI (GetIt)
- [ ] Set up API client (Dio + Retrofit)

### Phase 2: Authentication (Week 2)
- [ ] Implement Auth data layer
- [ ] Implement Auth domain layer
- [ ] Implement Auth BLoC
- [ ] Create Login/Register UI
- [ ] Implement secure storage
- [ ] Add auto-login

### Phase 3: Weather Feature (Week 3-4)
- [ ] Implement Weather data layer
- [ ] Implement Weather domain layer
- [ ] Implement Weather BLoC
- [ ] Create Home screen UI
- [ ] Implement location services
- [ ] Add local caching (Hive)

### Phase 4: Advanced Features (Week 5)
- [ ] Implement Forecast screen
- [ ] Add search functionality
- [ ] Implement favorites
- [ ] Add Settings screen
- [ ] Implement theme switching

### Phase 5: Polish & Testing (Week 6)
- [ ] Add animations
- [ ] Implement error handling
- [ ] Write unit tests
- [ ] Write widget tests
- [ ] Performance optimization
- [ ] Final UI polish

### Phase 6: Deployment (Week 7)
- [ ] Platform-specific setup (iOS/Android)
- [ ] Build release versions
- [ ] App store assets
- [ ] Documentation
- [ ] Deployment

---

## 12. Performance Optimization

### 12.1 Best Practices
- Use `const` constructors where possible
- Implement pagination for long lists
- Use `ListView.builder` for dynamic lists
- Cache network images
- Lazy load data
- Debounce search input
- Optimize widget rebuilds

### 12.2 Build Optimization
- Enable tree-shaking
- Minify release builds
- Use split APKs for Android
- Optimize images and assets

---

## 13. Security Considerations

- ✅ Store JWT in FlutterSecureStorage
- ✅ Never log sensitive data
- ✅ Validate all user inputs
- ✅ Use HTTPS only
- ✅ Implement certificate pinning (optional)
- ✅ Obfuscate code in release builds

---

## 14. Platform-Specific Considerations

### 14.1 Android
- Minimum SDK: 21 (Android 5.0)
- Target SDK: 34 (Android 14)
- Permissions: Location, Internet

### 14.2 iOS
- Minimum version: iOS 13.0
- Location permission strings in Info.plist
- App Transport Security settings

### 14.3 Web
- Responsive design
- PWA support (optional)
- Browser compatibility

### 14.4 Desktop
- Window size constraints
- Keyboard shortcuts
- Native menu integration

---

## 15. Analytics & Monitoring (Optional)

- Firebase Analytics
- Crashlytics
- Performance monitoring
- User behavior tracking

---

## 16. Future Enhancements

### Short-term
- [ ] Weather alerts/notifications
- [ ] Widget support (Android/iOS)
- [ ] Share weather info
- [ ] Multiple language support

### Medium-term
- [ ] Weather maps
- [ ] Historical data charts
- [ ] Weather comparison
- [ ] Wear OS / WatchOS app

### Long-term
- [ ] AR weather visualization
- [ ] Social features (share locations)
- [ ] AI-powered recommendations
- [ ] Offline maps

---

**Document Version:** 1.0
**Next Review:** After Phase 1 completion
**Maintainer:** Development Team
