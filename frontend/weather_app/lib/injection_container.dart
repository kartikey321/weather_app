import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/core/network/api_client.dart';
import 'package:weather_app/core/network/network_info.dart';
import 'package:weather_app/core/services/location_service.dart';
import 'package:weather_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:weather_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:weather_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:weather_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:weather_app/features/auth/domain/usecases/check_auth_status.dart';
import 'package:weather_app/features/auth/domain/usecases/get_current_user.dart';
import 'package:weather_app/features/auth/domain/usecases/login.dart';
import 'package:weather_app/features/auth/domain/usecases/logout.dart';
import 'package:weather_app/features/auth/domain/usecases/register.dart';
import 'package:weather_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:weather_app/features/weather/data/datasources/weather_local_data_source.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weather_app/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/domain/usecases/get_forecast.dart';
import 'package:weather_app/features/weather/domain/usecases/get_historical_weather.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_bloc.dart';

final sl = GetIt.instance;

/// Initialize dependency injection
Future<void> init() async {
  print('🔷 Starting dependency injection initialization...');

  // ===== Core =====

  // Network
  print('🔷 Registering core dependencies...');
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => ApiClient(sl(), sl()));
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Services
  sl.registerLazySingleton(() => LocationService());

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  print('🔷 Core dependencies registered');

  // ===== Features =====

  // Auth feature dependencies
  print('🔷 Initializing auth feature...');
  _initAuth();
  print('🔷 Auth feature initialized');

  // Weather feature dependencies
  print('🔷 Initializing weather feature...');
  _initWeather();
  print('🔷 Weather feature initialized');

  // Settings feature dependencies will go here

  print('🔷 Dependency injection initialization complete!');
}

/// Initialize auth feature dependencies
void _initAuth() {
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Register(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => CheckAuthStatus(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  // BLoC
  sl.registerFactory(
    () {
      print('🔷 Creating AuthBloc instance...');
      return AuthBloc(
        loginUseCase: sl(),
        registerUseCase: sl(),
        logoutUseCase: sl(),
        checkAuthStatusUseCase: sl(),
        getCurrentUserUseCase: sl(),
      );
    },
  );
  print('🔷 Auth dependencies registered');
}

/// Initialize weather feature dependencies
void _initWeather() {
  // Data sources
  sl.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<WeatherLocalDataSource>(
    () => WeatherLocalDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetForecast(sl()));
  sl.registerLazySingleton(() => GetHistoricalWeather(sl()));

  // BLoC
  sl.registerFactory(
    () => WeatherBloc(
      getForecastUseCase: sl(),
      getHistoricalWeatherUseCase: sl(),
    ),
  );
}
