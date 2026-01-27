import 'package:flutter/material.dart';

/// Breakpoint constants for responsive design
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double largeDesktop = 1800;
}

/// Responsive helper utility class
class ResponsiveHelper {
  /// Check if screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < Breakpoints.mobile;
  }

  /// Check if screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= Breakpoints.mobile && width < Breakpoints.desktop;
  }

  /// Check if screen is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= Breakpoints.desktop;
  }

  /// Check if screen is large desktop
  static bool isLargeDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= Breakpoints.largeDesktop;
  }

  /// Get responsive value based on screen size
  static T getResponsiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    final width = MediaQuery.of(context).size.width;

    if (width >= Breakpoints.largeDesktop && largeDesktop != null) {
      return largeDesktop;
    } else if (width >= Breakpoints.desktop && desktop != null) {
      return desktop;
    } else if (width >= Breakpoints.mobile && tablet != null) {
      return tablet;
    }
    return mobile;
  }

  /// Get horizontal padding based on screen size
  static double getHorizontalPadding(BuildContext context) {
    return getResponsiveValue(
      context,
      mobile: 16.0,
      tablet: 32.0,
      desktop: 48.0,
      largeDesktop: 64.0,
    );
  }

  /// Get grid cross axis count based on screen size
  static int getGridCrossAxisCount(BuildContext context, {int mobileColumns = 1}) {
    return getResponsiveValue(
      context,
      mobile: mobileColumns,
      tablet: mobileColumns * 2,
      desktop: mobileColumns * 3,
      largeDesktop: mobileColumns * 4,
    );
  }

  /// Get max content width for centered layouts
  static double getMaxContentWidth(BuildContext context) {
    return getResponsiveValue(
      context,
      mobile: double.infinity,
      tablet: 900,
      desktop: 1200,
      largeDesktop: 1400,
    );
  }

  /// Get font size multiplier
  static double getFontSizeMultiplier(BuildContext context) {
    return getResponsiveValue(
      context,
      mobile: 1.0,
      tablet: 1.1,
      desktop: 1.2,
    );
  }
}
