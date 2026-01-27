import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/theme/colors.dart';

/// Premium Golden Button with Micro-Interactions
/// Features: Press animation, gold ripple, haptic feedback, hover glow
class GoldenButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLarge;
  final bool isOutlined;
  final IconData? icon;
  final double? width;

  const GoldenButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLarge = false,
    this.isOutlined = false,
    this.icon,
    this.width,
  });

  @override
  State<GoldenButton> createState() => _GoldenButtonState();
}

class _GoldenButtonState extends State<GoldenButton>
    with TickerProviderStateMixin {
  bool _isPressed = false;
  bool _isHovered = false;
  
  late AnimationController _pressController;
  late AnimationController _hoverController;
  late AnimationController _shimmerController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    
    // Press Animation Controller (100ms in, 200ms out with overshoot)
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeIn),
    );
    
    // Hover Animation Controller
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _elevationAnimation = Tween<double>(begin: 4, end: 8).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );
    
    // Shimmer Animation (continuous)
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    _hoverController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _pressController.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _pressController.reverse().then((_) {
      // Overshoot animation on release
      _pressController.animateTo(0.0, curve: Curves.elasticOut);
    });
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _pressController.reverse();
  }

  void _onHover(bool hovering) {
    setState(() => _isHovered = hovering);
    if (hovering) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isOutlined) {
      return _buildOutlinedButton();
    }
    return _buildFilledButton();
  }

  Widget _buildFilledButton() {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pressController, _hoverController, _shimmerController]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              decoration: BoxDecoration(
                gradient: AppColors.premiumGoldGradient,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.premiumGoldLight.withOpacity(
                      _isHovered ? 0.5 : 0.3,
                    ),
                    blurRadius: _elevationAnimation.value * 2,
                    offset: Offset(0, _elevationAnimation.value / 2),
                    spreadRadius: _isHovered ? 2 : 0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    // Base Button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTapDown: _onTapDown,
                        onTapUp: _onTapUp,
                        onTapCancel: _onTapCancel,
                        splashColor: AppColors.premiumGoldLight.withOpacity(0.5),
                        highlightColor: AppColors.goldGradientStart.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: widget.isLarge ? 40 : 24,
                            vertical: widget.isLarge ? 18 : 14,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (widget.icon != null) ...[
                                Icon(
                                  widget.icon,
                                  color: AppColors.logoDeepBlack,
                                  size: widget.isLarge ? 22 : 18,
                                ),
                                SizedBox(width: widget.isLarge ? 12 : 8),
                              ],
                              Text(
                                widget.text,
                                style: GoogleFonts.inter(
                                  color: AppColors.logoDeepBlack,
                                  fontSize: widget.isLarge ? 16 : 14,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    // Gold Shimmer Effect
                    if (_isHovered)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Transform.translate(
                            offset: Offset(_shimmerAnimation.value * 150, 0),
                            child: Container(
                              width: 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.0),
                                    Colors.white.withOpacity(0.3),
                                    Colors.white.withOpacity(0.0),
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOutlinedButton() {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pressController, _hoverController]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.width,
              decoration: BoxDecoration(
                color: _isHovered
                    ? AppColors.premiumGoldMedium.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isHovered
                      ? AppColors.goldGradientStart
                      : AppColors.premiumGoldMedium,
                  width: 1.5,
                ),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: AppColors.premiumGoldLight.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTapDown: _onTapDown,
                  onTapUp: _onTapUp,
                  onTapCancel: _onTapCancel,
                  splashColor: AppColors.premiumGoldMedium.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.isLarge ? 40 : 24,
                      vertical: widget.isLarge ? 18 : 14,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            color: _isHovered
                                ? AppColors.goldGradientStart
                                : AppColors.premiumGoldMedium,
                            size: widget.isLarge ? 22 : 18,
                          ),
                          SizedBox(width: widget.isLarge ? 12 : 8),
                        ],
                        Text(
                          widget.text,
                          style: GoogleFonts.inter(
                            color: _isHovered
                                ? AppColors.goldGradientStart
                                : AppColors.premiumGoldMedium,
                            fontSize: widget.isLarge ? 16 : 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
