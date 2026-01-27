import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/app_config_provider.dart';
import '../../../core/models/region.dart';
import '../../../config/theme/colors.dart';

/// Premium Service Areas Section
/// Responsive grid with animated location cards
/// Golden accent system with hover effects
class ServiceAreasSection extends StatelessWidget {
  const ServiceAreasSection({super.key});

  // Punjab/Pakistan locations only
  static const List<String> pakistanLocations = [
    'Gujranwala',
    'Lahore',
    'Faisalabad',
    'Sialkot',
    'Wazirabad',
    'Daska',
    'Kamoke',
    'Gujrat',
    'Chiniot',
    'Jaranwala',
  ];

  @override
  Widget build(BuildContext context) {
    final locations = pakistanLocations;
    const heading = 'Serving All of Punjab & Pakistan';
    const subheading = 'Premium catering services across all major cities';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      color: AppColors.softWhite,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Section Label
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.premiumGoldMedium, width: 1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'SERVICE AREAS',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.premiumGoldMedium,
                    letterSpacing: 3.0,
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Main Heading
              Text(
                heading,
                style: GoogleFonts.inter(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: AppColors.logoDeepBlack,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Subheading
              Text(
                subheading,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGrey,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Gold Accent Divider
              Container(
                width: 60,
                height: 3,
                decoration: BoxDecoration(
                  gradient: AppColors.premiumGoldGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              const SizedBox(height: 60),
              
              // Location Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  // Responsive grid columns
                  int crossAxisCount;
                  if (constraints.maxWidth > 900) {
                    crossAxisCount = 4; // Desktop
                  } else if (constraints.maxWidth > 600) {
                    crossAxisCount = 3; // Tablet
                  } else {
                    crossAxisCount = 2; // Mobile
                  }
                  
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 2.2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: locations.length,
                    itemBuilder: (context, index) {
                      return _LocationCard(locationName: locations[index]);
                    },
                  );
                },
              ),
              
              const SizedBox(height: 60),
              
              // Large Gold CTA Button
              _buildGoldCTAButton(context),
              
              const SizedBox(height: 32),
              
              // Footer note
              Text(
                'Providing professional catering services across all major districts',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.mediumGrey,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoldCTAButton(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('/contact'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
          decoration: BoxDecoration(
            gradient: AppColors.premiumGoldGradient,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: AppColors.premiumGoldMedium.withOpacity(0.4),
                blurRadius: 24,
                offset: const Offset(0, 8),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
               Icon(
                Icons.location_on_rounded,
                color: AppColors.logoDeepBlack,
                size: 22,
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  'CHECK AVAILABILITY',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.logoDeepBlack,
                    letterSpacing: 2.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Premium Location Card with Hover Animation
class _LocationCard extends StatefulWidget {
  final String locationName;
  
  const _LocationCard({required this.locationName});

  @override
  State<_LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<_LocationCard> 
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _shadowAnimation = Tween<double>(begin: 8, end: 12).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHover(bool hovering) {
    setState(() => _isHovered = hovering);
    if (hovering) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.pureWhite,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isHovered 
                      ? AppColors.premiumGoldMedium 
                      : AppColors.logoCharcoalGrey.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered
                        ? AppColors.premiumGoldMedium.withOpacity(0.15)
                        : Colors.black.withOpacity(0.06),
                    blurRadius: _shadowAnimation.value,
                    offset: const Offset(0, 4),
                    spreadRadius: _isHovered ? 2 : 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Location Icon
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _isHovered 
                          ? AppColors.premiumGoldMedium.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.location_on_outlined,
                      color: _isHovered 
                          ? AppColors.premiumGoldLight 
                          : AppColors.mediumGrey,
                      size: 22,
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Location Name
                  Flexible(
                    child: Text(
                      widget.locationName,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _isHovered 
                            ? AppColors.logoDeepBlack
                            : AppColors.darkGrey,
                        letterSpacing: 0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
