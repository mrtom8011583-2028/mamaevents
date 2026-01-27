import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme/colors.dart';

class PremiumNavLink extends StatefulWidget {
  final String label;
  final String path;

  const PremiumNavLink({
    super.key,
    required this.label,
    required this.path,
  });

  @override
  State<PremiumNavLink> createState() => _PremiumNavLinkState();
}

class _PremiumNavLinkState extends State<PremiumNavLink> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    // Slide up by 2px max
    _slideAnimation = Tween<double>(begin: 0, end: -2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouter.of(context).routeInformationProvider.value.uri.path;
    final isActive = currentPath == widget.path;

    // Mobile/Tablet check handled by parent, but extra safety:
    // This widget assumes it's on desktop mainly.

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: GestureDetector(
        onTap: () => context.go(widget.path),
        child: Container(
          color: Colors.transparent, // Hit test target
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _slideAnimation.value),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.label,
                      style: GoogleFonts.inter(
                        color: _isHovered || isActive 
                            ? AppColors.primaryGold 
                            : const Color(0xFF424242), // Dark neutral
                        fontSize: 15,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Underline
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 2,
                      width: isActive || _isHovered ? 20 : 0,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGold,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
