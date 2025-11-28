import 'package:flutter/material.dart';

/// Responsive utility class for breakpoints and adaptive layouts
class Responsive {
  /// Mobile breakpoint (< 600px)
  static const double mobile = 600;

  /// Tablet breakpoint (600px - 1200px)
  static const double tablet = 1200;

  /// Desktop breakpoint (> 1200px)
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
    if (isDesktop(context)) return 1.8;
    if (isTablet(context)) return 1.6;
    return 1.5;
  }

  /// Get padding based on screen size
  static double getPadding(BuildContext context) {
    if (isDesktop(context)) return 32.0;
    if (isTablet(context)) return 24.0;
    return 16.0;
  }

  /// Get horizontal margin for content
  static double getHorizontalMargin(BuildContext context) {
    if (isDesktop(context)) {
      return MediaQuery.of(context).size.width * 0.15;
    }
    if (isTablet(context)) {
      return MediaQuery.of(context).size.width * 0.08;
    }
    return 0;
  }
}
