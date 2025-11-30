import 'package:flutter/material.dart';

/// Responsive utility class for breakpoints and adaptive layouts
class Responsive {
  /// Mobile breakpoint (< 600px)
  static const double mobile = 600;

  /// Tablet breakpoint (600px - 1100px)
  static const double tablet = 1100;

  /// Desktop breakpoint (> 1100px)
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobile;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobile &&
      MediaQuery.of(context).size.width < tablet;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tablet;

  /// Get number of grid columns based on screen size
  static int getGridColumns(BuildContext context) {
    if (isDesktop(context)) return 4;
    if (isTablet(context)) return 3;
    return 2;
  }

  /// Get child aspect ratio for grid items based on screen size
  static double getGridChildAspectRatio(BuildContext context) {
    if (isDesktop(context)) return 1.6;
    if (isTablet(context)) return 1.4;
    return 1.3; // Optimized for mobile
  }

  /// Get padding based on screen size
  static double getPadding(BuildContext context) {
    if (isDesktop(context)) return 40.0;
    if (isTablet(context)) return 32.0;
    return 16.0;
  }

  /// Get horizontal margin for content to center it on large screens
  static double getHorizontalMargin(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (isDesktop(context)) {
      return width * 0.2; // 20% margin on each side
    }
    if (isTablet(context)) {
      return width * 0.1; // 10% margin on each side
    }
    return 0;
  }

  /// Get title font size based on screen size
  static double getTitleFontSize(BuildContext context) {
    if (isDesktop(context)) return 48.0;
    if (isTablet(context)) return 36.0;
    return 28.0;
  }
}
