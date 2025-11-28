/// Base class for all exceptions
class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

/// Server exception (500, 502, etc.)
class ServerException extends AppException {
  ServerException(super.message);
}

/// Network connectivity exception
class NetworkException extends AppException {
  NetworkException(super.message);
}

/// Cache exception
class CacheException extends AppException {
  CacheException(super.message);
}

/// Authentication exception (401, 403)
class AuthenticationException extends AppException {
  AuthenticationException(super.message);
}

/// Validation exception (400)
class ValidationException extends AppException {
  ValidationException(super.message);
}

/// Not found exception (404)
class NotFoundException extends AppException {
  NotFoundException(super.message);
}

/// Rate limit exception (429)
class RateLimitException extends AppException {
  RateLimitException(super.message);
}
