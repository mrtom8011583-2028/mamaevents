import 'package:flutter/material.dart';

/// Premium Scroll Physics for Luxury Feel
/// Custom spring physics with smooth deceleration
class PremiumScrollPhysics extends ScrollPhysics {
  const PremiumScrollPhysics({super.parent});

  @override
  PremiumScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return PremiumScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
    mass: 0.5,
    stiffness: 200,
    damping: 22,
  );

  @override
  double get minFlingVelocity => 50.0;

  @override
  double get maxFlingVelocity => 6000.0;

  @override
  double get dragStartDistanceMotionThreshold => 3.5;

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) => true;
}

/// Bouncy Scroll Physics for playful interactions
class BouncyScrollPhysics extends ScrollPhysics {
  const BouncyScrollPhysics({super.parent});

  @override
  BouncyScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return BouncyScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
    mass: 0.4,
    stiffness: 150,
    damping: 18,
  );

  @override
  double frictionFactor(double overscrollFraction) {
    return 0.52 * (1 - overscrollFraction * overscrollFraction);
  }
}

/// Page Transition Builders for Premium Navigation
class PremiumPageTransitions {
  /// Slide from right with fade
  static PageRouteBuilder slideRight({
    required Widget page,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slideAnimation = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ));

        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        ));

        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: child,
          ),
        );
      },
    );
  }

  /// Fade with scale up
  static PageRouteBuilder fadeScale({
    required Widget page,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final scaleAnimation = Tween<double>(
          begin: 0.95,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ));

        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ));

        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: child,
          ),
        );
      },
    );
  }

  /// Shared axis transition (Material Design 3)
  static PageRouteBuilder sharedAxisX({
    required Widget page,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Entering page slides in from right and fades in
        final slideIn = Tween<Offset>(
          begin: const Offset(0.3, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ));

        final fadeIn = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
        ));

        // Exiting page slides out to left and fades out
        final slideOut = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-0.3, 0.0),
        ).animate(CurvedAnimation(
          parent: secondaryAnimation,
          curve: Curves.easeInCubic,
        ));

        final fadeOut = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(CurvedAnimation(
          parent: secondaryAnimation,
          curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
        ));

        return FadeTransition(
          opacity: fadeIn,
          child: SlideTransition(
            position: slideIn,
            child: FadeTransition(
              opacity: fadeOut,
              child: SlideTransition(
                position: slideOut,
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Hero Transition Configuration
class PremiumHeroController {
  /// Create a hero animation controller with gold-themed flight
  static HeroFlightShuttleBuilder goldShuttleBuilder() {
    return (
      BuildContext flightContext,
      Animation<double> animation,
      HeroFlightDirection flightDirection,
      BuildContext fromHeroContext,
      BuildContext toHeroContext,
    ) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOutCubic,
      );

      return AnimatedBuilder(
        animation: curvedAnimation,
        builder: (context, child) {
          return Material(
            color: Colors.transparent,
            child: DefaultTextStyle(
              style: DefaultTextStyle.of(toHeroContext).style,
              child: toHeroContext.widget,
            ),
          );
        },
      );
    };
  }
}

/// Responsive Breakpoints
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double widescreen = 1440;

  /// Check current breakpoint
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobile;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < desktop;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktop;

  /// Get responsive value based on breakpoint
  static T responsive<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= Breakpoints.desktop) {
      return desktop ?? tablet ?? mobile;
    } else if (width >= Breakpoints.mobile) {
      return tablet ?? mobile;
    }
    return mobile;
  }

  /// Get responsive grid columns
  static int gridColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktop) return 4;
    if (width >= tablet) return 3;
    if (width >= mobile) return 2;
    return 1;
  }
}
