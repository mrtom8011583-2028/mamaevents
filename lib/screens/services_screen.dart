import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/models/service.dart';
import '../data/services_data.dart';
import '../providers/app_config_provider.dart';
import '../config/theme/colors.dart';
import '../shared/widgets/app_bar/custom_app_bar.dart';
import '../features/services/screens/service_detail_screen.dart';
import '../features/contact/widgets/simplified_quote_dialog.dart';
import '../shared/widgets/luxury/luxury_cta_section.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  int? _hoveredServiceIndex;
  int _expandedFaqIndex = -1;

  @override
  Widget build(BuildContext context) {
    final config = context.watch<AppConfigProvider>().config;
    final services = ServicesData.getServicesByRegion(config.region.code);
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            _buildHeroSection(isMobile),

            // Services Grid
            _buildServicesGrid(services, config, isMobile),

            // How It Works Section
            _buildHowItWorksSection(isMobile),

            // Features Highlights
            _buildFeaturesSection(isMobile),

            // FAQ Section
            _buildFAQSection(isMobile),

            // CTA Section
            _buildCTASection(context, isMobile),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(bool isMobile) {
    return Container(
      height: isMobile ? 300 : 400,
      width: double.infinity,
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1555244162-803834f70033?w=1920&q=80',
              fit: BoxFit.cover,
            ),
          ),
          
          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.7),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'AT YOUR SERVICE',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Main Title
                  Text(
                    'Our Catering Services',
                    style: GoogleFonts.inter(
                      fontSize: isMobile ? 36 : 52,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  
                  // Orange Accent Line
                  Container(
                    width: 80,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.premiumGoldMedium,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Subtitle
                  Text(
                    'From intimate gatherings to grand celebrations,\nwe bring culinary excellence to every event',
                    style: GoogleFonts.inter(
                      fontSize: isMobile ? 16 : 18,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.6,
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

  Widget _buildServicesGrid(List<Service> services, config, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: isMobile ? 24 : 60,
      ),
      child: Column(
        children: [
          // Section Header
          Text(
            'WHAT WE OFFER',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.premiumGoldMedium,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Premium Catering Solutions',
            style: GoogleFonts.inter(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF212121),
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
          const SizedBox(height: 50),
          
          // Services Grid
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 900
                  ? 3
                  : (constraints.maxWidth > 600 ? 2 : 1);
              return Wrap(
                spacing: 24,
                runSpacing: 24,
                children: services.asMap().entries.map((entry) {
                  final index = entry.key;
                  final service = entry.value;
                  return SizedBox(
                    width: (constraints.maxWidth - (crossAxisCount - 1) * 24) /
                        crossAxisCount,
                    child: _buildPremiumServiceCard(context, service, config, index),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumServiceCard(BuildContext context, Service service, config, int index) {
    final isHovered = _hoveredServiceIndex == index;
    
    // Get pricing info
    String? priceText;
    if (service.pricing != null) {
      final regionPricing = service.pricing![config.region.code];
      if (regionPricing != null) {
        final starting = regionPricing['starting'] as int;
        priceText = config.region.formatPrice(starting.toDouble());
      }
    }

    // Service icons
    IconData getServiceIcon(String id) {
      switch (id) {
        case 'corporate_catering':
          return Icons.business_center;
        case 'wedding_banquets':
          return Icons.favorite;
        case 'live_interaction_stations':
          return Icons.restaurant;
        case 'yacht_outdoor_catering':
          return Icons.sailing;
        case 'event_infrastructure':
          return Icons.event;
        default:
          return Icons.celebration;
      }
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredServiceIndex = index),
      onExit: (_) => setState(() => _hoveredServiceIndex = null),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ServiceDetailScreen(service: service),
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          transform: Matrix4.identity()..translate(0.0, isHovered ? -8.0 : 0.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isHovered ? 0.15 : 0.08),
                blurRadius: isHovered ? 30 : 15,
                offset: Offset(0, isHovered ? 15 : 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image with overlay
                Stack(
                  children: [
                    AnimatedScale(
                      duration: const Duration(milliseconds: 400),
                      scale: isHovered ? 1.05 : 1.0,
                      child: _buildServiceImage(service),
                    ),
                    // Gradient overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.4),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Icon Badge
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Icon(
                          getServiceIcon(service.id),
                          color: const Color(0xFF212121),
                          size: 24,
                        ),
                      ),
                    ),
                    // Price Badge
                    if (priceText != null)
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: AppColors.premiumGoldGradient,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.premiumGoldMedium.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            'From $priceText',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.logoDeepBlack,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                
                // Content
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.title,
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF212121),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        service.shortDescription,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF757575),
                          height: 1.6,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 20),
                      
                      // View Details Button
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(
                          horizontal: isHovered ? 16 : 0,
                          vertical: isHovered ? 10 : 0,
                        ),
                        decoration: BoxDecoration(
                          color: isHovered 
                              ? const Color(0xFF212121) 
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Explore Service',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isHovered 
                                    ? Colors.white 
                                    : const Color(0xFF212121),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                              color: isHovered 
                                  ? Colors.white 
                                  : const Color(0xFF212121),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHowItWorksSection(bool isMobile) {
    final steps = [
      {
        'number': '01',
        'title': 'Consultation',
        'description': 'Share your vision and requirements with our event planners',
        'icon': Icons.chat_bubble_outline,
      },
      {
        'number': '02',
        'title': 'Custom Menu',
        'description': 'We create a personalized menu tailored to your preferences',
        'icon': Icons.restaurant_menu,
      },
      {
        'number': '03',
        'title': 'Planning',
        'description': 'Our team handles logistics, setup, and coordination',
        'icon': Icons.calendar_today,
      },
      {
        'number': '04',
        'title': 'Execution',
        'description': 'Enjoy a flawlessly executed culinary experience',
        'icon': Icons.celebration,
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: isMobile ? 24 : 60,
      ),
      color: const Color(0xFFF8F8F8),
      child: Column(
        children: [
          // Section Header
          Text(
            'HOW IT WORKS',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.premiumGoldMedium,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Simple 4-Step Process',
            style: GoogleFonts.inter(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF212121),
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
            'From initial consultation to event day, we make it seamless',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: const Color(0xFF757575),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),
          
          // Steps
          isMobile
              ? Column(
                  children: steps.asMap().entries.map((entry) {
                    final index = entry.key;
                    final step = entry.value;
                    return _buildProcessStep(step, index, isMobile, steps.length);
                  }).toList(),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: steps.asMap().entries.map((entry) {
                    final index = entry.key;
                    final step = entry.value;
                    return Expanded(
                      child: _buildProcessStep(step, index, isMobile, steps.length),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildProcessStep(Map<String, dynamic> step, int index, bool isMobile, int totalSteps) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 0 : 16,
        vertical: isMobile ? 24 : 0,
      ),
      child: Column(
        children: [
          // Step Number with Icon
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF212121),
                      const Color(0xFF424242),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF212121).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    step['icon'] as IconData,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
              // Number Badge
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF212121),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      step['number'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Title
          Text(
            step['title'] as String,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF212121),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          
          // Description
          Text(
            step['description'] as String,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF757575),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          // Connector Line (not for last item on desktop)
          if (!isMobile && index < totalSteps - 1)
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: Icon(
                Icons.arrow_forward,
                color: const Color(0xFFE0E0E0),
                size: 24,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(bool isMobile) {
    final features = [
      {
        'icon': Icons.verified,
        'title': 'Quality Assured',
        'description': 'Premium ingredients and strict hygiene standards',
        'color': const Color(0xFF212121),
      },
      {
        'icon': Icons.support_agent,
        'title': '24/7 Support',
        'description': 'Dedicated event coordinator for your peace of mind',
        'color': const Color(0xFF424242),
      },
      {
        'icon': Icons.restaurant_menu,
        'title': 'Custom Menus',
        'description': 'Tailored menus to match your theme and preferences',
        'color': const Color(0xFF5A5A5A),
      },
      {
        'icon': Icons.local_shipping,
        'title': 'On-Time Delivery',
        'description': 'Punctual setup and service, every single time',
        'color': const Color(0xFF212121),
      },
      {
        'icon': Icons.cleaning_services,
        'title': 'Full Service',
        'description': 'Setup, service, and cleanup all included',
        'color': const Color(0xFF424242),
      },
      {
        'icon': Icons.attach_money,
        'title': 'Transparent Pricing',
        'description': 'No hidden fees, clear quotations upfront',
        'color': const Color(0xFF5A5A5A),
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: isMobile ? 24 : 60,
      ),
      child: Column(
        children: [
          // Section Header
          Text(
            'WHY CHOOSE US',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.premiumGoldMedium,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'The MAMA EVENTS Advantage',
            style: GoogleFonts.inter(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF212121),
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
          const SizedBox(height: 50),
          
          // Features Grid
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: features.map((feature) {
              return _buildFeatureCard(
                icon: feature['icon'] as IconData,
                title: feature['title'] as String,
                description: feature['description'] as String,
                color: feature['color'] as Color,
                isMobile: isMobile,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required bool isMobile,
  }) {
    return Container(
      width: isMobile ? double.infinity : 350,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 20),
          
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF757575),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection(bool isMobile) {
    final faqs = [
      {
        'question': 'How far in advance should I book?',
        'answer': 'We recommend booking at least 2-4 weeks in advance for regular events, and 2-3 months for weddings and large corporate events. However, we can accommodate last-minute requests based on availability.',
      },
      {
        'question': 'Do you offer vegetarian and halal options?',
        'answer': 'Absolutely! All our meat is 100% halal certified. We offer extensive vegetarian, vegan, and dietary-specific menus. Just let us know your requirements during consultation.',
      },
      {
        'question': 'What is included in your catering service?',
        'answer': 'Our full-service catering includes menu planning, food preparation, delivery, setup, serving staff, tableware, and cleanup. We can also arrange decorations and additional services upon request.',
      },
      {
        'question': 'Do you provide tasting sessions?',
        'answer': 'Yes! For weddings and large events, we offer complimentary tasting sessions so you can sample our dishes before finalizing your menu.',
      },
      {
        'question': 'What is your cancellation policy?',
        'answer': 'Cancellations made 7+ days before the event receive a full refund minus the deposit. Within 7 days, 50% is refundable. We understand emergencies happen and handle each case individually.',
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: isMobile ? 24 : 60,
      ),
      color: const Color(0xFFF8F8F8),
      child: Column(
        children: [
          // Section Header
          Text(
            'FREQUENTLY ASKED',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.premiumGoldMedium,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Common Questions',
            style: GoogleFonts.inter(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF212121),
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
          const SizedBox(height: 50),
          
          // FAQ Accordion
          Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: faqs.asMap().entries.map((entry) {
                final index = entry.key;
                final faq = entry.value;
                return _buildFAQItem(
                  question: faq['question']!,
                  answer: faq['answer']!,
                  index: index,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
    required int index,
  }) {
    final isExpanded = _expandedFaqIndex == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded ? AppColors.mediumGrey : const Color(0xFFE8E8E8),
          width: isExpanded ? 2 : 1,
        ),
        boxShadow: isExpanded
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ]
            : [],
      ),
      child: Column(
        children: [
          // Question Header
          InkWell(
            onTap: () {
              setState(() {
                _expandedFaqIndex = isExpanded ? -1 : index;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  // Q Icon
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isExpanded 
                          ? AppColors.mediumGrey 
                          : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Q',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isExpanded 
                              ? Colors.white 
                              : const Color(0xFF757575),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Question Text
                  Expanded(
                    child: Text(
                      question,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF212121),
                      ),
                    ),
                  ),
                  
                  // Expand Icon
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isExpanded 
                            ? AppColors.mediumGrey.withOpacity(0.1) 
                            : const Color(0xFFF5F5F5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: isExpanded 
                            ? AppColors.mediumGrey 
                            : const Color(0xFF757575),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Answer (Expandable)
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(76, 0, 24, 24),
              child: Text(
                answer,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: const Color(0xFF616161),
                  height: 1.6,
                ),
              ),
            ),
            crossFadeState: isExpanded 
                ? CrossFadeState.showSecond 
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildCTASection(BuildContext context, bool isMobile) {
    return const LuxuryCTASection(
      buttonTypes: [CTAButtonType.menu, CTAButtonType.quote],
    );
  }

  Widget _buildServiceImage(Service service) {
    if (service.imageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: service.imageUrl,
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 150),
        placeholder: (context, url) => Container(
          height: 220,
          color: const Color(0xFFF0F0F0),
          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(Color(0xFF1B5E20)),
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => _buildPlaceholder(service),
      );
    }
    return _buildPlaceholder(service);
  }

  Widget _buildPlaceholder(Service service) {
    IconData icon;
    switch (service.id) {
      case 'corporate_catering':
        icon = Icons.business_center;
        break;
      case 'wedding_banquets':
        icon = Icons.favorite;
        break;
      case 'live_interaction_stations':
        icon = Icons.restaurant;
        break;
      case 'yacht_outdoor_catering':
        icon = Icons.sailing;
        break;
      case 'event_infrastructure':
        icon = Icons.event;
        break;
      default:
        icon = Icons.celebration;
    }

    return Container(
      height: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1B5E20).withOpacity(0.1),
            const Color(0xFF1B5E20).withOpacity(0.05),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 64,
          color: const Color(0xFF1B5E20).withOpacity(0.3),
        ),
      ),
    );
  }
}
