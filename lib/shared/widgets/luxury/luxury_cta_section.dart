import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/theme/colors.dart';
import '../../../widgets/advanced_quote_request_form.dart';
import '../../../providers/app_config_provider.dart';

class LuxuryCTASection extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<CTAButtonType> buttonTypes;
  final String? packageName;
  final double? basePricePerHead;

  const LuxuryCTASection({
    super.key,
    this.title = 'Ready to Plan Your Event?',
    this.subtitle = 'Get a customized quote tailored to your specific needs and budget.',
    this.icon = Icons.event_available,
    this.buttonTypes = const [CTAButtonType.quote],
    this.packageName,
    this.basePricePerHead,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 40 : 80),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: isMobile ? 48 : 64,
            color: const Color(0xFFD4AF37),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: GoogleFonts.playfairDisplay(
              fontSize: isMobile ? 28 : 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: isMobile ? 14 : 18,
                color: Colors.grey[400],
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 24,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: buttonTypes.map((type) => _buildButton(context, type)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, CTAButtonType type) {
    switch (type) {
      case CTAButtonType.quote:
        return _GoldSolidButton(
          label: 'REQUEST A QUOTE',
          icon: Icons.request_quote,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                backgroundColor: Colors.white,
                insetPadding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width < 600 ? 16 : 40,
                  vertical: 24
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900, maxHeight: 800),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AdvancedQuoteRequestForm(
                      packageName: packageName,
                      basePricePerHead: basePricePerHead,
                      onSuccess: () {
                         Navigator.pop(context);
                         ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(
                             content: Text('Quote request submitted successfully!'),
                             backgroundColor: Color(0xFF059669),
                           ),
                         );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        );
      case CTAButtonType.menu:
        return _GoldOutlineButton(
          label: 'VIEW MENU',
          icon: Icons.restaurant_menu,
          onPressed: () => context.push('/our-menu'),
        );
      case CTAButtonType.gallery:
        return _GoldOutlineButton(
          label: 'VIEW GALLERY',
          icon: Icons.photo_library,
          onPressed: () => context.push('/gallery'),
        );
      case CTAButtonType.contact:
        return _GoldOutlineButton(
          label: 'CONTACT US',
          icon: Icons.contact_support,
          onPressed: () => context.push('/contact'),
        );
      case CTAButtonType.services:
        return _GoldOutlineButton(
          label: 'VIEW SERVICES',
          icon: Icons.room_service,
          onPressed: () => context.push('/services'),
        );
      case CTAButtonType.whatsapp:
        return _GoldOutlineButton(
          label: 'WHATSAPP US',
          icon: Icons.chat,
          onPressed: () async {
            final config = context.read<AppConfigProvider>().config;
            final whatsappUrl = Uri.parse(
              config.getWhatsAppLink(
                message: 'Hi! I\'m interested in your services${packageName != null ? ' ($packageName)' : ''}. Can you provide more details?',
              ),
            );
            if (await canLaunchUrl(whatsappUrl)) {
              await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
            }
          },
        );
    }
  }
}

enum CTAButtonType { quote, menu, gallery, contact, services, whatsapp }

class _GoldSolidButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _GoldSolidButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFC9B037), Color(0xFFAA9225)],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC9B037).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}

class _GoldOutlineButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _GoldOutlineButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.5), width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: const Color(0xFFD4AF37),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
