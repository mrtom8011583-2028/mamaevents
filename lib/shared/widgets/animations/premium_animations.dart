import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';

/// Scroll Reveal Animation Widget
/// Animates children when they enter the viewport
/// Features: Fade in, translate up, stagger support
class ScrollReveal extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double offsetY;
  final Curve curve;

  const ScrollReveal({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.offsetY = 40,
    this.curve = Curves.easeOut,
  });

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, widget.offsetY),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    // Start animation after delay
    Future.delayed(widget.delay, () {
      if (mounted && !_isVisible) {
        _isVisible = true;
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: _slideAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Staggered Scroll Reveal for Lists
/// Automatically staggers children by index
class StaggeredScrollReveal extends StatelessWidget {
  final List<Widget> children;
  final Duration baseDuration;
  final Duration staggerDelay;
  final double offsetY;

  const StaggeredScrollReveal({
    super.key,
    required this.children,
    this.baseDuration = const Duration(milliseconds: 600),
    this.staggerDelay = const Duration(milliseconds: 100),
    this.offsetY = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;
        return ScrollReveal(
          duration: baseDuration,
          delay: Duration(milliseconds: staggerDelay.inMilliseconds * index),
          offsetY: offsetY,
          child: child,
        );
      }).toList(),
    );
  }
}

/// Premium Card with Hover Animation
/// Features: Scale, elevation, border color, gold shadow
class AnimatedPremiumCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final double borderRadius;

  const AnimatedPremiumCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 12,
  });

  @override
  State<AnimatedPremiumCard> createState() => _AnimatedPremiumCardState();
}

class _AnimatedPremiumCardState extends State<AnimatedPremiumCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _elevationAnimation = Tween<double>(begin: 2, end: 6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(bool hovering) {
    setState(() => _isHovered = hovering);
    if (hovering) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: widget.padding,
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: Border.all(
                    color: _isHovered
                        ? AppColors.premiumGoldMedium
                        : AppColors.lightGrey,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isHovered
                          ? AppColors.premiumGoldLight.withOpacity(0.1)
                          : Colors.black.withOpacity(0.05),
                      blurRadius: _elevationAnimation.value * 4,
                      offset: Offset(0, _elevationAnimation.value),
                      spreadRadius: _isHovered ? 2 : 0,
                    ),
                  ],
                ),
                child: widget.child,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Pulse Animation Widget
/// For active nav items and badges
class PulseAnimation extends StatefulWidget {
  final Widget child;
  final bool isActive;
  final Duration duration;

  const PulseAnimation({
    super.key,
    required this.child,
    this.isActive = true,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.05),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.05, end: 1.0),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.isActive) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(PulseAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isActive && _controller.isAnimating) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isActive ? _scaleAnimation.value : 1.0,
          child: widget.child,
        );
      },
    );
  }
}

/// Gold Shimmer Loading Placeholder
class GoldShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const GoldShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  State<GoldShimmerLoading> createState() => _GoldShimmerLoadingState();
}

class _GoldShimmerLoadingState extends State<GoldShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_shimmerAnimation.value - 1, 0),
              end: Alignment(_shimmerAnimation.value + 1, 0),
              colors: [
                AppColors.lightGrey,
                AppColors.premiumGoldLight.withOpacity(0.3),
                AppColors.lightGrey,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

/// Gold Loading Spinner
class GoldLoadingSpinner extends StatefulWidget {
  final double size;
  final double strokeWidth;

  const GoldLoadingSpinner({
    super.key,
    this.size = 40,
    this.strokeWidth = 3,
  });

  @override
  State<GoldLoadingSpinner> createState() => _GoldLoadingSpinnerState();
}

class _GoldLoadingSpinnerState extends State<GoldLoadingSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: CircularProgressIndicator(
        strokeWidth: widget.strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.premiumGoldMedium),
        backgroundColor: AppColors.lightGrey,
      ),
    );
  }
}
