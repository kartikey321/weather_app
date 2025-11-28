import 'package:equatable/equatable.dart';

/// Base class for all failures
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Server-side error (500, 502, etc.)
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Network connectivity error
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Cache/local storage error
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Authentication/Authorization error (401, 403)
class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message);
}

/// Validation error (400)
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Resource not found error (404)
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

/// Rate limit exceeded error (429)
class RateLimitFailure extends Failure {
  const RateLimitFailure(super.message);
}

/// Generic/Unknown error
class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
