import 'package:flutter/material.dart';

/// Responsive utility class for mobile-first design
/// Provides breakpoints, responsive values, and helper methods
class ResponsiveUtils {
  /// Standard breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  /// Get current screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get current screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Check if mobile
  static bool isMobile(BuildContext context) {
    return screenWidth(context) < mobileBreakpoint;
  }

  /// Check if tablet
  static bool isTablet(BuildContext context) {
    final width = screenWidth(context);
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  /// Check if desktop
  static bool isDesktop(BuildContext context) {
    return screenWidth(context) >= desktopBreakpoint;
  }

  /// Get responsive value based on screen size
  static T responsiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) return desktop;
    if (isTablet(context) && tablet != null) return tablet;
    return mobile;
  }

  /// Get responsive padding
  static EdgeInsets responsivePadding(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    final value = responsiveValue(
      context,
      mobile: mobile ?? 16.0,
      tablet: tablet ?? 24.0,
      desktop: desktop ?? 32.0,
    );
    return EdgeInsets.all(value);
  }

  /// Get responsive horizontal padding
  static EdgeInsets responsiveHorizontalPadding(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    final value = responsiveValue(
      context,
      mobile: mobile ?? 16.0,
      tablet: tablet ?? 32.0,
      desktop: desktop ?? 60.0,
    );
    return EdgeInsets.symmetric(horizontal: value);
  }

  /// Get responsive vertical padding
  static EdgeInsets responsiveVerticalPadding(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    final value = responsiveValue(
      context,
      mobile: mobile ?? 16.0,
      tablet: tablet ?? 24.0,
      desktop: desktop ?? 32.0,
    );
    return EdgeInsets.symmetric(vertical: value);
  }

  /// Get responsive font size
  static double responsiveFontSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return responsiveValue(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.2,
      desktop: desktop ?? mobile * 1.5,
    );
  }

  /// Get responsive spacing
  static double responsiveSpacing(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    return responsiveValue(
      context,
      mobile: mobile ?? 16.0,
      tablet: tablet ?? 24.0,
      desktop: desktop ?? 32.0,
    );
  }

  /// Get responsive max width for content containers
  static double responsiveMaxWidth(BuildContext context) {
    return responsiveValue(
      context,
      mobile: screenWidth(context),
      tablet: 900.0,
      desktop: 1200.0,
    );
  }

  /// Get number of columns for grid
  static int responsiveGridColumns(BuildContext context) {
    return responsiveValue(
      context,
      mobile: 1,
      tablet: 2,
      desktop: 3,
    );
  }

  /// Check if portrait orientation
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// Get safe padding (for notches, etc.)
  static EdgeInsets safePadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// Responsive container with max width
  static Widget responsiveContainer({
    required BuildContext context,
    required Widget child,
    double? maxWidth,
    EdgeInsets? padding,
    Color? color,
  }) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? responsiveMaxWidth(context),
        ),
        child: Container(
          width: double.infinity,
          padding: padding ?? responsiveHorizontalPadding(context),
          color: color,
          child: child,
        ),
      ),
    );
  }

  /// Responsive SizedBox
  static SizedBox responsiveHeight(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    return SizedBox(
      height: responsiveValue(
        context,
        mobile: mobile ?? 16.0,
        tablet: tablet ?? 24.0,
        desktop: desktop ?? 32.0,
      ),
    );
  }

  /// Responsive SizedBox width
  static SizedBox responsiveWidth(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    return SizedBox(
      width: responsiveValue(
        context,
        mobile: mobile ?? 16.0,
        tablet: tablet ?? 24.0,
        desktop: desktop ?? 32.0,
      ),
    );
  }
}
