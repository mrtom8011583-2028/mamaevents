import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme/colors.dart';
import '../shared/widgets/app_bar/custom_app_bar.dart';
import '../shared/widgets/footer/premium_footer.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
            'PRIVACY POLICY',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.premiumGoldMedium,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Your Privacy Matters',
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
                '1. Introduction',
                'At MAMA EVENTS, we are committed to protecting your personal data and respecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your information when you visit our website or use our services.',
              ),
              _buildSection(
                '2. Information We Collect',
                'We may collect personal information such as your name, email address, phone number, and event details when you request a quote or contact us via our website.',
              ),
              _buildSection(
                '3. How We Use Your Information',
                'We use the collected information to: \n• Provide quotes and services\n• Communicate with you regarding your events\n• Improve our website and customer service\n• Send occasional promotional updates (optional)',
              ),
              _buildSection(
                '4. Data Security',
                'We implement appropriate technical and organizational measures to ensure a level of security appropriate to the risk of unauthorized access, alteration, or disclosure of your personal data.',
              ),
              _buildSection(
                '5. Third-Party Sharing',
                'We do not sell, trade, or otherwise transfer your personal information to outside parties except to provide our services or as required by law.',
              ),
              _buildSection(
                '6. Changes to This Policy',
                'MAMA EVENTS reserves the right to update this Privacy Policy at any time. We will notify users of any significant changes by posting a notice on our website.',
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
