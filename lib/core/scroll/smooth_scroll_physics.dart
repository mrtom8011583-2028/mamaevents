import 'package:flutter/foundation.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

/// High-performance scroll physics optimized for 90-120 FPS on mobile platforms
/// Uses enhanced bouncing physics with tuned parameters for fluid overscroll
class MobileOptimizedScrollPhysics extends BouncingScrollPhysics {
  const MobileOptimizedScrollPhysics({super.parent});

  @override
  MobileOptimizedScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return MobileOptimizedScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
    // Tuned for fluid mobile scrolling at 120 FPS
    mass: 0.25,         // Lower mass = more responsive (reduced from default 0.5)
    stiffness: 150.0,   // Higher stiffness = snappier response (increased from 100)
    damping: 0.8,       // Lower damping = smoother deceleration (reduced from 1.0)
  );

  @override
  double get minFlingDistance => 25.0; // Increased sensitivity for 120Hz displays

  @override
  double get minFlingVelocity => 50.0; // Lower threshold for smooth start

  @override
  double get maxFlingVelocity => 10000.0; // Higher cap for fast flings

  @override
  Tolerance toleranceFor(ScrollMetrics metrics) {
    return Tolerance(
      // Ultra-precise for high refresh rate displays
      velocity: 0.025,  // Very sensitive to velocity changes
      distance: 0.0005, // Sub-pixel precision
    );
  }

  @override
  double carriedMomentum(double existingVelocity) {
    // Preserve 97% of momentum for fluid scrolling
    return existingVelocity * 0.97;
  }

  @override
  double get dragStartDistanceMotionThreshold => 2.0; // Instant response

  @override
  bool get allowImplicitScrolling => true;

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // Apply minimal friction for buttery smooth scrolling
    return offset * 1.0;
  }
}

/// High-performance scroll physics optimized for desktop platforms
/// Uses precise clamping physics tuned for mouse-wheel and trackpad
class DesktopOptimizedScrollPhysics extends ClampingScrollPhysics {
  const DesktopOptimizedScrollPhysics({super.parent});

  @override
  DesktopOptimizedScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return DesktopOptimizedScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
    // Optimized for precise desktop scrolling
    mass: 0.2,          // Very responsive for trackpad/mouse
    stiffness: 180.0,   // High stiffness for precise control
    damping: 0.85,      // Smooth but controlled deceleration
  );

  @override
  double get minFlingVelocity => 30.0; // Very sensitive for trackpad

  @override
  double get maxFlingVelocity => 12000.0; // Support fast mouse wheel scrolling

  @override
  Tolerance toleranceFor(ScrollMetrics metrics) {
    return Tolerance(
      // Pixel-perfect precision for desktop
      velocity: 0.01,   // Extremely sensitive
      distance: 0.0001, // Sub-pixel perfect
    );
  }

  @override
  double carriedMomentum(double existingVelocity) {
    // Preserve 98% of momentum for desktop smoothness
    return existingVelocity * 0.98;
  }

  @override
  double get dragStartDistanceMotionThreshold => 1.5; // Immediate response

  @override
  bool get allowImplicitScrolling => true; // Enable keyboard navigation

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // Zero friction for desktop precision
    return offset * 1.0;
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    final Tolerance tolerance = toleranceFor(position);
    
    // Enhanced simulation for desktop smooth scrolling
    if (velocity.abs() >= tolerance.velocity || position.outOfRange) {
      return ClampingScrollSimulation(
        position: position.pixels,
        velocity: velocity,
        tolerance: tolerance,
      );
    }
    return null;
  }
}
