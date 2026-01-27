import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AnimatedStatCard extends StatefulWidget {
  final int endValue;
  final String label;
  final IconData icon;
  final String suffix;

  const AnimatedStatCard({
    super.key,
    required this.endValue,
    required this.label,
    required this.icon,
    this.suffix = '',
  });

  @override
  State<AnimatedStatCard> createState() => _AnimatedStatCardState();
}

class _AnimatedStatCardState extends State<AnimatedStatCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _countAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    
    _countAnimation = IntTween(begin: 0, end: widget.endValue).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ValueKey('stat_${widget.endValue}_${widget.label}'),
      onVisibilityChanged: (info) {
        if (!_hasAnimated && info.visibleFraction > 0.1) {
          _hasAnimated = true;
          if (mounted) {
            _controller.forward();
          }
        }
      },
      child: AnimatedBuilder(
        animation: _countAnimation,
        builder: (context, child) {
          return Container(
            width: 250,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
              boxShadow: [
                 BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, size: 40, color: const Color(0xFF212121)),
                const SizedBox(height: 16),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${_formatNumber(_countAnimation.value)}${widget.suffix}',
                    style: GoogleFonts.inter(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF212121),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.label,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: const Color(0xFF616161),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatNumber(int num) {
    if (num >= 1000) {
      return num.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
    }
    return num.toString();
  }
}
