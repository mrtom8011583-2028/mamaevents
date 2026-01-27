import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/theme/colors.dart';

/// Premium Gold Gradient Button
/// Uses the exact gold gradient from the MAMA EVENTS brand specification
/// Includes smooth hover animations and professional styling
class GoldButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isOutlined;
  final double? width;
  final double height;

  const GoldButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isOutlined = false,
    this.width,
    this.height = 56,
  });

  @override
  State<GoldButton> createState() => _GoldButtonState();
}

class _GoldButtonState extends State<GoldButton> 
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHover(bool hovering) {
    setState(() => _isHovered = hovering);
    if (hovering) {
      _animationController.forward();
    } else {
      _animationController.reverse();
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
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: _isHovered 
                ? AppColors.goldHoverGradient 
                : AppColors.premiumGoldGradient,
            borderRadius: BorderRadius.circular(4), // Sharp, architectural
            boxShadow: [
              BoxShadow(
                color: AppColors.premiumGoldMedium.withOpacity(_isHovered ? 0.5 : 0.3),
                blurRadius: _isHovered ? 20 : 12,
                offset: const Offset(0, 4),
                spreadRadius: _isHovered ? 2 : 0,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              borderRadius: BorderRadius.circular(4),
              splashColor: Colors.white.withOpacity(0.2),
              highlightColor: Colors.white.withOpacity(0.1),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        color: AppColors.logoDeepBlack,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                    ],
                    Text(
                      widget.label,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.logoDeepBlack,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOutlinedButton() {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      cursor: SystemMouseCursors.click,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: _isHovered 
                ? AppColors.premiumGoldMedium.withOpacity(0.1) 
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: _isHovered 
                  ? AppColors.goldGradientStart 
                  : AppColors.premiumGoldMedium,
              width: 1.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              borderRadius: BorderRadius.circular(4),
              splashColor: AppColors.premiumGoldMedium.withOpacity(0.2),
              highlightColor: AppColors.premiumGoldMedium.withOpacity(0.1),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        color: _isHovered 
                            ? AppColors.goldGradientStart 
                            : AppColors.premiumGoldMedium,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                    ],
                    Text(
                      widget.label,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _isHovered 
                            ? AppColors.goldGradientStart 
                            : AppColors.premiumGoldMedium,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Premium Dark Button with subtle styling
class DarkButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final double? width;
  final double height;

  const DarkButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.width,
    this.height = 56,
  });

  @override
  State<DarkButton> createState() => _DarkButtonState();
}

class _DarkButtonState extends State<DarkButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: _isHovered 
              ? AppColors.logoCharcoalGrey 
              : AppColors.logoDeepBlack,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: _isHovered 
                ? AppColors.mediumGrey.withOpacity(0.3) 
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(4),
            splashColor: Colors.white.withOpacity(0.1),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      color: AppColors.logoSilverWhite,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    widget.label,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.logoSilverWhite,
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
  }
}
