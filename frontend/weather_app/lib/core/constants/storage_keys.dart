/// Local storage keys
class StorageKeys {
  // Secure Storage (JWT, sensitive data)
  static const String jwtToken = 'jwt_token';
  static const String userData = 'user_data';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';

  // SharedPreferences
  static const String userName = 'user_name';
  static const String isLoggedIn = 'is_logged_in';
  static const String rememberMe = 'remember_me';

  // Hive Boxes
  static const String weatherBox = 'weather_box';
  static const String favoritesBox = 'favorites_box';
  static const String settingsBox = 'settings_box';
}
