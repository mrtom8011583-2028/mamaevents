import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme/colors.dart';

/// Professional Footer CTA Section - Reusable across multiple screens
class ProfessionalFooterCTA extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String primaryButtonText;
  final String secondaryButtonText;
  final VoidCallback? primaryButtonAction;
  final VoidCallback? secondaryButtonAction;
  final IconData? primaryButtonIcon;
  final IconData? secondaryButtonIcon;

  const ProfessionalFooterCTA({
    super.key,
    this.title = 'Ready to Work Together?',
    this.subtitle = 'Let\'s create something extraordinary for your next event.',
    this.icon = Icons.handshake,
    this.primaryButtonText = 'CONTACT US',
    this.secondaryButtonText = 'VIEW SERVICES',
    this.primaryButtonAction,
    this.secondaryButtonAction,
    this.primaryButtonIcon = Icons.contact_mail,
    this.secondaryButtonIcon = Icons.room_service,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(50),
      decoration: BoxDecoration(
        color: AppColors.logoDeepBlack,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 60,
            color: Colors.white,
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              // Primary Button (Gold)
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.premiumGoldGradient,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.premiumGoldMedium.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: primaryButtonAction ?? () => context.go('/contact'),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (primaryButtonIcon != null) ...[
                            Icon(primaryButtonIcon, color: AppColors.logoDeepBlack),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            primaryButtonText,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                              color: AppColors.logoDeepBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Secondary Button (White Outline)
              OutlinedButton.icon(
                onPressed: secondaryButtonAction ?? () => context.go('/services'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white, width: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: Icon(secondaryButtonIcon),
                label: Text(
                  secondaryButtonText,
                  style: GoogleFonts.inter(
fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
