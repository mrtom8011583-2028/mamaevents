import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/models/app_config.dart';
import '../core/models/menu_item.dart';
import '../providers/app_config_provider.dart';
import '../providers/menu_provider.dart';
import '../widgets/video_background.dart';
import '../widgets/location_selector.dart';
import '../widgets/location_selector.dart';
import '../shared/widgets/sections/service_areas_section.dart';

import '../shared/widgets/sections/premium_services_section.dart';
import '../features/testimonials/widgets/testimonials_section.dart';
import '../shared/widgets/footer/premium_footer.dart';
import '../shared/widgets/sections/premium_contact_section.dart';

import '../utils/responsive_helper.dart';
import '../shared/widgets/animations/fade_in_animation.dart';
import '../shared/widgets/animated_stat_card.dart';
import '../shared/widgets/app_bar/custom_app_bar.dart';
import '../shared/widgets/geometric_background.dart';
import '../shared/widgets/sections/animated_hero_section.dart';
import '../config/theme/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    final configProvider = context.read<AppConfigProvider>();
    final menuProvider = context.read<MenuProvider>();

    await configProvider.initialize();
    // Sync region with MenuProvider
    menuProvider.updateRegion(configProvider.config.region);
  }

  @override
  Widget build(BuildContext context) {
    final configProvider = context.watch<AppConfigProvider>();
    final config = configProvider.config;

    return Scaffold(
      backgroundColor: AppColors.softWhite,
      appBar: const CustomAppBar(),
      body: ListView(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            children: [
              // HERO SECTION - Premium Animated Design
              const AnimatedHeroSection(),

              // STATS SECTION - Animated Numbers
              Container(
                padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
                color: Colors.white,
                child: Wrap(
              spacing: 30,
              runSpacing: 30,
              alignment: WrapAlignment.spaceEvenly,
              children: [
                AnimatedStatCard(
                  endValue: 500,
                  label: 'Events Catered',
                  icon: Icons.local_dining,
                  suffix: '+',
                ),
                AnimatedStatCard(
                  endValue: 15,
                  label: 'Years Experience',
                  icon: Icons.star,
                  suffix: '+',
                ),
                AnimatedStatCard(
                  endValue: 100,
                  label: 'Halal Certified',
                  icon: Icons.verified,
                  suffix: '%',
                ),
              ],
            ),
          ),

          // 🗺️ SERVICE AREAS SECTION - Region-specific coverage
          const ServiceAreasSection(),



          // ABOUT SECTION
          Container(
            padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
            child: Column(
              children: [
                const Icon(Icons.restaurant_menu, color: Color(0xFF212121), size: 40),
                const SizedBox(height: 24),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Text(
                    "MAMA EVENTS brings 15+ years of event excellence to Pakistan. From intimate gatherings to grand celebrations, we deliver complete event solutions with world-class catering, impeccable service, and unforgettable experiences.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: const Color(0xFF424242),
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),



          // 🏢 PREMIUM SERVICES SECTION - 4 Core Services
          const PremiumServicesSection(),

          // 💬 TESTIMONIALS SECTION - Customer Reviews
          const TestimonialsSection(),

          // ABOUT US SECTION
          Container(
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
            color: AppColors.softWhite,
            child: Column(
              children: [
                Text(
                  'ABOUT US',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.premiumGoldMedium,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'MAMA EVENTS',
                  style: GoogleFonts.inter(
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    color: AppColors.logoDeepBlack,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 80, 
                  height: 4, 
                  decoration: BoxDecoration(
                    gradient: AppColors.premiumGoldGradient,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 40),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Text(
                    "MAMA EVENTS Pakistan brings over 15 years of event management and catering excellence to Lahore, Sialkot, and beyond. We specialize in creating unforgettable experiences for weddings, corporate galas, and private celebrations. Our commitment to quality, innovation, and exceptional service has made us one of Pakistan's most trusted event management companies.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: const Color(0xFF616161),
                      height: 1.8,
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                // About Features
                LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = constraints.maxWidth > 800 ? 3 : 1;
                    return Wrap(
                      spacing: 40,
                      runSpacing: 40,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildAboutFeature(
                          Icons.verified,
                          '100% Halal',
                          'All our ingredients are certified halal and sourced from trusted suppliers.',
                        ),
                        _buildAboutFeature(
                          Icons.restaurant_menu,
                          'Expert Chefs',
                          'Our team of professional chefs brings decades of combined experience.',
                        ),
                        _buildAboutFeature(
                          Icons.star,
                          'Premium Quality',
                          'We use only the finest ingredients to ensure exceptional taste.',
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          // FAQ SECTION
          Container(
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
            color: Colors.white,
            child: Column(
              children: [
                Text(
                  'FREQUENTLY ASKED',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF5A5A5A),
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Questions',
                  style: GoogleFonts.inter(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 16),
                Container(width: 60, height: 4, color: const Color(0xFF212121)),
                const SizedBox(height: 60),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Column(
                    children: [
                      _buildFAQItem(
                        'What types of events do you cater?',
                        'We cater all types of events including weddings, corporate functions, private parties, birthdays, anniversaries, and special occasions. No event is too big or too small for our team.',
                      ),
                      _buildFAQItem(
                        'How far in advance should I book?',
                        'We recommend booking at least 2-4 weeks in advance for small events and 2-3 months for large events like weddings. However, we do our best to accommodate last-minute requests when possible.',
                      ),
                      _buildFAQItem(
                        'Do you provide serving staff?',
                        'Yes! We provide professional serving staff, bartenders, and event coordinators as part of our full-service catering packages. Staff costs are included in our quotes.',
                      ),
                      _buildFAQItem(
                        'Can you accommodate dietary restrictions?',
                        'Absolutely! We can accommodate various dietary requirements including vegetarian, vegan, gluten-free, nut-free, and other special dietary needs. Just let us know your requirements when booking.',
                      ),
                      _buildFAQItem(
                        'What is your cancellation policy?',
                        'Cancellations made 14+ days before the event receive a full refund. Cancellations made 7-14 days before receive a 50% refund. Unfortunately, cancellations within 7 days are non-refundable.',
                      ),
                      _buildFAQItem(
                        'Do you offer tasting sessions?',
                        'Yes! We offer complimentary tasting sessions for events with 50+ guests. For smaller events, tasting sessions are available for a nominal fee that is credited toward your final bill.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                // CTA
                Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Still Have Questions?',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF212121),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Our team is here to help! Contact us anytime.',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: const Color(0xFF616161),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => context.go('/contact'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF212121),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        ),
                        child: Text(
                          'CONTACT US',
                          style: GoogleFonts.inter(
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 🔶 PREMIUM CONTACT SECTION - Quick contact grid + form
          const PremiumContactSection(),

          // 🎨 PREMIUM FOOTER - Professional footer with links & social
            const PremiumFooter(),
          ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B5E20),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF616161),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterLink(String text) {
    String route = '/';
    switch (text.toLowerCase()) {
      case 'home': route = '/'; break;
      case 'menu': route = '/our-menu'; break;
      case 'services': route = '/services'; break;
      case 'gallery': route = '/gallery'; break;
      case 'contact': route = '/contact'; break;
    }
    return TextButton(
      onPressed: () => context.go(route),
      child: Text(
        text,
        style: GoogleFonts.lato(
          color: const Color(0xFFCFCFCF),
          fontSize: 14,
          letterSpacing: 0.5,
        ),
      ),
    );
  }


  // Helper widget for location cards
  Widget _buildLocationCard(String flag, String city, String address) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border.all(color: const Color(0xFFCFCFCF).withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Text(flag, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 12),
          Text(
            city,
            style: const TextStyle(
              color: Color(0xFFFAFAFA),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            address,
            style: const TextStyle(
              color: Color(0xFF8E8E8E),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildAppBar(
      BuildContext context,
      AppConfig config,
      AppConfigProvider configProvider,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0B0B0B).withOpacity(0.95),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFCFCFCF).withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              // Logo
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.restaurant,
                  color: Color(0xFF0B0B0B),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              // Company Name
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'fresh',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFFFAFAFA),
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    'catering',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFC6A869),
                      letterSpacing: 1.2,
                      height: 0.8,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Phone Number
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFC6A869),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.phone_outlined,
                      size: 16,
                      color: Color(0xFFC6A869),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(AppConfig config) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final responsive = context.responsive;
        final textSizes = context.text;
        
        return Container(
          padding: EdgeInsets.fromLTRB(
            responsive.horizontalPadding,
            responsive.isMobile ? 60 : 100,
            responsive.horizontalPadding,
             responsive.isMobile ? 40 : 80,
          ),
         child: Center(
            child: Column(
              children: [
                // Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.isMobile ? 16 : 28,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFC6A869).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    responsive.isMobile ? 'EVENT MANAGEMENT' : 'PROFESSIONAL EVENT MANAGEMENT SERVICES',
                    style: TextStyle(
                      fontSize: textSizes.caption, // 14-16px responsive
                      color: const Color(0xFFC6A869),
                      fontWeight: FontWeight.w500,
                      letterSpacing: responsive.isMobile ? 1.5 : 2,
                    ),
                  ),
                ),
                SizedBox(height: responsive.isMobile ? 24 : 40),

                // Main Heading - Responsive!
                Text(
                  'MAMA EVENTS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: textSizes.display, // 40px mobile, 72px desktop
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFAFAFA),
                    letterSpacing: -1,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'For Your',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: textSizes.display, // 40px mobile, 72px desktop
                    fontWeight: FontWeight.w300,
                    color: const Color(0xFFCFCFCF),
                    letterSpacing: -1,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: responsive.isMobile ? 20 : 32),

                // Divider
                Container(
                  width: responsive.isMobile ? 40 : 60,
                  height: 1,
                  color: const Color(0xFFC6A869),
                ),
                SizedBox(height: responsive.isMobile ? 20 : 32),

                // Description - Responsive with padding!
                Container(
                  constraints: BoxConstraints(
                    maxWidth: responsive.maxContentWidth * 0.7,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.safeMargin,
                  ),
                  child: Text(
                    'Complete Event Solutions • Weddings • Corporate • Catering',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: textSizes.bodyLarge, // 18-20px responsive
                      color: const Color(0xFFCFCFCF),
                      height: 1.8,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
            const SizedBox(height: 50),

            // Action Buttons
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                // WhatsApp Button
                _buildPrimaryButton(
                  label: 'WhatsApp Us Now',
                  icon: FontAwesomeIcons.whatsapp,
                  onPressed: () {},
                ),
                // Email Button
                _buildSecondaryButton(
                  label: 'Email Us',
                  icon: Icons.email_outlined,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
      },
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0B0B0B),
        foregroundColor: const Color(0xFFFAFAFA),
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 20),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        elevation: 0,
      ),
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFFFAFAFA), width: 1),
        foregroundColor: const Color(0xFFFAFAFA),
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 20),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return FadeInAnimation(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        padding: const EdgeInsets.symmetric(vertical: 50),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          border: Border.all(
            color: const Color(0xFFCFCFCF).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Wrap(
          spacing: 30,
          runSpacing: 30,
          alignment: WrapAlignment.spaceEvenly,
          children: [
            AnimatedStatCard(
              endValue: 500,
              label: 'Events Catered',
              icon: Icons.local_dining, // Matches food theme
              suffix: '+',
            ),
            AnimatedStatCard(
              endValue: 15,
              label: 'Years Experience',
              icon: Icons.star, 
              suffix: '+',
            ),
            AnimatedStatCard(
              endValue: 100,
              label: 'Halal Certified',
              icon: Icons.verified,
              suffix: '%',
            ),
          ],
        ),
      ),
    );
  }





  Widget _buildOurStorySection() {
    return FadeInAnimation(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                border: Border.all(
                  color: const Color(0xFFCFCFCF).withOpacity(0.1),
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.restaurant_menu,
                  size: 80,
                  color: Color(0xFFC6A869),
                ),
              ),
            ),
          ),
          const SizedBox(width: 60),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Our Story',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFAFAFA),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: 40,
                  height: 1,
                  color: const Color(0xFFC6A869),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Founded over 15 years ago, MAMA EVENTS has been at the forefront of event management across Pakistan, delivering exceptional experiences for the most prestigious occasions. Our journey began with a simple vision: to revolutionize event planning and catering through innovation, quality, and impeccable service.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFCFCFCF),
                    height: 1.8,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Today, we\'re proud to be one of Pakistan\'s most trusted catering partners, serving clients across Punjab and beyond with our signature blend of creativity, culinary expertise, and 40+ years of combined professional experience.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFCFCFCF),
                    height: 1.8,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 40),
                Wrap(
                  spacing: 40,
                  runSpacing: 20,
                  children: [
                    _buildFeatureItem('Premium Quality'),
                    _buildFeatureItem('Expert Team'),
                    _buildFeatureItem('Custom Menus'),
                    _buildFeatureItem('On-time Delivery'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildFeatureItem(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.check,
          color: Color(0xFFC6A869),
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFFFAFAFA),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildTrustedBySection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80),
      color: const Color(0xFFFAFAFA),
      child: Column(
        children: [
          const Text(
            'Trusted by Leading Organizations',
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0B0B0B),
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'We\'re proud to serve Pakistan\'s most prestigious events and companies',
            style: TextStyle(
              fontSize: 16,
              color: const Color(0xFF8E8E8E),
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }



  Widget _buildServingLocationsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        children: [
          const Text(
            'Serving All of Punjab & Pakistan',
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w600,
              color: Color(0xFFFAFAFA),
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Premium catering services delivered to your location',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFCFCFCF),
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          Wrap(
            spacing: 40,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            children: [
              _buildLocationCard('🇵🇰', 'Lahore', 'DHA & Gulberg'),
              _buildLocationCard('🇵🇰', 'Islamabad', 'F-6, F-7 & Blue Area'),
              _buildLocationCard('🇵🇰', 'Sialkot', 'Cantonment & City'),
              _buildLocationCard('🇵🇰', 'Gujranwala', 'DC Colony & Citi Housing'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCTASection(AppConfig config) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      padding: const EdgeInsets.all(60),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0B0B),
        border: Border.all(
          color: const Color(0xFFC6A869).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Ready to Elevate Your Event?',
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w600,
              color: Color(0xFFFAFAFA),
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            width: 40,
            height: 1,
            color: const Color(0xFFC6A869),
          ),
          const SizedBox(height: 24),
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: const Text(
              'Contact us today to discuss your catering needs and let us create an unforgettable culinary experience for your guests.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFCFCFCF),
                height: 1.8,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD4AF37), Color(0xFFC9A24D)],
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () => context.go('/contact'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Get a Free Quote',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Our Menu',
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFAFAFA),
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Container(
          width: 40,
          height: 1,
          color: const Color(0xFFC6A869),
        ),
        const SizedBox(height: 16),
        const Text(
          'Curated by our expert chefs with premium ingredients',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFFCFCFCF),
            letterSpacing: 0.3,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMenuGrid(List<MenuItem> items, AppConfig config) {
    return FadeInAnimation(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : 2,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 0.85,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildMenuCard(item, config);
        },
      ),
    );
  }

  Widget _buildMenuCard(MenuItem item, AppConfig config) {
    return GestureDetector(
      onTap: () => _showMenuItemDetails(context, item, config),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          border: Border.all(
            color: const Color(0xFFCFCFCF).withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 3,
              child: item.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                imageUrl: item.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: const Color(0xFF2B2B2B),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFC6A869),
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: const Color(0xFF2B2B2B),
                  child: const Icon(
                    Icons.fastfood,
                    size: 40,
                    color: Color(0xFF8E8E8E),
                  ),
                ),
              )
                  : Container(
                color: const Color(0xFF2B2B2B),
                child: const Center(
                  child: Icon(
                    Icons.fastfood,
                    size: 40,
                    color: Color(0xFF8E8E8E),
                  ),
                ),
              ),
            ),
            // Content
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFAFAFA),
                            letterSpacing: 0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.category,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8E8E8E),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      config.formatPrice(item.getPrice(config.region)),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFC6A869),
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(AppConfig config) {
    final currentYear = DateTime.now().year;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0B0B),
        border: Border(
          top: BorderSide(
            color: const Color(0xFFCFCFCF).withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Wrap(
            spacing: 60,
            runSpacing: 40,
            alignment: WrapAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'fresh',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFFFAFAFA),
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'catering',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFC6A869),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Serving ${config.countryName}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8E8E8E),
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Discover',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFFAFAFA),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFooterLink('Home'),
                  _buildFooterLink('Collections'),
                  _buildFooterLink('Showcase'),
                  _buildFooterLink('Services'),
                  _buildFooterLink('Inquiries'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Contact Us',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFFAFAFA),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${config.phonePrefix}58 517 8182',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFFC6A869),
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          Container(
            height: 1,
            color: const Color(0xFFCFCFCF).withOpacity(0.1),
          ),
          const SizedBox(height: 24),
          Text(
            '© ${DateTime.now().year} MAMA EVENTS. All rights reserved.',
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF8E8E8E),
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  void _showMenuItemDetails(
      BuildContext context,
      MenuItem item,
      AppConfig config,
      ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF0B0B0B),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFCFCFCF).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFAFAFA),
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close,
                          color: Color(0xFFCFCFCF),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (item.imageUrl.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: item.imageUrl,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 250,
                        color: const Color(0xFF1A1A1A),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFC6A869),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 250,
                        color: const Color(0xFF1A1A1A),
                        child: const Icon(
                          Icons.fastfood,
                          size: 60,
                          color: Color(0xFF8E8E8E),
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  Text(
                    item.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFFCFCFCF),
                      height: 1.8,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFC6A869).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Price:',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFFFAFAFA),
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.3,
                          ),
                        ),
                        Text(
                          config.formatPrice(item.getPrice(config.region)),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFC6A869),
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFFCFCFCF),
                              width: 1,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: const Text(
                            'Close',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFFFAFAFA),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFAFAFA),
                            foregroundColor: const Color(0xFF0B0B0B),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.phone_outlined, size: 18),
                              SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  'Contact for Order',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAboutFeature(IconData icon, String title, String description) {
    return SizedBox(
      width: 250,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.premiumGoldMedium.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 40,
              color: AppColors.premiumGoldMedium,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.logoDeepBlack,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF757575),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
          expansionTileTheme: const ExpansionTileThemeData(
            tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            childrenPadding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
          ),
        ),
        child: ExpansionTile(
          title: Text(
            question,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF212121),
            ),
          ),
          iconColor: const Color(0xFF1B5E20),
          collapsedIconColor: const Color(0xFF757575),
          children: [
            Text(
              answer,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF616161),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
