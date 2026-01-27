import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/models/service.dart';
import '../../../providers/app_config_provider.dart';
import '../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../../shared/widgets/luxury/luxury_hero_header.dart';
import '../../../shared/widgets/luxury/luxury_cta_section.dart';
import '../../../config/theme/colors.dart';
import '../../../widgets/advanced_quote_request_form.dart';

class ServiceDetailScreen extends StatelessWidget {
  final Service service;

  const ServiceDetailScreen({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final config = context.watch<AppConfigProvider>().config;
    final isAvailable = service.isAvailableInRegion(config.region.code);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: ListView(
        children: [
          // Hero Header Section
          LuxuryHeroHeader(
            imageUrl: service.imageUrl,
            title: 'OUR SERVICES',
            subtitle: service.title,
            height: 400,
          ),

          // Content Section
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Breadcrumb
                _buildBreadcrumb(context),
                const SizedBox(height: 24),

                // Title Section
                Text(
                  service.title.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.premiumGoldMedium,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  service.title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.logoDeepBlack,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: 80,
                  height: 3,
                  decoration: const BoxDecoration(
                    gradient: AppColors.premiumGoldGradient,
                  ),
                ),
                const SizedBox(height: 24),

                // Short Description
                Text(
                  service.shortDescription,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    color: const Color(0xFF424242),
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 40),

                // Main Content Layout - Desktop: 2 columns, Mobile: 1 column
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 900) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left column - Description
                          Expanded(
                            flex: 2,
                            child: _buildDescriptionSection(),
                          ),
                          const SizedBox(width: 60),
                          // Right column - Features & CTA
                          Expanded(
                            flex: 1,
                            child: _buildSidebarSection(config, isAvailable, context),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDescriptionSection(),
                          const SizedBox(height: 40),
                          _buildSidebarSection(config, isAvailable, context),
                        ],
                      );
                    }
                  },
                ),

                const SizedBox(height: 80),

                // CTA Section
                const LuxuryCTASection(
                  title: 'Ready to Experience Our Service?',
                  subtitle: 'Contact us today to receive a personalized proposal based on your requirements.',
                  icon: Icons.room_service_outlined,
                  buttonTypes: [CTAButtonType.quote, CTAButtonType.whatsapp],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Content sections following...


  Widget _buildBreadcrumb(BuildContext context) {
    return Row(
      children: [
        TextButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, size: 16, color: AppColors.premiumGoldMedium),
          label: Text(
            'BACK TO SERVICES',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.premiumGoldMedium,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About This Service',
          style: GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.logoDeepBlack,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          service.description,
          style: GoogleFonts.inter(
            fontSize: 16,
            color: const Color(0xFF424242),
            height: 1.8,
          ),
        ),
        const SizedBox(height: 40),
        
        // Why Choose This Service
        _buildWhyChooseSection(),
      ],
    );
  }

  Widget _buildWhyChooseSection() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.verified_outlined,
                color: AppColors.premiumGoldMedium,
                size: 32,
              ),
              const SizedBox(width: 16),
              Text(
                'Why Choose This Service',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.logoDeepBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildWhyChooseItem(
            Icons.star,
            'Premium Quality',
            'We use only the finest ingredients and professional techniques.',
          ),
          const SizedBox(height: 16),
          _buildWhyChooseItem(
            Icons.schedule,
            'On-Time Service',
            'Punctual setup and service execution for your event.',
          ),
          const SizedBox(height: 16),
          _buildWhyChooseItem(
            Icons.people,
            'Professional Staff',
            'Experienced and courteous service team.',
          ),
          const SizedBox(height: 16),
          _buildWhyChooseItem(
            Icons.verified_user,
            '100% Halal',
            'All ingredients are certified halal and inspected.',
          ),
        ],
      ),
    );
  }

  Widget _buildWhyChooseItem(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.premiumGoldMedium, size: 22),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF616161),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSidebarSection(config, bool isAvailable, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pricing Card
        if (service.pricing != null) _buildPricingCard(config),
        const SizedBox(height: 24),

        // Features List
        _buildFeaturesCard(),
        const SizedBox(height: 24),

        // Availability Badge
        if (!isAvailable) _buildAvailabilityBadge(config),
      ],
    );
  }

  Widget _buildPricingCard(config) {
    final regionPricing = service.pricing![config.region.code];
    if (regionPricing == null) return const SizedBox.shrink();

    final starting = regionPricing['starting'] as int;
    final unit = regionPricing['unit'] as String;
    final formattedPrice = config.region.formatPrice(starting.toDouble());

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.logoDeepBlack,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Starting From',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey[400],
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            formattedPrice,
            style: GoogleFonts.inter(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: AppColors.premiumGoldMedium,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            unit,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF757575),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.info_outline, size: 16, color: Color(0xFF616161)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Final pricing depends on guest count, menu selection, and services required.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF616161),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.stars_rounded,
                color: AppColors.premiumGoldMedium,
                size: 28,
              ),
              const SizedBox(width: 16),
              Text(
                'Premium Package',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.logoDeepBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...service.features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check,
                      size: 18,
                      color: AppColors.premiumGoldMedium,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        feature,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF424242),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildAvailabilityBadge(config) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFB74D)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFFF57C00), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'This service is not currently available in ${config.region.name}',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFFE65100),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

