import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../providers/app_config_provider.dart';
import '../../../widgets/advanced_quote_request_form.dart';
import '../../../config/theme/colors.dart';
import '../animations/hover_scale_animation.dart';

import '../navigation/premium_nav_link.dart';

/// Clean Working Custom App Bar - Reverted to Stable Version
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showActions;
  
  const CustomAppBar({
    super.key,
    this.title,
    this.showActions = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(120);

  @override
  Widget build(BuildContext context) {
    final configProvider = context.watch<AppConfigProvider>();
    final config = configProvider.config;
    final isDesktop = MediaQuery.of(context).size.width > 1000;

    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // TOP BAR
          // TOP BAR
          Container(
            height: 40,
            color: AppColors.logoDeepBlack,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Hide contact info on small mobile screens
                if (MediaQuery.of(context).size.width > 600) ...[
                  InkWell(
                    onTap: () async {
                      final uri = Uri(
                        scheme: 'tel',
                        path: config.phoneNumber.replaceAll(' ', ''),
                      );
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.platformDefault);
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.phone, color: Colors.white, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          config.phoneNumber,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  InkWell(
                    onTap: () async {
                      final uri = Uri(
                        scheme: 'mailto',
                        path: config.email,
                      );
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.platformDefault);
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.email, color: Colors.white, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          config.email,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const Spacer(),
                InkWell(
                  onTap: () async {
                    final uri = Uri.parse(config.getWhatsAppLink(message: 'Hello!'));
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          'WhatsApp',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // MAIN NAVIGATION BAR
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  // 1. LEFT: LOGO
                  Expanded(
                    flex: isDesktop ? 2 : 4, // Adjust flex to ensure branding is visible
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () => context.go('/'),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0.5, end: 1.0),
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.elasticOut,
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Opacity(
                                opacity: value.clamp(0.0, 1.0),
                                child: child,
                              ),
                            );
                          },
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 90,
                            errorBuilder: (context, error, stackTrace) {
                              return Text(
                                'MAMA EVENTS',
                                style: GoogleFonts.inter(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.logoDeepBlack,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // 2. CENTER: DESKTOP NAVIGATION
                  if (isDesktop)
                    Expanded(
                      flex: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const PremiumNavLink(label: 'Home', path: '/'),
                          const PremiumNavLink(label: 'About', path: '/about'),
                          const PremiumNavLink(label: 'Services', path: '/services'),
                          const PremiumNavLink(label: 'Menu', path: '/our-menu'),
                          const PremiumNavLink(label: 'Gallery', path: '/gallery'),
                          const PremiumNavLink(label: 'Contact', path: '/contact'),
                        ],
                      ),
                    ),

                  // 3. RIGHT: CTA & MOBILE MENU
                  Expanded(
                    flex: isDesktop ? 2 : 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (isDesktop) ...[
                          HoverScaleAnimation(
                            child: ElevatedButton(
                              // Desktop Button
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.logoDeepBlack,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0), // Sharp Premium Look
                                  side: const BorderSide(color: AppColors.primaryGold, width: 1),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'GET QUOTE',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  letterSpacing: 1.0,
                                  color: AppColors.primaryGold,
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          IconButton(
                            icon: const Icon(Icons.menu, size: 28),
                            onPressed: () => _showMobileMenu(context),
                            color: AppColors.logoDeepBlack,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              // Use standard links for mobile menu
              _buildMobileNavItem(context, 'Home', '/'),
              _buildMobileNavItem(context, 'About', '/about'),
              _buildMobileNavItem(context, 'Services', '/services'),
              _buildMobileNavItem(context, 'Menu', '/our-menu'),
              _buildMobileNavItem(context, 'Gallery', '/gallery'),
              _buildMobileNavItem(context, 'Contact', '/contact'),
              const SizedBox(height: 20),
             Container(
               width: double.infinity,
               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
               child: ElevatedButton(
                 onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        backgroundColor: Colors.white,
                        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 900, maxHeight: 800),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: AdvancedQuoteRequestForm(
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
                 style: ElevatedButton.styleFrom(
                   backgroundColor: AppColors.logoDeepBlack,
                   foregroundColor: Colors.white,
                   padding: const EdgeInsets.symmetric(vertical: 16),
                 ),
                 child: const Text('GET QUOTE'),
               ),
             ),
             const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileNavItem(BuildContext context, String label, String path) {
    return ListTile(
      title: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        context.go(path);
      },
      trailing: const Icon(Icons.chevron_right, size: 16),
    );
  }
}
