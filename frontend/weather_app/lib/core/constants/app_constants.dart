/// Application-wide constants
class AppConstants {
  // App Info
  static const String appName = 'Weather App';
  static const String appVersion = '1.0.0';

  // Cache
  static const Duration cacheExpiration = Duration(minutes: 10);

  // Weather Units
  static const String metric = 'metric';
  static const String imperial = 'imperial';
  static const String standard = 'standard';

  // Preferences Keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyUnits = 'units';
  static const String keyLanguage = 'language';
  static const String keyDefaultLocation = 'default_location';

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // UI
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;
  static const double defaultPadding = 16.0;
}
