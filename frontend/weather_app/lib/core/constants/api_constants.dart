/// API Constants
class ApiConstants {
  // Base URL - Update this with your Cloudflare Workers URL
  // For local development: http://localhost:8787/api/v1
  // For production: https://your-worker.your-subdomain.workers.dev/api/v1
  static const String baseUrl =
      'https://weather-backend.kartikeymahawar1234.workers.dev/api/v1';

  // Auth Endpoints
  static const String authRegister = '/auth/register';
  static const String authLogin = '/auth/login';
  static const String authMe = '/auth/me';

  // Weather Endpoints
  static const String weatherCurrent = '/weather/current';
  static const String weatherForecast = '/weather/forecast';
  static const String weatherHistorical = '/weather/historical';
  static const String weatherTimemachine = '/weather/timemachine';
  static const String weatherDaySummary = '/weather/day-summary';
  static const String weatherOverview = '/weather/overview';

  // User Endpoints
  static const String userProfile = '/user/profile';
  static const String userAccount = '/user/account';

  // Health
  static const String health = '/health';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
