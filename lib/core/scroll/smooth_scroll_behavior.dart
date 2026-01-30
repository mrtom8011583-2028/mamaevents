import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'smooth_scroll_physics.dart';

/// Global high-performance scroll behavior for 90-120 FPS scrolling
/// Automatically applies platform-adaptive physics and rendering optimizations
/// Compatible with Impeller rendering engine for jank-free performance
class HighPerformanceScrollBehavior extends MaterialScrollBehavior {
  const HighPerformanceScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // Platform-adaptive physics for optimal performance
    switch (getPlatform(context)) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        // Mobile: Use ClampingPhysics to prevent "jiggle"/bounce
        return const ClampingScrollPhysics();
      
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        // Desktop: Precise clamping physics for mouse/trackpad
        return const DesktopOptimizedScrollPhysics();
    }
  }

  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    // Platform-adaptive scrollbar with smooth tracking
    // Optimized for high refresh rate displays
    switch (getPlatform(context)) {
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return Scrollbar(
          controller: details.controller,
          thumbVisibility: false, // Auto-hide for clean aesthetics
          thickness: 8.0,
          radius: const Radius.circular(4.0),
          interactive: true, // Enable drag-to-scroll
          child: child,
        );
      
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        // Mobile platforms use native scrollbar indicators
        return child;
    }
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // Remove all overscroll glow/stretch effects for a clean, professional feel
    return child;
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
    // Support all input devices for universal scrolling
    PointerDeviceKind.touch,      // Mobile touch
    PointerDeviceKind.mouse,      // Desktop mouse
    PointerDeviceKind.stylus,     // Stylus/pen input
    PointerDeviceKind.trackpad,   // Laptop trackpad
    PointerDeviceKind.invertedStylus, // Apple Pencil eraser
    PointerDeviceKind.unknown,    // Future-proof for new devices
  };


  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    // Viewport chrome optimized for Impeller rendering
    // Minimal overhead for maximum FPS
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        // iOS-style chrome with stretch effect
        return child;
      
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        // Material-style chrome
        return child;
    }
  }

  /// Helper method to check if running on high-refresh-rate display
  /// Can be used for additional optimizations
  static bool isHighRefreshRate(BuildContext context) {
    // Check if device supports 90Hz+ displays
    final double refreshRate = WidgetsBinding.instance.platformDispatcher.displays.first.refreshRate;
    return refreshRate >= 90.0;
  }

  /// Helper method to get optimal cache extent based on platform
  /// Improves performance by preloading off-screen content
  static double getOptimalCacheExtent(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        // Mobile: Smaller cache for memory efficiency
        return 250.0;
      
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        // Desktop: Larger cache for smoother scrolling
        return 500.0;
    }
  }
}
