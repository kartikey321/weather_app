import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:weather_app/core/constants/storage_keys.dart';
import 'package:weather_app/core/errors/exceptions.dart';
import 'package:weather_app/features/auth/data/models/user_model.dart';

/// Local data source for authentication
abstract class AuthLocalDataSource {
  /// Get cached user
  Future<UserModel?> getCachedUser();

  /// Cache user
  Future<void> cacheUser(UserModel user);

  /// Get cached JWT token
  Future<String?> getCachedToken();

  /// Cache JWT token
  Future<void> cacheToken(String token);

  /// Clear all cached auth data
  Future<void> clearCache();
}

/// Implementation of AuthLocalDataSource
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl(this.secureStorage);

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = await secureStorage.read(key: StorageKeys.userData);
      if (userJson != null && userJson.isNotEmpty) {
        return UserModel.fromJson(
          json.decode(userJson) as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached user: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = json.encode(user.toJson());
      await secureStorage.write(
        key: StorageKeys.userData,
        value: userJson,
      );
    } catch (e) {
      throw CacheException('Failed to cache user: ${e.toString()}');
    }
  }

  @override
  Future<String?> getCachedToken() async {
    try {
      return await secureStorage.read(key: StorageKeys.jwtToken);
    } catch (e) {
      throw CacheException('Failed to get cached token: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheToken(String token) async {
    try {
      await secureStorage.write(
        key: StorageKeys.jwtToken,
        value: token,
      );
    } catch (e) {
      throw CacheException('Failed to cache token: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await Future.wait([
        secureStorage.delete(key: StorageKeys.jwtToken),
        secureStorage.delete(key: StorageKeys.userData),
      ]);
    } catch (e) {
      throw CacheException('Failed to clear cache: ${e.toString()}');
    }
  }
}
