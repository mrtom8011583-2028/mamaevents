import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

/// Premium Service Offerings Section
/// Showcases 4 core service categories
/// Premium catering services
class ServiceOfferingsSection extends StatelessWidget {
  const ServiceOfferingsSection({super.key});

  static const List<ServiceOffering> services = [
    ServiceOffering(
      icon: Icons.business_center,
      title: 'Corporate & Contract Catering',
      description: 'Long-term solutions for offices, schools, and institutions. Daily meal programs, conference catering, and employee dining services.',
      features: [
        'Daily meal programs',
        'Conference & meeting catering',
        'Employee dining solutions',
        'Flexible contracts',
      ],
      color: Color(0xFF212121), // Black
    ),
    ServiceOffering(
      icon: Icons.celebration,
      title: 'Wedding & Private Banquets',
      description: 'Full-scale event management for your special day. From intimate gatherings to grand celebrations with complete coordination.',
      features: [
        'Wedding banquets',
        'Anniversary celebrations',
        'Private parties',
        'Full event management',
      ],
      color: Color(0xFF5A5A5A), // Dark Grey
    ),
    ServiceOffering(
      icon: Icons.local_fire_department,
      title: 'Live Interactive Stations',
      description: 'Chef-led cooking stations that bring the culinary experience to your guests. Fresh, personalized, and entertaining.',
      features: [
        'Shawarma & Kebab stations',
        'Live Pasta & Italian bar',
        'BBQ grill stations',
        'Asian wok experience',
      ],
      color: Color(0xFF424242), // Charcoal
    ),
    ServiceOffering(
      icon: Icons.groups,
      title: 'Event Infrastructure',
      description: 'Complete event logistics including seating, barriers, crowd control, and security. Professional setup for any scale.',
      features: [
        'Seating & furniture rental',
        'Crowd control barriers',
        'Security coordination',
        'Complete event logistics',
      ],
      color: Color(0xFF757575), // Medium Grey
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFAFAFA),
            Color(0xFFFFFFFF),
          ],
        ),
      ),
      child: Column(
        children: [
          // Section Header
          Text(
            'OUR SERVICES',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF5A5A5A),
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 16),
          
          Text(
            'Comprehensive Catering Solutions',
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
                colors: [Color(0xFF5A5A5A), Color(0xFF212121)],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Text(
              'From intimate corporate lunches to grand wedding celebrations, we deliver excellence at every scale.',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: const Color(0xFF616161),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 60),
          
          // Services Grid
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 1100) {
                // Desktop: 2x2 grid
                return _buildServicesGrid(2);
              } else if (constraints.maxWidth > 700) {
                // Tablet: 2 columns
                return _buildServicesGrid(2);
              } else {
                // Mobile: 1 column
                return _buildServicesGrid(1);
              }
            },
          ),
          
          const SizedBox(height: 60),
          
          // CTA
          ElevatedButton(
            onPressed: () {
              context.go('/services');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF212121),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'View All Services',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesGrid(int columns) {
    return Wrap(
      spacing: 32,
      runSpacing: 32,
      alignment: WrapAlignment.center,
      children: services.map((service) {
        return SizedBox(
          width: columns == 1 ? double.infinity : 480,
          child: ServiceCard(service: service),
        );
      }).toList(),
    );
  }
}

/// Service Card Widget
/// Premium card with icon, title, description, and features
class ServiceCard extends StatefulWidget {
  final ServiceOffering service;
  
  const ServiceCard({
    super.key,
    required this.service,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered 
                ? widget.service.color 
                : const Color(0xFFE0E0E0),
            width: _isHovered ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.service.color.withOpacity(_isHovered ? 0.15 : 0.05),
              blurRadius: _isHovered ? 24 : 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.service.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                widget.service.icon,
                size: 40,
                color: widget.service.color,
              ),
            ),
            const SizedBox(height: 24),
            
            // Title
            Text(
              widget.service.title,
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 16),
            
            // Description
            Text(
              widget.service.description,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF616161),
                height: 1.7,
              ),
            ),
            const SizedBox(height: 24),
            
            // Features
            ...widget.service.features.map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: widget.service.color,
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
            
            // Learn More Link
            TextButton(
              onPressed: () {
                context.go('/services');
              },
              style: TextButton.styleFrom(
                foregroundColor: widget.service.color,
                padding: EdgeInsets.zero,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Learn More',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Service Offering Data Model
class ServiceOffering {
  final IconData icon;
  final String title;
  final String description;
  final List<String> features;
  final Color color;

  const ServiceOffering({
    required this.icon,
    required this.title,
    required this.description,
    required this.features,
    required this.color,
  });
}
