import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';

/// Secondary button component - Outlined with transparent background
class SecondaryButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double? height;
  final double borderRadius;
  final Color? borderColor;
  final Color? textColor;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
    this.borderRadius = 0,
    this.borderColor,
    this.textColor,
  });

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.borderColor ?? AppColors.luxuryBlack;
    final textColor = widget.textColor ?? AppColors.luxuryBlack;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.width,
        height: widget.height ?? 56,
        decoration: BoxDecoration(
          color: _isHovered
              ? borderColor.withOpacity(0.05)
              : Colors.transparent,
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.isLoading ? null : widget.onPressed,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(textColor),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            color: textColor,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                        ],
                        Text(
                          widget.text,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                            letterSpacing: 0.5,
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
