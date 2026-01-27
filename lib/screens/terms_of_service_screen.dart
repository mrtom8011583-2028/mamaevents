import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme/colors.dart';
import '../shared/widgets/app_bar/custom_app_bar.dart';
import '../shared/widgets/footer/premium_footer.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: ListView(
        children: [
          _buildHeader(),
          _buildContent(),
          const PremiumFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      decoration: const BoxDecoration(
        color: AppColors.logoDeepBlack,
      ),
      child: Column(
        children: [
          Text(
            'TERMS OF SERVICE',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.premiumGoldMedium,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Agreement & Guidelines',
            style: GoogleFonts.inter(
              fontSize: 42,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              gradient: AppColors.premiumGoldGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                '1. Acceptance of Terms',
                'By accessing our website and using MAMA EVENTS services, you agree to comply with and be bound by these Terms of Service. If you do not agree, please do not use our services.',
              ),
              _buildSection(
                '2. Service Agreement',
                'All event services provided by MAMA EVENTS are subject to a separate written agreement that outlines specific pricing, menus, and logistics. These terms apply specifically to the use of our digital platforms.',
              ),
              _buildSection(
                '3. Booking and Deposits',
                'A non-refundable deposit is required to confirm a booking. The full balance is typically due 7-14 days before the event date, unless otherwise specified in your individual contract.',
              ),
              _buildSection(
                '4. Cancellation Policy',
                'Cancellations must be made in writing. Refunds are governed by the specific terms in your event contract, typically involving a tiered refund structure based on notice period.',
              ),
              _buildSection(
                '5. Limitation of Liability',
                'MAMA EVENTS is not liable for indirect, incidental, or consequential damages resulting from the use or inability to use our website or services.',
              ),
              _buildSection(
                '6. User Conduct',
                'Users agree not to use the website for any unlawful purposes or to transmit any material that is harmful, threatening, or offensive.',
              ),
              const SizedBox(height: 40),
              Text(
                'Last Updated: January 2026',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.mediumGrey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.logoDeepBlack,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: const Color(0xFF424242),
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }
}
