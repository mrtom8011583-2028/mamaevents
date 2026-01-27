import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/models/region.dart';
import '../../../core/utils/url_launcher_helper.dart';
import '../../../core/services/analytics_service.dart';

/// WhatsApp CTA button for contacting via WhatsApp
class WhatsAppButton extends StatefulWidget {
  final Region region;
  final String? customMessage;
  final String? buttonText;
  final bool isFloating;
  final EdgeInsets? padding;

  const WhatsAppButton({
    super.key,
    required this.region,
    this.customMessage,
    this.buttonText,
    this.isFloating = false,
    this.padding,
  });

  @override
  State<WhatsAppButton> createState() => _WhatsAppButtonState();
}

class _WhatsAppButtonState extends State<WhatsAppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final AnalyticsService _analytics = AnalyticsService();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    // Track analytics
    _analytics.trackWhatsAppClick(widget.region);

    // Open WhatsApp
    final success = await UrlLauncherHelper.openWhatsApp(
      widget.region,
      customMessage: widget.customMessage,
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open WhatsApp. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isFloating) {
      return _buildFloatingButton();
    }
    return _buildInlineButton();
  }

  Widget _buildFloatingButton() {
    return Positioned(
      bottom: 24,
      right: 24,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FloatingActionButton.extended(
          onPressed: () {
            _controller.forward().then((_) => _controller.reverse());
            _handleTap();
          },
          backgroundColor: const Color(0xFF25D366),
          icon: const FaIcon(
            FontAwesomeIcons.whatsapp,
            color: Colors.white,
          ),
          label: Text(
            widget.buttonText ?? 'Chat with us',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          elevation: 8,
        ),
      ),
    );
  }

  Widget _buildInlineButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          _handleTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: widget.padding ??
                const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF25D366),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF25D366).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FaIcon(
                  FontAwesomeIcons.whatsapp,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  widget.buttonText ?? 'WhatsApp Us',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
