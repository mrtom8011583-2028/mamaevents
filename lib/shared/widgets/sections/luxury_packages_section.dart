import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

/// 5-Tier Luxury Packages Section
/// Premium pricing tiers for catering services
/// Designed with luxury aesthetic and clear value proposition
class LuxuryPackagesSection extends StatelessWidget {
  const LuxuryPackagesSection({super.key});

  static const List<PackageData> packages = [
    PackageData(
      tier: 1,
      name: 'The Essential Collection',
      tagline: 'Refined Simplicity',
      description: 'Single-course selections with express delivery.',
      idealFor: 'Office Lunches',
      imageUrl: 'https://images.unsplash.com/photo-1577308856961-0e97146ba5e8?q=80&w=800&auto=format&fit=crop', // Catering Setup
      features: [
        'Single-course menu selection',
        'Express delivery service',
        'Disposable premium packaging',
        'Perfect for 10-50 guests',
      ],
      popular: false,
    ),
    PackageData(
      tier: 2,
      name: 'The Heritage Classic',
      tagline: 'Most Popular',
      description: '2-course buffet with premium crockery and full setup.',
      idealFor: 'Birthdays',
      imageUrl: 'https://images.unsplash.com/photo-1555244162-803834f70033?q=80&w=800&auto=format&fit=crop', // Buffet
      features: [
        '2-course buffet spread',
        'Premium crockery & cutlery',
        'Complete setup & cleanup',
        'Perfect for 50-100 guests',
      ],
      popular: true,
    ),
    PackageData(
      tier: 3,
      name: 'The Signature Selection',
      tagline: 'Premium Experience',
      description: '3-course menu with live cooking stations and uniformed staff.',
      idealFor: 'Corporate Events & Engagements',
      imageUrl: 'https://images.unsplash.com/photo-1519225421980-715cb0202128?q=80&w=800&auto=format&fit=crop', // Corporate/Formal
      features: [
        '3-course gourmet menu',
        'Live cooking stations',
        'Professional uniformed staff',
        'Perfect for 100-200 guests',
      ],
      popular: false,
    ),
    PackageData(
      tier: 4,
      name: 'The Grand Banquet',
      tagline: 'Wedding Excellence',
      description: 'Multi-cuisine gala with luxury decor and unlimited appetizers.',
      idealFor: 'Weddings',
      imageUrl: 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?q=80&w=800&auto=format&fit=crop', // Wedding
      features: [
        'Multi-cuisine gala spread',
        'Luxury event decor',
        'Unlimited appetizers',
        'Perfect for 200-500 guests',
      ],
      popular: false,
    ),
    PackageData(
      tier: 5,
      name: 'The Sovereign Experience',
      tagline: 'Ultimate Luxury',
      description: 'VIP sit-down service with exotic ingredients and dedicated event concierge.',
      idealFor: 'VIP Events',
      imageUrl: 'https://images.unsplash.com/photo-1559339352-11d035aa65de?q=80&w=800&auto=format&fit=crop', // luxury dining
      features: [
        'VIP sit-down service',
        'Exotic premium ingredients',
        'Dedicated event concierge',
        'Bespoke customization',
      ],
      popular: false,
      bespoke: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      color: Colors.white,
      child: Column(
        children: [
          // Section Header
          Text(
            'CATERING PACKAGES',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF5A5A5A),
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 16),
          
          Text(
            'Luxury Service Tiers',
            style: GoogleFonts.playfairDisplay(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF212121),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFC6A869), Color(0xFF212121)], // Gold to Black
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          
          Text(
            'From intimate gatherings to grand celebrations, find your perfect package.',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: const Color(0xFF616161),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          
          // Packages Grid
          LayoutBuilder(
            builder: (context, constraints) {
              // Responsive layout
              if (constraints.maxWidth > 1200) {
                // Desktop: 3 columns
                return _buildPackagesGrid(context, 3);
              } else if (constraints.maxWidth > 768) {
                // Tablet: 2 columns
                return _buildPackagesGrid(context, 2);
              } else {
                // Mobile: 1 column
                return _buildPackagesGrid(context, 1);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPackagesGrid(BuildContext context, int columns) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Wrap(
          spacing: 24,
          runSpacing: 24,
          alignment: WrapAlignment.center,
          children: packages.map((package) {
            // Calculate responsive card width based on columns
            double cardWidth;
            if (columns == 3) {
              // 3 columns: (1400 - 2*24px spacing) / 3 ≈ 450px max
              cardWidth = 380.0;
            } else if (columns == 2) {
              // 2 columns: (1400 - 24px spacing) / 2 ≈ 688px max
              cardWidth = 480.0;
            } else {
              // 1 column: Full width with padding
              cardWidth = double.infinity;
            }
            
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: cardWidth,
                minWidth: columns == 1 ? double.infinity : 280,
              ),
              child: PackageCard(package: package),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Individual Package Card
/// Premium card design with hover effects and clear CTAs
class PackageCard extends StatefulWidget {
  final PackageData package;
  
  const PackageCard({
    super.key,
    required this.package,
  });

  @override
  State<PackageCard> createState() => _PackageCardState();
}

class _PackageCardState extends State<PackageCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isPopular = widget.package.popular;
    final isBespoke = widget.package.bespoke;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPopular 
                ? const Color(0xFFC6A869) // Gold for popular
                : _isHovered 
                    ? const Color(0xFF212121) // Black on hover
                    : const Color(0xFFE0E0E0), // Gray default
            width: isPopular ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.12 : 0.06),
              blurRadius: _isHovered ? 20 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Package Header with Image Placeholder
            Stack(
              children: [
                // Image Section
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Image.network(
                      widget.package.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFF5F5F5),
                          child: Center(
                            child: Icon(
                              Icons.restaurant_menu,
                              size: 40,
                              color: Colors.grey[400],
                            ),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: const Color(0xFFF5F5F5),
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / 
                                    loadingProgress.expectedTotalBytes!
                                  : null,
                              color: const Color(0xFFC6A869),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                // Popular Badge
                if (isPopular)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC6A869), // Luxury Gold
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Text(
                        'MOST POPULAR',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                
                // Tier Badge
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'TIER ${widget.package.tier}',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Package Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Package Name
                  Text(
                    widget.package.name,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Tagline
                  Text(
                    widget.package.tagline,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFC6A869), // Gold
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Description
                  Text(
                    widget.package.description,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF616161),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Ideal For
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_outline,
                          size: 16,
                          color: Color(0xFF212121),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Ideal for ${widget.package.idealFor}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF212121),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Features List
                  ...widget.package.features.map((feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 18,
                          color: Color(0xFF212121),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            feature,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: const Color(0xFF424242),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                  
                  const SizedBox(height: 24),
                  
                  // CTA Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.go('/contact');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isBespoke 
                            ? const Color(0xFFC6A869) // Gold for bespoke
                            : const Color(0xFF212121), // Black
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: _isHovered ? 4 : 2,
                      ),
                      child: Text(
                        isBespoke ? 'Request Bespoke Quote' : 'Get Quote',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Package Data Model
class PackageData {
  final int tier;
  final String name;
  final String tagline;
  final String description;
  final String idealFor;
  final String imageUrl;
  final List<String> features;
  final bool popular;
  final bool bespoke;

  const PackageData({
    required this.tier,
    required this.name,
    required this.tagline,
    required this.description,
    required this.idealFor,
    required this.imageUrl,
    required this.features,
    this.popular = false,
    this.bespoke = false,
  });
}
