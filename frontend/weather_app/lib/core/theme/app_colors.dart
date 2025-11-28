import 'package:flutter/material.dart';

/// App color palette
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF2196F3); // Blue
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFF64B5F6);

  // Secondary colors
  static const Color secondary = Color(0xFFFF9800); // Orange
  static const Color secondaryDark = Color(0xFFF57C00);
  static const Color secondaryLight = Color(0xFFFFB74D);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // Neutral colors (Light theme)
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);

  // Neutral colors (Dark theme)
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);

  // Weather-specific colors
  static const Color sunny = Color(0xFFFFC107);
  static const Color cloudy = Color(0xFF9E9E9E);
  static const Color rainy = Color(0xFF2196F3);
  static const Color snowy = Color(0xFFE1F5FE);
  static const Color stormy = Color(0xFF424242);

  // Gradient colors
  static const List<Color> sunnyGradient = [
    Color(0xFFFFA726),
    Color(0xFFFF7043),
  ];

  static const List<Color> cloudyGradient = [
    Color(0xFF78909C),
    Color(0xFF90A4AE),
  ];

  static const List<Color> rainyGradient = [
    Color(0xFF42A5F5),
    Color(0xFF1976D2),
  ];

  static const List<Color> nightGradient = [
    Color(0xFF1A237E),
    Color(0xFF311B92),
  ];
}
