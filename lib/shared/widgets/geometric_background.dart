import 'package:flutter/material.dart';

/// A subtle geometric pattern background mimicking the stacked 'M' logo structure.
/// Uses repeated chevron shapes (`/\`) in a grid.
class GeometricBackground extends StatelessWidget {
  final Widget child;
  final bool isDark;
  final double patternOpacity;

  const GeometricBackground({
    super.key,
    required this.child,
    this.isDark = false,
    this.patternOpacity = 0.03, // Very subtle
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ChevronPatternPainter(
        color: isDark ? Colors.white : Colors.black,
        opacity: patternOpacity,
      ),
      child: child,
    );
  }
}

class _ChevronPatternPainter extends CustomPainter {
  final Color color;
  final double opacity;

  _ChevronPatternPainter({
    required this.color,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const double spacing = 40.0;
    const double height = 20.0;
    
    // Draw repeating chevrons
    for (double y = 0; y < size.height + height; y += height * 1.5) {
      // Offset every other row for a brick/mesh look
      // double xOffset = (y / (height * 1.5)) % 2 == 0 ? 0 : spacing / 2;
      double xOffset = 0; // Stacked directly aligns better with "Stacked M"

      for (double x = -spacing; x < size.width + spacing; x += spacing) {
        final path = Path();
        // M shape or Chevron? "Stacked chevrons"
        // Draw /\
        path.moveTo(x + xOffset, y + height);
        path.lineTo(x + xOffset + spacing / 2, y);
        path.lineTo(x + xOffset + spacing, y + height);
        
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
