import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../providers/app_config_provider.dart';
import '../../../config/theme/colors.dart';

class PremiumFooter extends StatelessWidget {
  const PremiumFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final config = context.watch<AppConfigProvider>().config;
    
    return Container(
      color: const Color(0xFF0B0B0B), // Dark background
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Column(
        children: [
          // Main Footer Content
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildCompanyInfo(config)),
                      const SizedBox(width: 40),
                      Expanded(child: _buildQuickLinks(context)),
                      const SizedBox(width: 40),
                      Expanded(child: _buildServices(context)),
                      const SizedBox(width: 40),
                      Expanded(child: _buildContact(config)),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCompanyInfo(config),
                      const SizedBox(height: 40),
                      _buildQuickLinks(context),
                      const SizedBox(height: 40),
                      _buildServices(context),
                      const SizedBox(height: 40),
                      _buildContact(config),
                    ],
                  );
                }
              },
            ),
          ),
          
          const SizedBox(height: 50),
          
          // Social Media
          _buildSocialMedia(),
          
          const SizedBox(height: 40),
          
          // Divider
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.1),
          ),
          
          const SizedBox(height: 30),
          
          // Bottom Bar
          _buildBottomBar(config),
        ],
      ),
    );
  }

  Widget _buildCompanyInfo(config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              config.region.flag,
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(width: 12),
            Text(
              'MAMA EVENTS',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'MAMA EVENTS has been delivering exceptional event experiences across Pakistan since 2015. From weddings to corporate galas, we bring your vision to life with world-class catering, impeccable service, and unforgettable moments.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.white.withOpacity(0.7),
            height: 1.7,
          ),
        ),
        const SizedBox(height: 24),
        
        // Newsletter Signup
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF424242).withOpacity(0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stay Updated',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Subscribe for exclusive offers & event tips',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: GoogleFonts.inter(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Your email',
                        hintStyle: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement newsletter signup
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF212121),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Icon(Icons.arrow_forward, size: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickLinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Links',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        _buildFooterLink(context, 'Home', '/'),
        _buildFooterLink(context, 'About Us', '/about'),
        _buildFooterLink(context, 'Services', '/services'),
        _buildFooterLink(context, 'Menu', '/our-menu'),
        _buildFooterLink(context, 'Gallery', '/gallery'),
        _buildFooterLink(context, 'Contact', '/contact'),
      ],
    );
  }

  Widget _buildServices(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our Services',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        _buildFooterLink(context, 'Wedding Catering', '/services'),
        _buildFooterLink(context, 'Corporate Events', '/services'),
        _buildFooterLink(context, 'Private Parties', '/services'),
        _buildFooterLink(context, 'Live Stations', '/services'),
        _buildFooterLink(context, 'Yacht Catering', '/services'),
        _buildFooterLink(context, 'Event Infrastructure', '/services'),
      ],
    );
  }

  Widget _buildContact(config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Info',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        _buildContactItem(Icons.phone, config.phoneNumber),
        _buildContactItem(Icons.email, config.email),
        _buildContactItem(Icons.location_on, config.countryName),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () async {
            final url = Uri.parse(config.getWhatsAppLink());
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            side: const BorderSide(color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          icon: const Icon(Icons.chat, size: 18),
          label: Text(
            'WhatsApp Us',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterLink(BuildContext context, String text, String route) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.go(route),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: const Color(0xFF5A5A5A),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMedia() {
    return Column(
      children: [
        Text(
          'Follow Us',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialIcon(
              'https://www.facebook.com/freshcatering',
              Icons.facebook,
              Colors.white,
            ),
            const SizedBox(width: 16),
            _buildSocialIcon(
              'https://www.instagram.com/freshcatering',
              Icons.camera_alt,
              Colors.white,
            ),
            const SizedBox(width: 16),
            _buildSocialIcon(
              'https://twitter.com/freshcatering',
              FontAwesomeIcons.xTwitter,
              Colors.white,
            ),
            const SizedBox(width: 16),
            _buildSocialIcon(
              'https://www.linkedin.com/company/freshcatering',
              Icons.business,
              Colors.white,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon(String url, IconData icon, Color color) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.5)),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _buildBottomBar(config) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© ${DateTime.now().year} MAMA EVENTS ${config.countryName}. All rights reserved.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              Row(
                children: [
                  _buildBottomLink(context, 'Privacy Policy', '/privacy'),
                  const SizedBox(width: 20),
                  _buildBottomLink(context, 'Terms of Service', '/terms'),
                ],
              ),
            ],
          );
        } else {
          return Column(
            children: [
              Text(
                '© ${DateTime.now().year} MAMA EVENTS ${config.countryName}.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.5),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'All rights reserved.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBottomLink(context, 'Privacy', '/privacy'),
                  const SizedBox(width: 20),
                  _buildBottomLink(context, 'Terms', '/terms'),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildBottomLink(BuildContext context, String text, String route) {
    return InkWell(
      onTap: () => context.go(route),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: Colors.white.withOpacity(0.5),
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
