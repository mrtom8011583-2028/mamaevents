import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class EntryAnimation extends StatelessWidget {
  final Widget child;
  final int index;
  final Duration duration;
  final double verticalOffset;

  const EntryAnimation({
    super.key,
    required this.child,
    this.index = 0,
    this.duration = const Duration(milliseconds: 500),
    this.verticalOffset = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: duration,
      child: SlideAnimation(
        verticalOffset: verticalOffset,
        child: FadeInAnimation(
          child: child,
        ),
      ),
    );
  }
}

// Simple wrapper for a list that needs AnimationLimiter
class AnimatedListWrapper extends StatelessWidget {
  final Widget child;
  
  const AnimatedListWrapper({super.key, required this.child});
  
  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(child: child);
  }
}
