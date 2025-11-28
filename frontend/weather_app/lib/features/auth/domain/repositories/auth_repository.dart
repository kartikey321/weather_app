import 'package:dartz/dartz.dart';
import 'package:weather_app/core/errors/failures.dart';
import 'package:weather_app/features/auth/domain/entities/user.dart';

/// Authentication repository interface
abstract class AuthRepository {
  /// Login user
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Register user
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
  });

  /// Logout user
  Future<Either<Failure, void>> logout();

  /// Check if user is authenticated
  Future<Either<Failure, bool>> isAuthenticated();

  /// Get current user
  Future<Either<Failure, User?>> getCurrentUser();
}
