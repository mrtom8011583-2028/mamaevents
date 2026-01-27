import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../config/theme/colors.dart';

/// Premium Services Section
/// Showcases core services with luxury aesthetics and hover animations
class PremiumServicesSection extends StatelessWidget {
  const PremiumServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100),
      color: AppColors.softWhite,
      child: Column(
        children: [
          // Section Header
          _buildHeader(),

          const SizedBox(height: 60),

          // Services Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildServicesGrid(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Service Counter Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.premiumGoldMedium,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.premiumGoldMedium.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            '5 Premium Services',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.logoDeepBlack,
              letterSpacing: 1.0,
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Main Title
        Text(
          'OUR SERVICES',
          style: GoogleFonts.inter(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            color: AppColors.logoDeepBlack,
            letterSpacing: -1.0,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 12),
        
        // Subtitle
        Text(
          'Comprehensive Catering Solutions',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.premiumGoldMedium,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 20),
        
        // Description
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Text(
            'From intimate corporate lunches to grand wedding celebrations, we deliver excellence at every scale.',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
              color: AppColors.darkGrey,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Golden Divider
        Container(
          width: 100,
          height: 4,
          decoration: BoxDecoration(
            gradient: AppColors.premiumGoldGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildServicesGrid(BuildContext context) {
    final services = [
      _ServiceData(
        title: 'Corporate & Contract Catering',
        description: 'Premium catering solutions for offices, cafeterias, and corporate events with rotational menus.',
        icon: FontAwesomeIcons.building,
        gradient: AppColors.corporateGradient,
        color: AppColors.corporateBlue,
        features: ['Office Catering', 'Staff Cafeterias', 'Gala Dinners'],
        capacity: '50-2000 Guests',
        serviceType: 'Corporate',
      ),
      _ServiceData(
        title: 'Wedding & Private Banquets',
        description: 'Bespoke culinary experiences for weddings and intimate gatherings, crafted with elegance.',
        icon: FontAwesomeIcons.ring,
        gradient: AppColors.weddingGradient,
        color: AppColors.weddingGold,
        features: ['Full Service', 'Custom Menus', 'Bridal Showers'],
        capacity: '100-1000 Guests',
        serviceType: 'Luxury',
      ),
      _ServiceData(
        title: 'Live Interactive Stations',
        description: 'Engaging live cooking stations where chefs prepare gourmet dishes right before your eyes.',
        icon: FontAwesomeIcons.utensils,
        gradient: AppColors.liveGradient,
        color: AppColors.liveStationOrange,
        features: ['Pasta Station', 'Sushi Bar', 'Live Carving'],
        capacity: '50+ Guests',
        serviceType: 'Interactive',
      ),
      _ServiceData(
        title: 'Event Infrastructure',
        description: 'Complete event setup including furniture, tents, lighting, and décor for seamless execution.',
        icon: FontAwesomeIcons.campground,
        gradient: AppColors.infrastructureGradient,
        color: AppColors.infrastructureCharcoal,
        features: ['Furniture Rental', 'Marquees', 'Lighting'],
        capacity: 'Any Scale',
        serviceType: 'Support',
      ),
      _ServiceData(
        title: 'Private Parties',
        description: 'Tailored catering for birthdays, anniversaries, and exclusive private celebrations.',
        icon: FontAwesomeIcons.champagneGlasses,
        gradient: LinearGradient(colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)]),
        color: AppColors.partyPurple,
        features: ['Themed Menus', 'Party Platters', 'Mixology'],
        capacity: '20-300 Guests',
        serviceType: 'Private',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        if (constraints.maxWidth > 900) {
          crossAxisCount = 3; // Desktop (3 cols like 3x2 grid)
        } else if (constraints.maxWidth > 600) {
          crossAxisCount = 2; // Tablet (600-900px)
        } else {
          crossAxisCount = 1; // Mobile (<600px)
        }

        return Wrap(
          spacing: 24,
          runSpacing: 24,
          alignment: WrapAlignment.center,
          children: services.map((service) {
            return SizedBox(
              width: crossAxisCount == 1 
                  ? constraints.maxWidth 
                  : (constraints.maxWidth - (crossAxisCount - 1) * 24) / crossAxisCount,
              child: _ServiceCard(service: service),
            );
          }).toList(),
        );
      },
    );
  }
}

class _ServiceData {
  final String title;
  final String description;
  final IconData icon;
  final Gradient gradient;
  final Color color;
  final List<String> features;
  final String capacity;
  final String serviceType;

  _ServiceData({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.color,
    required this.features,
    required this.capacity,
    required this.serviceType,
  });
}

class _ServiceCard extends StatefulWidget {
  final _ServiceData service;

  const _ServiceCard({required this.service});

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.025).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _elevationAnimation = Tween<double>(begin: 4.0, end: 12.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(bool hovering) {
    setState(() => _isHovered = hovering);
    if (hovering) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              height: 480, // Increased height for more details
              decoration: BoxDecoration(
                color: AppColors.pureWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isHovered ? widget.service.color : Colors.transparent,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.service.color.withOpacity(_isHovered ? 0.2 : 0.05),
                    blurRadius: _elevationAnimation.value * 2,
                    offset: Offset(0, _elevationAnimation.value / 2),
                    spreadRadius: _isHovered ? 2 : 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Stack(
                    children: [
                      // Gradient Header
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: widget.service.gradient,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                        ),
                      ),
                      // Service Type Badge
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.service.serviceType.toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: widget.service.color,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),
                      // Icon Circle
                      Positioned(
                        bottom: 0,
                        left: 24,
                        child: Transform.translate(
                          offset: const Offset(0, 32),
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: FaIcon(
                                widget.service.icon,
                                size: 28,
                                color: widget.service.color,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Capacity Badge
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.softWhite,
                              border: Border.all(color: AppColors.lightGrey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.people_outline, size: 12, color: AppColors.mediumGrey),
                                const SizedBox(width: 4),
                                Text(
                                  widget.service.capacity,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: AppColors.mediumGrey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Title
                          Text(
                            widget.service.title,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.logoDeepBlack,
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // Description
                          Text(
                            widget.service.description,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.darkGrey,
                              height: 1.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Divider
                          Container(height: 1, color: AppColors.lightGrey),
                          
                          const SizedBox(height: 16),
                          
                          // Features List with Checkmarks
                          ...widget.service.features.map((feature) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  size: 16,
                                  color: widget.service.color.withOpacity(0.8),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  feature,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.logoCharcoalGrey,
                                  ),
                                ),
                              ],
                            ),
                          )).toList(),
                          
                          const Spacer(),
                          
                          // CTA Button
                          GestureDetector(
                            onTap: () => context.go('/services'), // Navigate to Service Page
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                gradient: _isHovered 
                                    ? AppColors.premiumGoldGradient 
                                    : null,
                                border: Border.all(
                                  color: _isHovered 
                                      ? Colors.transparent 
                                      : widget.service.color,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  _isHovered ? 'VIEW DETAILS' : 'LEARN MORE',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: _isHovered 
                                        ? AppColors.logoDeepBlack 
                                        : widget.service.color,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
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
        },
      ),
    );
  }
}
