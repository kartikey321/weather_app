import 'dart:convert';
import 'package:crypto/crypto.dart';

/// SHA256 hash utility for request caching
/// Generates consistent hashes matching backend implementation
class HashUtil {
  /// Generate SHA256 hash from parameters
  /// Sorts keys to ensure consistent hashing regardless of parameter order
  static String generateCacheHash(Map<String, dynamic> params) {
    // Sort keys for consistent hashing
    final sortedKeys = params.keys.toList()..sort();

    // Create parameter string: "key1:value1|key2:value2|..."
    final paramString = sortedKeys.map((key) => '$key:${params[key]}').join('|');

    // Generate SHA256 hash
    final bytes = utf8.encode(paramString);
    final digest = sha256.convert(bytes);

    return digest.toString();
  }

  /// Validate hash format (64 character hex string)
  static bool isValidHash(String hash) {
    final hashRegex = RegExp(r'^[a-f0-9]{64}$');
    return hashRegex.hasMatch(hash);
  }
}
