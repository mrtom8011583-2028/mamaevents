import 'package:flutter/material.dart';

/// Responsive Utility Class for MAMA EVENTS
/// Handles text scaling, spacing, and breakpoints across all devices
class ResponsiveHelper {
  final BuildContext context;
  
  ResponsiveHelper(this.context);
  
  /// Get screen width
  double get screenWidth => MediaQuery.of(context).size.width;
  
  /// Get screen height
  double get screenHeight => MediaQuery.of(context).size.height;
  
  /// Device type detection
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 900;
  bool get isDesktop => screenWidth >= 900;
  bool get isSmallMobile => screenWidth < 375;
  
  /// Responsive text scaling
  /// Automatically scales text based on screen size
  double responsiveText(double mobileSize, {double? tabletSize, double? desktopSize}) {
    if (isDesktop) return desktopSize ?? (mobileSize * 1.5);
    if (isTablet) return tabletSize ?? (mobileSize * 1.25);
    if (isSmallMobile) return mobileSize * 0.9; // Slightly smaller on very small screens
    return mobileSize;
  }
  
  /// Responsive spacing
  double responsiveSpacing(double baseSpacing) {
    if (isDesktop) return baseSpacing * 1.5;
    if (isTablet) return baseSpacing * 1.25;
    if (isSmallMobile) return baseSpacing * 0.8;
    return baseSpacing;
  }
  
  /// Responsive padding (horizontal)
  double get horizontalPadding {
    if (isDesktop) return 80;
    if (isTablet) return 40;
    if (isSmallMobile) return 16;
    return 24;
  }
  
  /// Responsive padding (vertical)
  double get verticalPadding {
    if (isDesktop) return 60;
    if (isTablet) return 40;
    return 24;
  }
  
  /// Responsive grid columns
  int get gridColumns {
    if (isDesktop) return 3;
    if (isTablet) return 2;
    return 1;
  }
  
  /// Responsive card width
  double get cardWidth {
    if (isDesktop) return 400;
    if (isTablet) return screenWidth * 0.45;
    return screenWidth - 48; // Full width with padding on mobile
  }
  
  /// Safe margin (prevents overflow)
  double get safeMargin => isMobile ? 16 : 24;
  
  /// Maximum content width (for readability)
  double get maxContentWidth {
    if (isDesktop) return 1200;
    if (isTablet) return 900;
    return screenWidth;
  }
}

/// Extension for easy access
extension ResponsiveContext on BuildContext {
  ResponsiveHelper get responsive => ResponsiveHelper(this);
}

/// Preset Text Styles with Responsive Sizing
class ResponsiveText {
  final BuildContext context;
  
  ResponsiveText(this.context);
  
  ResponsiveHelper get _r => ResponsiveHelper(context);
  
  /// Display - Largest text (Hero titles)
  double get display => _r.responsiveText(
    40,  // Mobile
    tabletSize: 56,
    desktopSize: 72,
  );
  
  /// H1 - Main headings
  double get h1 => _r.responsiveText(
    32,  // Mobile (increased from typical 28)
    tabletSize: 42,
    desktopSize: 56,
  );
  
  /// H2 - Section headings
  double get h2 => _r.responsiveText(
    26,  // Mobile (increased from typical 22)
    tabletSize: 32,
    desktopSize: 42,
  );
  
  /// H3 - Sub-headings
  double get h3 => _r.responsiveText(
    22,  // Mobile (increased from typical 18)
    tabletSize: 26,
    desktopSize: 32,
  );
  
  /// H4 - Small headings
  double get h4 => _r.responsiveText(
    18,  // Mobile (increased from typical 16)
    tabletSize: 20,
    desktopSize: 24,
  );
  
  /// Body - Paragraphs
  double get body => _r.responsiveText(
    16,  // Mobile (increased from typical 14)
    tabletSize: 17,
    desktopSize: 18,
  );
  
  /// Body Large - Important paragraphs
  double get bodyLarge => _r.responsiveText(
    18,  // Mobile
    tabletSize: 19,
    desktopSize: 20,
  );
  
  /// Caption - Small text
  double get caption => _r.responsiveText(
    14,  // Mobile (increased from typical 12)
    tabletSize: 15,
    desktopSize: 16,
  );
  
  /// Button - Button text
  double get button => _r.responsiveText(
    16,  // Mobile (increased for tap targets)
    tabletSize: 17,
    desktopSize: 18,
  );
}

/// Extension for text
extension ResponsiveTextContext on BuildContext {
  ResponsiveText get text => ResponsiveText(this);
}

/// Responsive spacing constants
class Spacing {
  /// Extra small: 4-8px
  static double xs(BuildContext context) => context.responsive.isMobile ? 4 : 8;
  
  /// Small: 8-12px
  static double sm(BuildContext context) => context.responsive.isMobile ? 8 : 12;
  
  /// Medium: 16-24px
  static double md(BuildContext context) => context.responsive.isMobile ? 16 : 24;
  
  /// Large: 24-32px
  static double lg(BuildContext context) => context.responsive.isMobile ? 24 : 32;
  
  /// Extra large: 32-48px
  static double xl(BuildContext context) => context.responsive.isMobile ? 32 : 48;
  
  /// Extra extra large: 48-64px
  static double xxl(BuildContext context) => context.responsive.isMobile ? 48 : 64;
}

/// Breakpoint constants
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double largeDesktop = 1440;
  
  /// Check if current width matches breakpoint
  static bool isMobile(BuildContext context) => 
    MediaQuery.of(context).size.width < mobile;
  
  static bool isTablet(BuildContext context) => 
    MediaQuery.of(context).size.width >= mobile && 
    MediaQuery.of(context).size.width < desktop;
  
  static bool isDesktop(BuildContext context) => 
    MediaQuery.of(context).size.width >= desktop;
}
