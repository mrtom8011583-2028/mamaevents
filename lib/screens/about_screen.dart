import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../shared/widgets/app_bar/custom_app_bar.dart';
import '../config/theme/colors.dart';
import 'dart:async';
import '../shared/widgets/luxury/luxury_cta_section.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> with TickerProviderStateMixin {
  late AnimationController _missionVisionController;
  late AnimationController _coreValuesController;
  late Animation<double> _missionAnimation;
  late Animation<double> _visionAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Mission & Vision smooth zoom animation
    _missionVisionController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);
    
    _missionAnimation = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(
        parent: _missionVisionController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOutCubic),
      ),
    );
    
    _visionAnimation = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(
        parent: _missionVisionController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOutCubic),
      ),
    );
    
    // Core values animation
    _coreValuesController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _missionVisionController.dispose();
    _coreValuesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Hero Section with Background Image
          _buildHeroSection(),

          // Our Story
          _buildOurStory(),

          // Mission & Vision
          _buildMissionVision(),

          // Core Values
          _buildCoreValues(),

          // Why Choose Us
          _buildWhyChooseUs(),

          // Stats Section with Counter Animation
          _buildStatsSection(),
          
          // Certifications & Awards
          _buildAwardsSection(isMobile),

          // CTA Section
          _buildCTASection(context),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    final isMobile = MediaQuery.of(context).size.width < 800;
    
    return Container(
      height: isMobile ? 300 : 400,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1555244162-803834f70033?w=1600',
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.15),
            BlendMode.darken,
          ),
        ),
      ),
      child: Stack(
        children: [
          // Minimal gradient for text readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.2),
                  ],
                ),
              ),
            ),
          ),
          
          // Content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                    ),
                    child: const Icon(
                      Icons.restaurant_menu,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'About MAMA EVENTS',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 60,
                    height: 4,
                    color: AppColors.premiumGoldMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Crafting Memorable Experiences Since 2015',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.95),
                      height: 1.6,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOurStory() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      color: AppColors.softWhite,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                'OUR STORY',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.premiumGoldMedium,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'From Humble Beginnings to Regional Excellence',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.logoDeepBlack,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 800) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildStoryImage()),
                        const SizedBox(width: 60),
                        Expanded(child: _buildStoryText()),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _buildStoryImage(),
                        const SizedBox(height: 40),
                        _buildStoryText(),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoryImage() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        image: DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=800',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildStoryText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStyledParagraph(
          'Founded in 2015 in Lahore, Pakistan, MAMA EVENTS began with a vision: to deliver exceptional event experiences through world-class catering and impeccable service. What started as a catering operation has grown into a comprehensive event management company across Pakistan.',
        ),
        const SizedBox(height: 24),
        _buildStyledParagraph(
          'Our journey has been fueled by passion, dedication, and an unwavering commitment to quality. From intimate gatherings to grand celebrations, we\'ve had the privilege of serving over 10,000 events, creating lasting memories for our clients.',
        ),
        const SizedBox(height: 24),
        _buildStyledParagraph(
          'Today, with offices in 6 major cities across two countries, we continue to innovate, bringing fresh ideas and flavors to every table we serve. Our team of professional chefs, event planners, and service staff work tirelessly to ensure your event is nothing short of extraordinary.',
        ),
      ],
    );
  }

  Widget _buildStyledParagraph(String text) {
    return Container(
      padding: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: AppColors.mediumGrey,
            width: 3,
          ),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 15,
          color: const Color(0xFF424242),
          height: 1.8,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildMissionVision() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return Row(
                    children: [
                      Expanded(child: _buildMissionCard()),
                      const SizedBox(width: 40),
                      Expanded(child: _buildVisionCard()),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildMissionCard(),
                      const SizedBox(height: 30),
                      _buildVisionCard(),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMissionCard() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, fadeValue, child) {
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1200),
          tween: Tween(begin: 50.0, end: 0.0),
          curve: Curves.easeOutCubic,
          builder: (context, offsetValue, child) {
            return Transform.translate(
              offset: Offset(0, offsetValue),
              child: Opacity(
                opacity: fadeValue,
                child: AnimatedBuilder(
                  animation: _missionAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _missionAnimation.value,
                      child: Container(
                        height: 360,
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: AppColors.logoDeepBlack,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.mediumGrey.withOpacity(0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.premiumGoldMedium.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.flag,
                                size: 40,
                                color: AppColors.premiumGoldMedium,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Our Mission',
                              style: GoogleFonts.inter(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Flexible(
                              child: Text(
                                'To deliver exceptional catering experiences that exceed expectations, transforming every event into an unforgettable celebration through quality food, impeccable service, and attention to detail.',
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  color: Colors.white.withOpacity(0.9),
                                  height: 1.8,
                                ),
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildVisionCard() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1400),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, fadeValue, child) {
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1400),
          tween: Tween(begin: 50.0, end: 0.0),
          curve: Curves.easeOutCubic,
          builder: (context, offsetValue, child) {
            return Transform.translate(
              offset: Offset(0, offsetValue),
              child: Opacity(
                opacity: fadeValue,
                child: AnimatedBuilder(
                  animation: _visionAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _visionAnimation.value,
                      child: Container(
                        height: 360,
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: AppColors.logoDeepBlack,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.premiumGoldMedium.withOpacity(0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.premiumGoldMedium.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.visibility,
                                size: 40,
                                color: AppColors.premiumGoldMedium,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Our Vision',
                              style: GoogleFonts.inter(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Flexible(
                              child: Text(
                                'To become the most trusted and innovative catering partner across the region, setting new standards in culinary excellence, sustainability, and customer satisfaction.',
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  color: Colors.white.withOpacity(0.9),
                                  height: 1.8,
                                ),
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCoreValues() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      color: AppColors.softWhite,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                'CORE VALUES',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.premiumGoldMedium,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'What Defines Us',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.logoDeepBlack,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              
              LayoutBuilder(
                builder: (context, constraints) {
                  return Wrap(
                    spacing: constraints.maxWidth > 600 ? 30 : 20,
                    runSpacing: 30,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildValueCard(Icons.star, 'Excellence', 'We pursue the highest standards in every dish we prepare and every event we serve.', 0),
                      _buildValueCard(Icons.favorite, 'Passion', 'Our love for food and hospitality drives everything we do.', 1),
                      _buildValueCard(Icons.verified, 'Integrity', 'Honesty, transparency, and ethical practices guide our business.', 2),
                      _buildValueCard(Icons.lightbulb, 'Innovation', 'We constantly evolve, bringing fresh ideas and modern techniques to catering.', 3),
                      _buildValueCard(Icons.people, 'Customer Focus', 'Your satisfaction is our success. We listen, adapt, and deliver.', 4),
                      _buildValueCard(Icons.eco, 'Sustainability', 'We\'re committed to environmentally responsible practices and local sourcing.', 5),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValueCard(IconData icon, String title, String description, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + (index * 150)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 340,
            height: 280,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColors.premiumGoldMedium,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 35, color: Colors.white),
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
                Flexible(
                  child: Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF616161),
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWhyChooseUs() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Text(
                  'WHY CHOOSE MAMA EVENTS',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.premiumGoldMedium,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'The Fresh Difference',
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.logoDeepBlack,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Wrap(
                      spacing: constraints.maxWidth > 600 ? 24 : 16,
                      runSpacing: 24,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildFeatureCard(Icons.restaurant, 'Expert Chefs', 'Our culinary team brings decades of combined experience from top restaurants and hotels.'),
                        _buildFeatureCard(Icons.local_dining, '100% Halal', 'All our ingredients and preparation methods are certified Halal.'),
                        _buildFeatureCard(Icons.schedule, 'On-Time Service', 'We value your time. Our setup and service are always punctual and professional.'),
                        _buildFeatureCard(Icons.price_check, 'Transparent Pricing', 'No hidden fees. What you see is what you pay.'),
                        _buildFeatureCard(Icons.thumb_up, 'Quality Guaranteed', 'Fresh ingredients, hygiene standards, and taste - all guaranteed.'),
                        _buildFeatureCard(Icons.support_agent, '24/7 Support', 'Our customer service team is always available to assist you.'),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description) {
    return Container(
      width: 360,
      height: 180,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.premiumGoldMedium.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 28, color: AppColors.premiumGoldMedium),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.logoDeepBlack,
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF616161),
                      height: 1.6,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      color: AppColors.softWhite,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: constraints.maxWidth > 600 ? 30 : 20,
                runSpacing: 30,
                alignment: WrapAlignment.center,
                children: [
                  _AnimatedStatCard(endValue: 10000, label: 'Events Served', icon: Icons.event, suffix: '+'),
                  _AnimatedStatCard(endValue: 6, label: 'Office Locations', icon: Icons.location_city, suffix: ''),
                  _AnimatedStatCard(endValue: 50, label: 'Professional Staff', icon: Icons.people, suffix: '+'),
                  _AnimatedStatCard(endValue: 98, label: 'Client Satisfaction', icon: Icons.sentiment_very_satisfied, suffix: '%'),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAwardsSection(bool isMobile) {
    final awards = [
      {
        'icon': Icons.verified,
        'title': 'ISO 22000 Certified',
        'description': 'Food Safety Management System certification',
      },
      {
        'icon': Icons.workspace_premium,
        'title': 'Best Catering 2023',
        'description': 'Excellence in Hospitality Award',
      },
      {
        'icon': Icons.emoji_events,
        'title': 'Top 10 Caterers',
        'description': 'Pakistan Hospitality Association',
      },
      {
        'icon': Icons.military_tech,
        'title': 'HACCP Compliant',
        'description': 'Hazard Analysis Critical Control Points',
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: isMobile ? 24 : 60,
      ),
      color: AppColors.softWhite,
      child: Column(
        children: [
          // Section Header
          Text(
            'CERTIFICATIONS & AWARDS',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.premiumGoldMedium,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Recognized Excellence',
            style: GoogleFonts.inter(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: AppColors.logoDeepBlack,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.premiumGoldMedium,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Our commitment to quality and excellence is recognized by industry leaders',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: const Color(0xFF757575),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),
          
          // Awards Grid
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: awards.map((award) {
              return _buildAwardCard(
                icon: award['icon'] as IconData,
                title: award['title'] as String,
                description: award['description'] as String,
                isMobile: isMobile,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAwardCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isMobile,
  }) {
    return Container(
      width: isMobile ? double.infinity : 280,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8E8E8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon with gradient background
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.premiumGoldMedium.withOpacity(0.1),
                  AppColors.premiumGoldMedium.withOpacity(0.2),
                ],
              ),
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
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.logoDeepBlack,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF757575),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCTASection(BuildContext context) {
    return const LuxuryCTASection(
      title: 'Ready to Work Together?',
      subtitle: 'Let\'s create something extraordinary for your next event.',
      icon: Icons.handshake,
      buttonTypes: [CTAButtonType.services, CTAButtonType.quote],
    );
  }
}

// Animated Stat Card with Counter Animation
class _AnimatedStatCard extends StatefulWidget {
  final int endValue;
  final String label;
  final IconData icon;
  final String suffix;

  const _AnimatedStatCard({
    required this.endValue,
    required this.label,
    required this.icon,
    required this.suffix,
  });

  @override
  State<_AnimatedStatCard> createState() => _AnimatedStatCardState();
}

class _AnimatedStatCardState extends State<_AnimatedStatCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _countAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    
    _countAnimation = IntTween(begin: 0, end: widget.endValue).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkVisibility() {
    if (!_hasAnimated) {
      _hasAnimated = true;
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkVisibility();
    
    return AnimatedBuilder(
      animation: _countAnimation,
      builder: (context, child) {
        return Container(
          width: 250,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 40, color: AppColors.premiumGoldMedium),
              const SizedBox(height: 16),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${_formatNumber(_countAnimation.value)}${widget.suffix}',
                  style: GoogleFonts.inter(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: AppColors.premiumGoldMedium,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.label,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: const Color(0xFF616161),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatNumber(int num) {
    // Format numbers with proper comma separators
    if (num >= 10000) {
      // For 10,000+
      return num.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
    } else if (num >= 1000) {
      // For 1,000 - 9,999
      return num.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
    }
    return num.toString();
  }
}



